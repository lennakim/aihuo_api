require 'carrierwave'
class Photo < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'XRiQcywupJ44cAaR'
  # includes ..................................................................
  include CarrierWave
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :product
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
