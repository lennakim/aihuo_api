class Topic < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  encrypted_id key: '36aAoQHCaJKETWHR'
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :node, :counter_cache => true
  has_many :replies, :dependent => :destroy
  # validations ...............................................................
  validates_presence_of :body
  validates_uniqueness_of :body, :scope => :device_id, :message => "请勿重复发言"
  # callbacks .................................................................
  # scopes ....................................................................
  scope :by_device, ->(device_id) { where(:device_id => device_id) }
  scope :popular, -> { where("replies_count >= 50") }
  scope :lasted, -> { where("replies_count < 50") }
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  def liked
    update_attribute(:likes_count, self.likes_count += 1)
  end

  def unliked
    update_attribute(:unlikes_count, self.unlikes_count += 1)
  end

  # User is a device id.
  def can_destroy_by?(user)
    user.present? && (user == device_id || node.manager_list.include?(user))
  end

  def destroy_by(device_id)
    update_attribute(:deleted_by, device_id)
    destroy
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
