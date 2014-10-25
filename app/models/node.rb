class Node < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include EncryptedId
  include CarrierWaveMini
  # relationships .............................................................
  has_many :topics
  has_and_belongs_to_many :members, -> { uniq }
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("sort DESC") }
  scope :by_state, ->(state) { where(privated: state.to_sym != :public) }
  scope :by_member_id, ->(member_id) {
    joins(:members).where(members: {id: member_id})
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'bb2CJaHsHjEZhd2T'
  # class methods .............................................................
  def self.by_filter(filter, member_id)
    case filter
    when :all
      where(gender: [0, 1, 2])
    when :male
      nodes = where(gender: [0, 1], recommend: true)
      nodes_exclude_by_member_id(nodes, member_id)
     when :female
      nodes = where(gender: [0, 2], recommend: true)
      nodes_exclude_by_member_id(nodes, member_id)
    when :joins
      by_member_id(member_id) if member_id
    end
  end

  def self.nodes_exclude_by_member_id(nodes, member_id)
    member_id.present? ? nodes - by_member_id(member_id) : nodes
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
