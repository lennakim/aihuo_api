class ShortMessage < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :order
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :today, -> { where(:created_at => Date.today.beginning_of_day..Date.today.end_of_day) }
  scope :sended, -> { where.not(order_id: nil) }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  def self.send_confirm_sms(order, type)
    device_id = order.device_id
    # 每个设备每天只能发送5条SMS
    if self.can_send_sms_to_device?(device_id)
      content = confirm_msg(order, type)
      if content.present?
        order.short_messages.create({ device_id: device_id, phone: order.phone, content: content })
        order.orderlogs.logging_action(:send_confirm_sms, content)
      end
    else
      order.orderlogs.logging_action(:send_confirm_sms_error, order.id)
    end
  end

  def self.make_as_sended
    update_all(sended: true)
  end

  def self.can_send_sms_to_device?(device_id)
    sended.today.where(device_id: device_id).count < 6
  end

  def self.send_sms_from_emay(phone, message)
    ChinaSMS.use(
      :emay,
      username: Setting.find_by_name(:sms_key).value,
      password: Setting.find_by_name(:sms_pwd).value
    )
    ChinaSMS.to phone, message
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  # 订单发送短信的逻辑:
  # 创建订单
  #   首张订单
  #     在线付款
  #       订单保存成功 => message: 您的物品加运费共XX元，您已经成功支付XX元。(未实现)
  #       支付成功(不考虑支付一半的情况) => sms: 您的物品加运费共XX元，您已经支付成功X元。正在为您安排发货，保密包装。
  #     货到付款
  #       没有填写地址，没有填写收货人 => 您的物品加运费共XX元，保密包装。回复您的具体地址(省市区县街道)和姓名立刻发货。【订单确认】
  #       没有填写地址，有收货人 => 您的物品加运费共XX元，保密包装。回复您的具体地址(省市区县街道)立刻发货。【订单确认】
  #       有地址，有收货人 => 您的物品加运费共XX元，保密包装。回复数字1立刻发货，2-4天送达。有疑问请联系:4007065868【订单确认】
  #   追加订单
  #     在线付款
  #       订单保存成功 => message: 您的物品加运费共XX元，您已经成功支付XX元。(未实现)
  #       支付成功(不考虑支付一半的情况) => sms: 您的物品加运费共XX元，您已经支付成功X元。正在为您安排发货，保密包装。
  #     货到付款
  #       没有填写地址，没有填写收货人 => 订单已合并，您的物品加运费共XX元，保密包装。回复您的具体地址(省市区县街道)和姓名立刻发货。【订单确认】
  #       没有填写地址，有收货人 => 订单已合并，您的物品加运费共XX元，保密包装。回复您的具体地址(省市区县街道)立刻发货。【订单确认】
  #       有地址，有收货人 => 订单已合并，您的物品加运费共XX元，保密包装。回复数字1立刻发货，2-4天送达。有疑问请联系:4007065868【订单确认】
  #
  # 更新订单
  #   刚才生成的短信已发送 => 修改 message 并根据下列条件发送短信(未实现)
  #   刚才生成的短信未发送 => 修改 message 删除原来短信并根据下列条件发送短信(未实现修改 message)
  #   条件：
  #     没有填写地址，没有填写收货人 => 您的物品加运费共XX元，保密包装。回复您的具体地址(省市区县街道)和姓名立刻发货。【订单确认】
  #     没有填写地址，有收货人 => 您的物品加运费共XX元，保密包装。回复您的具体地址(省市区县街道)立刻发货。【订单确认】
  #     有地址，有收货人(不考虑支付状态) => 您的物品加运费共XX元，保密包装。回复数字1立刻发货，2-4天送达。有疑问请联系:4007065868【订单确认】
  #
  # type may be :create, :update or :merge
  def self.confirm_msg(order, type)
    case order.pay_type
    when 0
      if order.payment_total != 0
        "您的物品加运费共#{order.total}元，您已经支付成功#{order.payment_total}元。正在为您安排发货，保密包装。"
      end
    when 1
      order.short_messages.make_as_sended if type == :update
      prepend_text = type == :merge ? "订单已合并，" : ""
      if order.shipping_address.blank? && order.name.blank?
        "#{prepend_text}您的物品加运费共#{order.total}元，保密包装。回复您的具体地址(省市区县街道)和姓名立刻发货。【订单确认】"
      elsif order.shipping_address.blank?
        "#{prepend_text}您的物品加运费共#{order.total}元，保密包装。回复您的具体地址(省市区县街道)立刻发货。【订单确认】"
      else
        "#{prepend_text}您的物品加运费共#{order.total}元，保密包装。回复数字1立刻发货，2-4天送达。有疑问请联系:4007065868【订单确认】"
      end
    end
  end
end
