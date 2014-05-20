class Topic < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  encrypted_id key: '36aAoQHCaJKETWHR'
  # includes ..................................................................
  include EncryptedIdFinder
  include ForumValidations
  include Voting
  include HarmoniousFormatter
  # relationships .............................................................
  belongs_to :node, :counter_cache => true
  belongs_to :member
  has_many :replies, -> { order "created_at DESC" }, as: :replyable, :dependent => :destroy
  # validations ...............................................................
  validates_uniqueness_of :body, :scope => :device_id, :message => "请勿重复发言"
  # callbacks .................................................................
  after_initialize :set_approved_status
  # scopes ....................................................................
  default_scope { order("updated_at DESC") }
  scope :approved, -> { where(approved: true) }
  scope :by_device, ->(device_id) { where(device_id: device_id) }
  scope :popular, -> { where("replies_count >= 50") }
  scope :lasted, -> { where(best: false).reorder("top DESC, updated_at DESC") }
  scope :excellent, -> { where(best: true).reorder("top DESC, updated_at DESC") }
  scope :checking, -> { where(approved: false) }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  # public instance methods ...................................................
  # User is a device id.
  def destroy_by(user)
    if user == device_id
      update_attributes({ device_id: nil, nickname: "匿名" }) # 帖主本人删除
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
  private

  def set_approved_status
    self.approved = false if new_record?
  end
end
