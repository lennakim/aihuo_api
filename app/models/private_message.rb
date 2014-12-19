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

  def self.send_an_invitation_to_member(receiver_id)
    sender_id = Setting.invitation_sender
    content = Setting.invitation_content
    if content && receiver_id
      msg = PrivateMessage.create({receiver_id: receiver_id, sender_id: sender_id, body: content})
      msg.valid?
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
