require 'test_helper'

class PrivateMessageTest < ActiveSupport::TestCase
  def sender
    Member.find_by(id: 2)
  end

  def receiver
    Member.find_by(id: 3)
  end

  def stranger
    Member.find_by(id: 1)
  end

  def make_members_coin_are_right_before_send_msg
    assert_equal 40, sender.coin_total
    assert_equal 80, receiver.coin_total
  end

  def make_members_coin_are_right_after_send_msg
    assert_equal 35, sender.coin_total
    assert_equal 80, receiver.coin_total
  end

  # 情景1：第一次发小纸条，发送者扣5金币，接收者不扣金币
  def test_sender_send_message_should_reduce_coin
    make_members_coin_are_right_before_send_msg

    message = PrivateMessage.create(body: "Hi", sender_id: sender.id, receiver_id: receiver.id)
    assert message

    make_members_coin_are_right_after_send_msg
  end

  # 情景2：回复者不扣金币
  def test_receiver_send_message_should_not_reduce_coin
    make_members_coin_are_right_before_send_msg

    # 发送小纸条
    msg_1 = PrivateMessage.create(body: "Hi", sender_id: sender.id, receiver_id: receiver.id)
    # 回复小纸条
    msg_2 = PrivateMessage.create(body: "Hello", sender_id: receiver.id, receiver_id: sender.id)

    make_members_coin_are_right_after_send_msg
  end

  # 情景3：两者建立好友关系之后，再次发送小纸条不扣金币
  def test_friends_send_message_should_not_reduce_coin
    make_members_coin_are_right_before_send_msg

    # 发送小纸条
    msg_1 = PrivateMessage.create(body: "Hi", sender_id: sender.id, receiver_id: receiver.id)
    # 回复小纸条
    msg_2 = PrivateMessage.create(body: "Hello", sender_id: receiver.id, receiver_id: sender.id)
    # 再次发送小纸条
    msg_3 = PrivateMessage.create(body: "How are you?", sender_id: sender.id, receiver_id: receiver.id)

    make_members_coin_are_right_after_send_msg
  end

  # 情景4：用户给除了好友之外的用户发小纸条，仍然会扣金币
  def test_sender_send_message_to_stranger_should_reduce_coin
    test_friends_send_message_should_not_reduce_coin

    msg_4 = PrivateMessage.create(body: "Hi", sender_id: sender.id, receiver_id: stranger.id)
    assert_equal 30, sender.coin_total
  end
end
