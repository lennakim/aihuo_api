class Reply < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'vfKYGu3kbQ3skEWr'
  # includes ..................................................................
  include ForumValidations
  include HarmoniousFormatter
  # relationships .............................................................
  belongs_to :replyable, polymorphic: true
  belongs_to :topic, foreign_key: 'replyable_id', counter_cache: true, touch: true
  belongs_to :member
  has_many :replies, as: :replyable
  delegate :node, to: :topic, allow_nil: true
  delegate :node_id, to: :topic, allow_nil: true
  # validations ...............................................................
  validates_uniqueness_of :body,
    :scope => [:replyable_id, :replyable_type, :device_id],
    :message => "请勿重复发言"
  # callbacks .................................................................
  after_create :set_topic_id
  after_create :send_notice_msg
  # scopes ....................................................................
  # default_scope { order("created_at DESC") }
  scope :to_me, ->(device_id) {
    topics = Topic.where(device_id: device_id).pluck(:id)
    replies = Reply.where(device_id: device_id).pluck(:id)
    condition = [
      "(replyable_id in (?) AND replyable_type = 'Topic')",
      "(replyable_id in (?) AND replyable_type = 'Reply')"
    ].join(" OR ")
    where(condition, topics, replies).where.not(device: device_id).order("created_at DESC")
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  # public instance methods ...................................................
  def relate_to_member_with_authenticate(member_id, password)
    member = Member.find(member_id) if member_id
    self.member = member if member && member.authenticate?(password)
  end

  def topic_id
    replyable_type == "Topic" ? self[:topic_id] : replyable.topic_id
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  # 有新回复给用户发送消息
  def send_notice_msg
    if replyable_type == "Topic" && self.replyable.member.try(:receive_reply_notification?)
      device_id = self.replyable.device_id
      Notification.send_reply_message_msg(device_id)
    end
  end

  def set_topic_id
    update_column(:topic_id, replyable_id) if replyable_type == "Topic"
  end
end
