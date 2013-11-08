class Device < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'zhKJmvPjguc33pvQ'
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  has_one :device_info, :primary_key => "device_id"
  # validations ...............................................................
  validates :device_id, presence: true, uniqueness: true
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
