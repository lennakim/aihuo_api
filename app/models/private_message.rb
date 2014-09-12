class PrivateMessage < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include EncryptedId
  include CoinRule
  include DeletePrivateMessageHistory
  # relationships .............................................................
  belongs_to :sender, class_name: "Member", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "Member", foreign_key: "receiver_id"
  # validations ...............................................................
  validate :coin_must_enough
  # callbacks .................................................................
  after_create :send_notice_msg
  after_create :reduce_coin
  # scopes ....................................................................
  default_scope { where(spam: false).order("created_at DESC") }
  scope :spam, -> { where(spam: true) }
  scope :by_receiver, ->(member_id) { where(receiver_id: member_id, receiver_deleted: false) }
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

  # 陌生的两个人首次发送一条小纸条扣5金币
  # 接收者回复纸条不扣金币，发送者再次发送仍然扣金币
  def reduce_coin
    reduce(5) unless friendly_to_receiver?
  end

  # 发送小纸条前验证用户余额
  def coin_must_enough
    error_msg = "发送失败，金币不足"
    errors.add(:member_id, error_msg) if sender.coin_total < 5 && !friendly_to_receiver?
  end

end
