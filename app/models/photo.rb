class Photo < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'XRiQcywupJ44cAaR'
  # includes ..................................................................
  include CarrierWave
  # relationships .............................................................
  belongs_to :product
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
