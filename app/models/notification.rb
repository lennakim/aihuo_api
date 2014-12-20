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
  # 设备注册(只要访问网站)发送消息
  def self.send_visit_website_msg(device_id, app_id = nil)
    # 爱侣应用发送另外一条0元购通知
    article_id = Setting.fetch_by_key("visit_website_getui_article_id")
    options = self::DEFAULT_MSG_OPTIONS.merge({
      notice_id: article_id,
      title: "0元购三天，您还等神马？！",
      description: "0元带性福回家，只对新用户只限3天！再不抢就没啦！！！"
    })
    self.send_msg(device_id, options, app_id)
  end
  # 刚注册的用户，发送第一条0元购的通知
  def self.send_sales_promotion_msg(device_id, app_id = nil)
    # 爱侣应用发送另外一条0元购通知
    article_id =
      if app_id == 32
        "1239"
      else
        Article.gifts.pluck(:id).first
      end
    options = self::DEFAULT_MSG_OPTIONS.merge({
      notice_id: article_id,
      title: "0元购三天，您还等神马？！",
      description: "0元带性福回家，只对新用户只限3天！再不抢就没啦！！！"
    })
    self.send_msg(device_id, options)
  end

  # 给小纸条的接收者发送消息
  def self.send_private_message_msg(device_id)
    options = self::DEFAULT_MSG_OPTIONS.merge({
      notice_type: "PrivateMessage",
      title: "你收到一条新的纸条",
      description: "有人给你发送一条小纸条，点击查看内容"
    })
    self.send_msg(device_id, options)
  end

  # 新回复给被回复者发送消息
  def self.send_reply_message_msg(device_id)
    options = self::DEFAULT_MSG_OPTIONS.merge({
      notice_type: "Reply",
      title: "你收到一条新的回复",
      description: "有人给你回复啦，点击查看内容"
    })
    self.send_msg(device_id, options)
  end

  def self.send_msg(device_id, options = {}, app_id = nil)
    device_info = app_id.nil? ? DeviceInfo.where(device_id: device_id).first  :  DeviceInfo.where("device_id = ? and application_id = ?", device_id, app_id).first
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
