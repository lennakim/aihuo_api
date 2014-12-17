class Order < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  # includes ..................................................................
  include EncryptedId, MergePendingOrder, Commable
  # relationships .............................................................
  belongs_to :express, foreign_key: "shippingorder_id"
  has_many :line_items
  has_many :line_item_commments, source: :review, through: :line_items
  has_many :gift_items, -> { where(sale_price: 0) }, class_name: "LineItem"
  has_many :comments
  has_many :orderlogs
  has_many :short_messages
  has_many :payments
  has_and_belongs_to_many :coupons
  # validations ...............................................................
  validates :device_id, presence: true
  validates :name, presence: true
  validates :phone, presence: true
  validates :shipping_charge, presence: true, numericality: true
  # callbacks .................................................................
  before_destroy :logging_action
  before_create :compose_ship_address
  # after_create :merge_pending_orders # this method called in controller
  after_create :calculate_item_total
  after_create :register_device
  after_create :destroy_cart
  # scopes ....................................................................
  default_scope { order("id DESC") }
  scope :by_filter, ->(filter) { filter == :rated ? with_comments : all }
  scope :with_comments, -> { joins(:comments).where("comments.content IS NOT NULL") }
  scope :newly, -> { where(state: NEWLY_STATE) }
  scope :done, -> { where("state = ? OR state = ? OR state like ?", "客户拒签，原件返回", "客户签收，订单完成", "%取消%") }
  # +pay_type+ attribute according to the following logic:
  #
  # 0 means '先付款后发货'
  # 1 means '货到付款'
  # Notice: 目前版本不涉及到分期付款所以只根据 payment total 是否为 0 来判断是否已经付费
  # scope :unpaid, -> { where(pay_type: 0).where.not(payment_state: 'paid') }
  scope :unpaid, -> {
    where(pay_type: 0)
      .where(
        "payment_state IS NULL OR (payment_state != ? AND payment_state != ?)",
        'paid',
        'credit_owed'
      )
  }
  scope :in_a_week, -> {
    where(orders: { created_at: 1.weeks.ago(Date.today)..Date.today })
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'bYqILlFMZn3xd8Cy'
  delegate :extra_order_id, to: :express
  accepts_nested_attributes_for :line_items

  NEWLY_STATE = "订单已下，等待确认"
  DONE_STATES = [
    "客户拒签，原件返回",
    "客户签收，订单完成",
    "客户放弃，订单取消",
    "无法联系客户，订单取消",
    "有拒签记录，订单取消",
    "非本人下单，订单取消",
    "重复订单，订单取消",
  ]
  # class methods .............................................................
  # public instance methods ...................................................
  # 订单中是否包含0元购的产品
  def has_gift?
    gift_items.sum(:quantity) > 0
  end

  def number
    created_at.to_i.to_s + (id * 2 + 19871030).to_s
  rescue
    '异常订单号'
  end

  # 购买记录中的订单创建时间显示第一条评论的评论时间
  def commented_at
    if comments && !comments.size.zero?
      comments.first.comment_at || comments.first.created_at
    else
      created_at
    end
  end

  # 订单总价兼容新版本用户查看旧版订单
  def total
    total = item_total.zero? ? price : item_total
    return (total + shipping_charge).to_f
  end

  # 运单号有两种情况:
  #  extra_order_id 从ERP同步回来的运单, 储存在 shippingorders 中
  #  delivery_no 自己填写的运单号, 储存在 orders 中
  def express_number
    number = express ? extra_order_id : delivery_no
    number.strip if number
  end
  # 运单类型
  def express_company
    (express.company.nil? || "" == express.company) ?  judge_express_company(express.extra_order_id) : express.company
  end
  # 满就包邮
  def calculate_shipping_charge
    if pay_type == 0 && item_total >= 79 || pay_type == 1 && item_total >= 199
      update_column(:shipping_charge, 0)
    end
  end

  # 优惠劵逻辑
  def calculate_with_coupon(coupon, additional = false)
    if item_total > coupon.additional_condition && can_use_coupon?(coupon)
      case coupon.category
      when 1 # 运费
        new_shipping_charge = shipping_charge - coupon.money
        new_shipping_charge = 0 if new_shipping_charge < 0
        update_attribute(:shipping_charge, new_shipping_charge)
      when 8 # 总价折扣
        update_attribute(:item_total, item_total * coupon.money)
      when 9 # 总价减免
        update_attribute(:item_total, item_total - coupon.money)
      end
      coupon.used!
      # 优惠劵被使用过后，加入关联表作为记录
      coupons << coupon if additional
    end
  end

  # validate 参数用来标示，优惠劵是否需要验证在有效期内
  def calculate_total_by_coupon(coupon_id, validate = true, additional = false)
    return if coupon_id.blank?

    # 有效的优惠劵不包含本卷，说明如果优惠劵已经作废
    return if validate && !Coupon.by_device(device_id).enabled.collect(&:to_param).include?(coupon_id)
    coupon = Coupon.find coupon_id

    # FIXME: 如果 id 是虚构的，则会造成程序出错
    # 优惠劵ID是错误的
    return if coupon.blank?
    calculate_with_coupon(coupon, additional)
  end

  # 利用优惠劵重新计算订单的产品价格和运费
  def calculate_total_by_coupons(coupon_ids, additional = false)
    coupon_ids.each { |coupon_id| calculate_total_by_coupon(coupon_id, true, additional) }
  end

  def payments_total
    payments.inject(0) { |sum, payment| sum + payment.amount }
  end

  def calculate_payment_total
    update_attributes!({payment_total: payments_total})
    update_payment_state
  end

  # Updates the +payment_state+ attribute according to the following logic:
  #
  # paid          when +payment_total+ is equal to +total+
  # balance_due   when +payment_total+ is less than +total+
  # credit_owed   when +payment_total+ is greater than +total+
  # failed        when most recent payment is in the failed state
  #
  # The +payment_state+ value helps with reporting, etc. since it provides a quick and easy way to locate Orders needing attention.
  def update_payment_state
    payment_state =
      if payment_total.zero?
        'failed'
      elsif round_money(payment_total) < round_money(total)
        'balance_due'
      elsif round_money(payment_total) > round_money(total)
        'credit_owed'
      else
        'paid'
      end
    update_column(:payment_state, payment_state)
  end

  def transaction_need_process?(transaction_no)
    self.payments.where(transaction_no: transaction_no).blank?
  end

  def process_payment(transaction_no, amount)
    orderlogs.logging_action(:order_pay, amount)
    payment = self.payments.where(transaction_no: transaction_no).first_or_create
    payment.process(amount)
    calculate_payment_total
  end

  # 订单内含0元购返回的消息逻辑:
  #
  # 在线支付(先付款后发货) pay_type 0
  #   一个0元购
  #     订单总价0元 =>
  #     订单总价多元 =>
  #   多个0元购
  #     订单总价0元 => 0元购商品只能包含一件哦，稍候客服会协助您修改订单。
  #     订单总价多元 => 0元购商品只能包含一件哦，稍候客服会协助您修改订单。
  #
  # 货到付款 pay_type 1
  #   一个0元购
  #     订单总价0元 => 您的订单中产品总价是0元，请再挑选一件商品以便我们尽快安排发货。
  #     订单总价多元 =>
  #   多个0元购
  #     订单总价0元 => 您的订单中产品总价是0元，请再挑选一件商品以便我们尽快安排发货。
  #     订单总价多元 => 0元购商品只能包含一件哦，稍候客服会协助您修改订单。
  def message
    case pay_type
    when 0
      "0元购商品只能包含一件哦，稍候客服会协助您修改订单。" if has_gift?
    when 1
      if item_total == 0
        "您的订单中产品总价是0元，请再挑选一件商品以便我们尽快安排发货。"
      elsif has_gift?
        "0元购商品只能包含一件哦，稍候客服会协助您修改订单。"
      end
    end
  end

  def send_confirm_sms(type)
    ShortMessage.send_confirm_sms(self, type)
  end

  # 订单可操作状态码，1 可取消; 2 可删除; 0 不可更改状态
  def operation_code
    if can_cancel?
      1
    elsif can_delete?
      2
    else
      0
    end
  end

  # "订单已下，等待确认" 并且支付价格是 0 的订单可以取消
  def can_cancel?
    state == NEWLY_STATE && payment_total == 0
  end

  # 包含 "取消" 关键字的订单可以取消
  def can_delete?
    DONE_STATES.include? state
  end

  def cancel!
    update_attribute(:state, "客户放弃，订单取消")
    orderlogs.logging_action(:cancel, device_id)
  end

  def cancel_or_delete_by_client
    case operation_code
    when 1
      cancel!
    when 2
      destroy
    else
      false
    end
  end

  def comment_by_product(product)
    line_item_commments.find_by(product_id: product.id) || comments.try(:first)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  
   #根据订单号判断属于那家公司订单
  def judge_express_company(extra_order_id)
    reg_ems = /^D(\d){9}$/
    reg_yuan = /^(\d){10}$/
    reg_yuan_12 = /^d(\d){11}$/
    reg_feng = /^(\d){12}$/
    if reg_yuan =~ extra_order_id || reg_yuan_12 =~ extra_order_id
      "圆通快递"
    elsif reg_ems =~ extra_order_id
      "邮政ems"
    elsif reg_feng =~ extra_order_id
      "顺丰快递"
    else
      "圆通快递"
    end
  end
  
  def round_money(n)
    (n * 100).round / 100.0
  end

  def compose_ship_address
    self.address =
      "#{shipping_province} #{shipping_city} #{shipping_district} #{shipping_address}"
  end

  def logging_action
    orderlogs.logging_action(:delete, device_id)
  end

  # 创建订单后删除购物车
  def destroy_cart
    carts = Cart.where(device_id: device_id, application_id: application_id)
    carts.destroy_all if carts
  end

  # 创建订单前确认设备存在
  def register_device
    Device.where(device_id: device_id).first_or_create! if device_id.present?
  end

  # 订单创建的时候，优惠劵是否在有效期之内
  def can_use_coupon?(coupon)
    coupon.start_time.beginning_of_day < created_at && coupon.end_time.end_of_day > created_at
  end
end
