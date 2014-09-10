require 'test_helper'

class PrivateMessageTest < ActiveSupport::TestCase
  def sender; Member.find_by(id: 2); end

  def receiver; Member.find_by(id: 3); end

  def stranger; Member.find_by(id: 1); end

  def boy; Member.find_by(id: 4); end

  def girl; Member.find_by(id: 5); end

  def full_history_between_boy_and_girl
    PrivateMessage.full_history(boy.id, girl.id)
  end

  def history_between_boy_and_girl
    PrivateMessage.history(boy.id, girl.id)
  end

  def make_members_coin_are_right_before_send_msg
    assert_equal 40, sender.coin_total
    assert_equal 80, receiver.coin_total
  end

  def make_members_coin_are_right_after_send_msg
    assert_equal 35, sender.coin_total
    assert_equal 80, receiver.coin_total
  end

  # 发送小纸条扣金币的逻辑
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

  # 删除小纸条的逻辑
  # 情景1：通过任意一条消息，找到两人聊天的聊天记录，并从己方的角度删除聊天记录
  def test_sender_delete_msg
    assert_equal 4, history_between_boy_and_girl.count
    history_between_boy_and_girl.last.delete_history_by(boy.id)

    # 聊天记录中，己方发送已经标记删除
    assert_equal 4, full_history_between_boy_and_girl.first.id
    assert full_history_between_boy_and_girl.first.sender_delete

    # 聊天记录中，己方接受已经标记删除
    assert_equal 1, full_history_between_boy_and_girl.last.id
    assert full_history_between_boy_and_girl.last.receiver_delete
  end

  # 情景2：从己方的角度删除聊天记录，自己看不到消息
  def test_sender_delete_msg_should_hide_to_me
    assert_equal 4, history_between_boy_and_girl.count
    history_between_boy_and_girl.last.delete_history_by(boy.id)
    assert_equal 0, history_between_boy_and_girl.count
  end

  # 情景3：从己方的角度删除聊天记录，对方能看到
  def test_sender_delete_msg_should_show_to_him
    assert_equal 4, history_between_boy_and_girl.count
    history_between_boy_and_girl.last.delete_history_by(boy.id)

    msgs = PrivateMessage.history(girl.id, boy.id)
    assert_equal 4, msgs.count
  end


  def test_delete_history_by_ids
    PrivateMessage.delete_history_by_ids([1, 6], girl.id)

    assert PrivateMessage.find_by(id: 1).sender_delete
    assert PrivateMessage.find_by(id: 2).receiver_delete
    assert PrivateMessage.find_by(id: 6).receiver_delete
  end
end
