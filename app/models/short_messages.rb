class ShortMessage < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :order
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  scope :today, -> { where(:created_at => Date.today.beginning_of_day..Date.today.end_of_day) }
  scope :sended, -> { where.not(order_id: nil) }
  # additional config .........................................................
  # class methods .............................................................
  def self.send_confirm_sms(order)
    username = Setting.where(name: "sms_key").first.value
    password = Setting.where(name: "sms_pwd").first.value
    device_id = order.device_id
    # 每个设备每天只能发送5条SMS
    if self.can_send_sms_to_device?(device_id)
      ChinaSMS.use :emay, username: username, password: password
      msg_type = order.shipping_address.blank? ? 0 : 1
      content = confirm_msg(order.total, msg_type)
      result = ChinaSMS.to order.phone, content
      if result[:success]
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
  end

  def self.can_send_sms_to_device?(device_id)
    sended.today.where(device_id: device_id).count < 5
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
