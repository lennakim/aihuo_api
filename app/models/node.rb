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
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'bb2CJaHsHjEZhd2T'
  # class methods .............................................................
  def self.by_filter(filter, member_id)
    case filter
    when :all
      gender =  member_id ? ((member = Member.find(member_id)) ? member.gender : nil) : nil
      case gender
         when  true then where(gender: [1, 2]).reorder("gender ASC")
         when  false then where(gender: [1, 2]).reorder("gender DESC")
         else where(gender: [1, 2])
      end
    when :male then where(gender: 1, recommend: true)
    when :female then where(gender: 2, recommend: true)
    when :joins
      if member_id
        member = Member.find(member_id)
        member.nodes
      end
    end
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

  def do_not_have_member member_id
    !self.member_ids.include? member_id.to_i
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
