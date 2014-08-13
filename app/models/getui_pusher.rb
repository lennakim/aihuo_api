class GetuiPusher < Notification
  # extends ...................................................................
  # includes ..................................................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
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

    # 创建单体消息
    single_message = IGeTui::SingleMessage.new
    single_message.data = template

    # 创建客户端对象
    client = IGeTui::Client.new(args[:user_id])

    # 发送一条通知到指定的客户端
    ret = pusher.push_message_to_single(single_message, client)
    ret["result"] == "ok"
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
