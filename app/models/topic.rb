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
  default_scope { order("updated_at DESC") }
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
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: '36aAoQHCaJKETWHR'
  accepts_nested_attributes_for :topic_images
  # class methods .............................................................
  def self.scope_by_filter(filter, device_id = nil , app = nil)
    is_apple = true if app && "31cbdb3c" == app.api_key
    case filter
    when :recommend
      approved.recommend
    when :best
      return get_certain_topics("best") if is_apple
      approved.excellent
    when :checking
      checking
    when :hot
      return where(id: [1,2,3,4]) if is_apple
      #approved.latest
    when :new
      return get_certain_topics("new") if is_apple
      approved.newly
    when :mine
      with_deleted.by_device(device_id)
    when :followed
      favorites_by_device(device_id)
    when :all
      self
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

  # protected instance methods ................................................
  # private instance methods ..................................................
  
  #if a device is apple device then return specially topics
  def self.get_certain_topics(filter)
    #最新最热
    arr_new_hot = [47691,47689,47568,47567,47560,47559,47557,47556,47555,47554,47547,47546,47541,47540,
                    47537,47536,47535,47535,47534,47531,47529,47526,47526,47524,47519,47519,47517,47517,47517,47499,
                    47498,47493,47492,47490,47366,47365,47362]
    #精华
    arr_best = [448805,450732,449322,446267,343706,336486,437793,436224,434326,433839,425285,417109,415408,
                416855,411890,409370,409071,408443,409080,407885]
    if "best" == filter
      Topic.where(id: arr_best)
    else
      #hot和new返回的数据一样，因此写入else中
      Topic.where(id: arr_new_hot)
    end
  end
  private
  
  def set_approved_status
    self.approved = false if new_record?
  end
end
