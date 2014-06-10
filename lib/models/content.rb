class Content < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'N2kTa8dyAyRtkdTz'
  # includes ..................................................................
  include Voting
  # relationships .............................................................
  has_many :replies, -> { order "created_at DESC" }, as: :replyable, :dependent => :destroy
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("id DESC") }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
