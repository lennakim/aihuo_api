class Topic < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  # includes ..................................................................
  include EncryptedId
  include ForumValidations
  include Voting
  include HarmoniousFormatter
  # relationships .............................................................
  belongs_to :node, :counter_cache => true
  belongs_to :member
  has_many :replies, -> { order "created_at DESC" }, as: :replyable, :dependent => :destroy
  has_many :favorites, as: :favable
  has_many :topic_images
  # validations ...............................................................
  validates_uniqueness_of :body, :scope => :device_id, :message => "请勿重复发言"
  # callbacks .................................................................
  after_initialize :set_approved_status
  # scopes ....................................................................
  default_scope { order("topics.updated_at DESC") }
  scope :approved, -> { where(approved: true) }
  scope :by_device, ->(device_id) { where(device_id: device_id) }
  scope :popular, -> { where("replies_count >= 50") }
  scope :newly, -> { where(best: false).reorder("top DESC, created_at DESC") }
  scope :latest, -> { where(best: false).reorder("top DESC, updated_at DESC") }
  scope :excellent, -> { where(best: true).reorder("bested_at DESC, updated_at DESC") }
  scope :recommend, -> { where(recommend: true, top: false).reorder("created_at DESC") }
  scope :checking, -> { where(approved: false) }
  scope :favorites_by_device, ->(device_id) {
    joins(:favorites).where(favorites: { device_id: device_id })
  }
  scope :hot_to_recommend_filter, ->(up_limie) {where("likes_count + replies_count > ?", up_limie)}
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: '36aAoQHCaJKETWHR'
  accepts_nested_attributes_for :topic_images
  # class methods .............................................................
  REPORT_LIMIT = "10"

  FILTER = 4
  NEED_VERTIFY = 1

  def self.member_topic_filter
    joins("INNER JOIN members on members.id = topics.member_id").where("NOT members.report_num_filter & ?", Topic::FILTER)
  end

  def self.scope_by_filter(filter, device_id = nil , app = nil)
    return safe_content_by_filter(filter) if is_switch_open?(app)
    vision_of_topic(device_id).scoping do
    case filter
      when :recommend
        #用最热的帖子代替推荐的帖子
        # approved.recommend
        filter_value = Setting.fetch_by_key("hot_to_recommend_filter_value", "5").to_i
        approved.hot_to_recommend_filter(filter_value).latest
      when :best
        approved.excellent
      when :checking
        checking
      when :hot
        approved.latest
      when :new
        approved.newly
      when :mine
        with_deleted.by_device(device_id)
      when :followed
        favorites_by_device(device_id)
      when :all
        all
      end
    end
  end

  def self.vision_of_topic(device_id = nil)
    if device_id
      report_limit = Setting.fetch_by_key("#{self.name}_report_up_limit", Topic::REPORT_LIMIT)
      with_deleted.where("topics.device_id = ? OR (topics.report_num < ? AND topics.deleted_at IS NULL)", device_id, report_limit.to_i)
    else
      all
    end
  end
  #iOS应用，并且打开了安全开关
  def self.safe_content_by_filter(filter)
    case filter
    when :recommend
      approved.recommend
    when :best
      get_certain_topics(:best)
    when :checking
      checking
    when :hot
      get_certain_topics(:hot)
    when :new
      get_certain_topics(:new)
    when :mine
      with_deleted.by_device(device_id)
    when :followed
      favorites_by_device(device_id)
    when :all
    end
  end
  # public instance methods ...................................................
  # User is a device id.
  def destroy_by(user)
    if user == device_id
      # 帖主本人删除, member id 123510 named "匿名"
      update_columns({ device_id: nil, nickname: "匿名", member_id: 123510 })
    else
      update_attribute(:deleted_by, user) # 管理员删除
      destroy
    end
  end

  def relate_to_member_with_authenticate(member_id, password)
    member = Member.find(member_id) if member_id
    self.member = member if member && member.authenticate?(password)
  end

  def self.is_switch_open?(app)
    setting = Setting.find_by_name("ios_topic_switch")
    app && setting && app.api_key == '31cbdb3c' && setting.value == 'on'
  end

  #if a device is apple device then return specially topics
  def self.get_certain_topics(filter)
    return [] unless [:best, :new, :hot].include?(filter)
    arr = Setting.find_by_name("ios_topic_#{filter}").try(:value).split("|")
    arr.each do |id|
      arr.delete(id) if id != id.strip
    end
    Topic.where(id: arr)
  end

  def auto_vertify(topic_image)
    # self.approved = (!topic_image && !have_harmonious_word? && Device.is_in_safe_condition?(device_id))
    self.approved = (!topic_image && !have_harmonious_word? && Member.find_by(id: self.member_id).try(:topic_auto_approve?))
  end

  def have_harmonious_word?
    key_word = Setting.fetch_by_key("topic_content_key_word_harmonious")
    key_word && body.force_encoding("UTF-8").index(Regexp.new(key_word))
  end

  def update_report_num(report_num_incr = 1)
    increment!(:report_num, report_num_incr)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def set_approved_status
    self.approved = false if new_record?
  end
end
