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
  def self.send_confirm_sms(order)
    device_id = order.device_id
    # 每个设备每天只能发送5条SMS
    if self.can_send_sms_to_device?(device_id)
      msg_type = order.shipping_address.blank? ? 0 : 1
      content = confirm_msg(order.total, msg_type)
      order.short_messages.create({
        device_id: device_id,
        phone: order.phone,
        content: content
      })
      order.orderlogs.logging_action(:send_confirm_sms, content)
    else
      order.orderlogs.logging_action(:send_confirm_sms_error, order.id)
    end
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
  def self.confirm_msg(money, type = 0)
    case type
    when 0
      "您的物品加运费共#{money}元，货到付款，保密包装。回复您的具体地址(省市区县街道)立刻发货。【订单确认】"
    else
      "您的物品加运费共#{money}元，货到付款，保密包装。回复数字1立刻发货，2-4天送达。有疑问请联系:4007065868【订单确认】"
    end
  end
end
