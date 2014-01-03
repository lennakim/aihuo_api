class Order < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  encrypted_id key: 'bYqILlFMZn3xd8Cy'
  # includes ..................................................................
  include EncryptedIdFinder
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :express, foreign_key: "shippingorder_id"
  has_many :line_items
  has_many :comments
  has_many :orderlogs
  has_many :short_messages
  has_and_belongs_to_many :coupons
  # validations ...............................................................
  validates :device_id, presence: true
  validates :name, presence: true
  validates :phone, presence: true
  validates :shipping_charge, presence: true, numericality: true
  # callbacks .................................................................
  before_destroy :logging_action
  before_create :compose_ship_address
  after_create :calculate_item_total
  # after_create :send_confirm_sms
  after_create :register_device
  after_create :destroy_cart
  # scopes ....................................................................
  scope :by_filter, ->(filter) { filter == :rated ? with_comments : self }
  scope :with_comments, -> { joins(:comments) }
  scope :newly, -> { where(state: "订单已下，等待确认") }
  scope :done, -> { where("state = ? OR state = ? OR state like ?", "客户拒签，原件返回", "客户签收，订单完成", "%取消%") }
  # additional config .........................................................
  delegate :extra_order_id, to: :express
  accepts_nested_attributes_for :line_items
  # class methods .............................................................
  # public instance methods ...................................................
  def number
    created_at.to_i.to_s + (id * 2 + 19871030).to_s
  end

  # 订单总价兼容新版本用户查看旧版订单
  def total
    total = item_total.zero? ? price : item_total
    return (total + shipping_charge).to_f
  end

  def express_number
    number = express ? extra_order_id : delivery_no
    number.strip if number
  end

  def calculate_with_coupon(coupon)
    if item_total > coupon.additional_condition && can_use_coupon?(coupon)
      case coupon.category
      when 1 # 运费
        new_shipping_charge = shipping_charge - coupon.money
        new_shipping_charge = 0 if new_shipping_charge < 0
        update_attribute(:shipping_charge, new_shipping_charge)
      when 8 # 总价减免
        update_attribute(:item_total, item_total * coupon.money)
      when 9 # 总价减折扣
        update_attribute(:item_total, item_total - coupon.money)
      end
      coupon.used!
      coupons << coupon
    end
  end

  def calculate_total_by_coupon(coupon_id)
    return if coupon_id.blank?
    return unless Coupon.by_device(device_id).enabled.collect(&:to_param).include?(coupon_id) # 如果优惠劵已经作废
    coupon = Coupon.find coupon_id
    # FIXME: 如果 id 是虚构的，则会造成程序出错
    return if coupon.blank? # 优惠劵ID是错误的
    calculate_with_coupon(coupon)
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def compose_ship_address
    self.address =
      "#{shipping_province} #{shipping_city} #{shipping_district} #{shipping_address}"
  end

  def logging_action
    orderlogs.logging_action(:delete, device_id)
  end

  # for update order on api and back end.
  def calculate_item_total
    item_total = line_items.inject(0){ |sum, item| sum + item.sale_price * item.quantity }
    update({item_total: item_total})
  end

  # send sms if create order successful.
  def send_confirm_sms
    ShortMessage.send_confirm_sms(self)
  end

  def destroy_cart
    carts = Cart.where(device_id: device_id, application_id: application_id)
    carts.destroy_all if carts
  end

  def register_device
    Device.where(device_id: device_id).first_or_create! if device_id.present?
  end

  # 订单创建的时候，优惠劵是否在有效期之内
  def can_use_coupon?(coupon)
    coupon.start_time.beginning_of_day < created_at && coupon.end_time.end_of_day > created_at
  end
end
