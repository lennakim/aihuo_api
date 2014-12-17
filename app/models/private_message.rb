class PrivateMessage < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include CoinRule, EncryptedId, DeletePrivateMessageHistory
  # relationships .............................................................
  belongs_to :sender, class_name: "Member", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "Member", foreign_key: "receiver_id"
  # validations ...............................................................
  # callbacks .................................................................
  after_create :send_notice_msg
  # scopes ....................................................................
  default_scope { where(spam: false).order("created_at DESC") }
  scope :spam, -> { where(spam: true) }
  scope :by_receiver, ->(member_id) {
    where(receiver_id: member_id, receiver_deleted: false)
  }
  # TODO: history and full_history condition can be move up to a method.
  scope :history, ->(member_id, friend_id) {
    condition =
      [
        "(receiver_id = ? AND sender_id = ? AND receiver_deleted = ?)",
        "(sender_id = ? AND receiver_id = ? AND sender_deleted = ?)"
      ].join(" OR ")
    where(condition, member_id, friend_id, false, member_id, friend_id, false)
  }
  scope :full_history, ->(member_id, friend_id) {
    condition =
      [
        "(receiver_id = ? AND sender_id = ?)",
        "(sender_id = ? AND receiver_id = ?)"
      ].join(" OR ")
    where(condition, member_id, friend_id, member_id, friend_id)
  }
  scope :friendly, ->(me, friend) { where(sender_id: friend, receiver_id: me) }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'GZp4TPUCFsgzu7Jr'
  delegate :device_id, to: :receiver, allow_nil: true
  # class methods .............................................................
  def self.by_filter(type)
    case type
    when :inbox
      self
    when :spam
      unscoped.spam
    end
  end

  # TODO: refacetor method name
  def self.send_wx_message(member, device_id)
    content = Rails.cache.fetch("private_message_send_for_register_member", expires_in: 1.hours) do
      Setting.find_by_name("private_message_send_for_register_member").try(:value)
    end
    sender_id = Rails.cache.fetch("private_message_send_for_register_member_robot_id", expires_in: 1.hours) do
      Setting.find_by_name("private_message_send_for_register_member_robot_id").try(:value)
    end
    if content
      sender_id ||= Member::CUSTOMER_ID
      message = PrivateMessage.new({receiver_id: member.id, sender_id: sender_id, body: content})
      if message.save && device_id
        if Notification.send_private_message_msg(device_id)
          logger.error "**************推送发送**************"
        else
          logger.error "--------------推送发送失败-------------------"
        end
      else
        logger.error "-------#{device_id} 是------"
      end
    else
      logger.error "缺少必要的纸条内容"
    end
  end
  # public instance methods ...................................................
  def friendly_to_receiver?
    !PrivateMessage.friendly(sender_id, receiver_id).count.zero?
  end

  def opened!
    update_column(:opened, true)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  # 创建小纸条给用户发送消息
  def send_notice_msg
    # 用户拒收通知
    if receiver.receive_message_notification?
      Notification.send_private_message_msg(device_id)
    end
  end
end
