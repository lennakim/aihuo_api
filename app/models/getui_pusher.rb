# encoding: utf-8
class GetuiPusher < Notification
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  #
  # Push getui notification.
  #
  # args - A Hash, include attributes that should be push.
  #
  # Examples
  #
  # args = {
  #   notice_id: 1237,
  #   notice_type: "Article",
  #   push_type: 1,
  #   message_type: 1,
  #   application_id: 28,
  #   user_id: "1129993806436450586",
  #   channel_id: "getui",
  # }
  def self.push_msg(args)
    app = Application.find_by(id: args[:application_id])
    pusher = IGeTui.pusher(app.getui_app_id, app.getui_app_key, app.getui_master_secret)

    # 创建一条透传消息
    template = IGeTui::TransmissionTemplate.new
    # Notice: content should be string.
    content = {
                action: "notification",
                title: args[:title],
                content: args[:description],
                type: args[:notice_type],
                id: args[:notice_id]
              }
    content = content.to_s.gsub(":", "").gsub("=>", ":")
    template.transmission_content = content
    # set iOS push info
    template.set_push_info("ok", 1, args[:title], "")

    # 创建单体消息
    single_message = IGeTui::SingleMessage.new
    single_message.data = template

    # 创建客户端对象
    client = IGeTui::Client.new(args[:user_id])

    # 发送一条通知到指定的客户端
    begin
      ret = pusher.push_message_to_single(single_message, client)
      base_str = "client_id: #{args[:user_id]} content: #{content.inspect} app_id: #{app.getui_app_id} app_key: #{app.getui_app_key} master_secret: #{app.getui_master_secret}"
      base_str += (ret["result"] == "ok" ? " 成功" : "失败#{ret["result"]}")
      MESSAGE_PUSHER_LOGGER.error base_str
      ret["result"] == "ok"
    rescue Exception => e
      MESSAGE_PUSHER_LOGGER.error e.message
    end
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
