class Node < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include EncryptedId
  # relationships .............................................................
  has_many :topics
  has_and_belongs_to_many :members
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("sort DESC") }
  scope :by_state, ->(state) { where(privated: state.to_sym != :public) }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'bb2CJaHsHjEZhd2T'
  # class methods .............................................................
  def self.by_filter(filter)
    gender =
      case filter
      when :all then 0
      when :male then 1
      when :female then 2
      end
    where(gender: gender)
  end
  # public instance methods ...................................................
  def manager_list
    node_managers = Setting.find_by_name("node_managers").value + " "
    all_managers = node_managers + managers
    all_managers.split(" ") rescue []
  end

  def block_user(manager, user)
    blacklist = Blacklist.new({ device_id: user, node_id: self.id })
    manager_list.include?(manager) && blacklist.save
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
