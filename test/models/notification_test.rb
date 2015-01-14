require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  def app
    @app ||= Application.find_by(id: 32)
  end

  def device_id
    "863092024963194" # victor's hong mi
  end

  # 刚注册的用户，发送第一条0元购的通知
  def test_send_sales_promotion_msg
    # Notification.send_sales_promotion_msg(device_id, app.id)
  end

  def test_send_reply_message_msg
    # Notification.send_reply_message_msg(device_id)
  end

  def test_send_reply_message_msg
    # Notification.send_reply_message_msg(device_id)
  end

  def test_send_article_for_the_first_time_to_create_cart
    # Notification.send_article_for_the_first_time_to_create_cart(device_id, app.id)
  end
end
