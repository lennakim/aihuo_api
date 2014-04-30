class PrivateMessage < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'GZp4TPUCFsgzu7Jr'
  # includes ..................................................................
  include CoinRule
  # relationships .............................................................
  belongs_to :sender, class_name: "Member", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "Member", foreign_key: "receiver_id"
  # validations ...............................................................
  # callbacks .................................................................
  after_create :send_notice_msg
  after_create :reduce
  # scopes ....................................................................
  default_scope { where(spam: false).order("created_at DESC") }
  scope :spam, -> { where(spam: true) }
  scope :by_receiver, ->(member_id) { where(receiver_id: member_id) }
  scope :history, ->(member_id, friend_id) {
    condition = [
        "(receiver_id = ? AND sender_id = ?)",
        "(receiver_id = ? AND sender_id = ?)"
      ].join(" OR ")
    where(condition, member_id, friend_id, friend_id, member_id)
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  delegate :device_id, to: :receiver, allow_nil: true
  # class methods .............................................................
  # public instance methods ...................................................
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
