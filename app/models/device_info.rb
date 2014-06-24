class DeviceInfo < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include EncryptedId
  # relationships .............................................................
  belongs_to :device, :primary_key => "device_id"
  # validations ...............................................................
  validates :device_id, presence: true
  # callbacks .................................................................
  after_create :set_date_tag
  after_create :send_sales_promotion_msg
  # scopes ....................................................................
  default_scope { order("updated_at DESC") }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: '9nUuGnWttYj6ueLU'
  # class methods .............................................................
  # public instance methods ...................................................
  def set_date_tag
    date_tag = device.try(:created_at).strftime("%y%m%d") if device
    update_attribute(:tag_list, date_tag) if date_tag
  end

  # 设备注册之后发送第一条0元购通知
  def send_sales_promotion_msg
    # 设备没有百度用户信息，不发送通知
    return if baidu_user_id.blank?

    # 设备注册时间在3天前，不发送通知
    # 设备注册时间在3天内(前天，昨天，今天)，则发送0元购通知
    # TODO:
    # *Date.today* maybe cached in production mode, so this line alwasy
    #   return same value. need to test and fix it later.
    if device && device.try(:created_at) > 2.days.ago(Date.today)
      Notification.send_sales_promotion_msg(device_id)
    end
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
