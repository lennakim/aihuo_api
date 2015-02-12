class Notification < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :application
  # validations ...............................................................
  validates :application_id, presence: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # push_type: 1 单个人, 2 一群人, 3 所有人
  # message_type: 0 消息(透传), 1 通知
  DEFAULT_MSG_OPTIONS = {
    notice_id: nil,
    notice_type: "Article",
    push_type: 1,
    message_type: 1,
  }
  # class methods .............................................................
  # 刚注册的用户，发送第一条0元购的通知
  def self.send_sales_promotion_msg(device_id, app_id = nil)
    # 爱侣应用发送另外一条0元购通知
    # article_id = app_id == 32 ? "1239" : Article.gifts.pluck(:id).first
    #
    article_id = Article.gifts.pluck(:id).first
    title = "0元购三天，您还等神马？！"
    desc = "0元带性福回家，只对新用户只限3天！再不抢就没啦！！！"
    self.package_message_parameters_and_send_msg(device_id, article_id, title, desc)
  end

  def self.send_article_for_the_first_time_to_create_cart(device_id, app_id = nil)
    article_id, title =
      if app_id == 28
        ["1442", "找到她，喂你实惠"]
      elsif app_id == 62
        ["1444", "对产品感兴趣？找她有惊喜哦"]
      else
        ['', '']
      end
    return if article_id.blank?
    self.package_message_parameters_and_send_msg(device_id, article_id, title)
  end

  # 给小纸条的接收者发送消息
  def self.send_private_message_msg(device_id)
    title = "你收到一条新的纸条"
    desc = "有人给你发送一条小纸条，点击查看内容"
    type = "PrivateMessage"
    self.package_message_parameters_and_send_msg(device_id, '', title, desc, type)
  end

  # 新回复给被回复者发送消息
  def self.send_reply_message_msg(device_id)
    title = "你收到一条新的回复"
    desc = "有人给你回复啦，点击查看内容"
    type = "Reply"
    self.package_message_parameters_and_send_msg(device_id, '', title, desc, type)
  end

  def self.package_message_parameters_and_send_msg(device_id, id, title, desc = '', type = "Article")
    options = self::DEFAULT_MSG_OPTIONS.merge({
      notice_type: type,
      notice_id: id,
      title: title,
      description: desc
    })
    self.send_msg(device_id, options)
  end

  def self.send_msg(device_id, options = {})
    device_info = DeviceInfo.where(device_id: device_id).first
    return unless device_info
    options.merge!({
      application_id: device_info.application_id,
      user_id: device_info.baidu_user_id,
      channel_id: device_info.baidu_channel_id,
    })
    case device_info.baidu_channel_id
    when "getui"
      GetuiPusher.push_msg(options)
    else
      BaiduPusher.push_msg(options)
    end
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
  # http://rubyquicktips.com/post/17698867568/making-class-methods-private
end
