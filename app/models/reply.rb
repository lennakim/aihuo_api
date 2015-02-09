class Reply < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  # includes ..................................................................
  include ScoreRule, EncryptedId, ForumValidations, HarmoniousFormatter, TouchTopic
  # relationships .............................................................
  belongs_to :replyable, polymorphic: true
  belongs_to :topic, foreign_key: 'replyable_id', counter_cache: true
  belongs_to :content, foreign_key: 'replyable_id', counter_cache: true, touch: true
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
  default_scope { order("replies.created_at") }
  scope :to_me, ->(device_id) {
    topics = Topic.where(device_id: device_id).pluck(:id)
    replies = Reply.where(device_id: device_id).pluck(:id)
    condition = [
      "(replyable_id in (?) AND replyable_type = 'Topic')",
      "(replyable_id in (?) AND replyable_type = 'Reply')"
    ].join(" OR ")
    where(condition, topics, replies).where.not(device_id: device_id).reorder("created_at DESC")
  }
  scope :sort, ->(sort) { reorder("created_at DESC") if sort.to_sym == :desc }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'vfKYGu3kbQ3skEWr'

  RPORT_LIMIE = "10"
  FILTER = 8

  #join member，去除用户因为被举报次数太多，而隐藏起所以回复
  def self.member_reply_filter
    joins("INNER JOIN members on members.id = replies.member_id").where("NOT members.report_num_filter & ?", FILTER)
  end
  # class methods .............................................................
  # public instance methods ...................................................
  #过滤回复，过滤被举报不可见的回复
  def self.vision_of_reply(device_id = nil)
    if device_id
      report_limit = Setting.fetch_by_key("#{self.name}_report_up_limit", Reply::RPORT_LIMIE)
      member_reply_filter.with_deleted.where("replies.device_id = ? OR (replies.report_num < ? AND replies.deleted_at IS NULL)", device_id, report_limit.to_i)
    else
      member_reply_filter.all
    end
  end

  def relate_to_member_with_authenticate(member_id, password)
    member = Member.find(member_id) if member_id
    self.member = member if member && member.authenticate?(password)
  end

  def topic_id
    case replyable_type
    when "Topic"
      self[:topic_id]
    when "Reply"
      replyable.topic_id
    else # means 'Content' and so on...
      nil
    end
  end


  def update_report_num(report_num_incr = 1)
    increment!(:report_num, report_num_incr)
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
