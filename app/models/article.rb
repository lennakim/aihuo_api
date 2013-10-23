require 'carrierwave'
class Article < ActiveRecord::Base
  # extends ...................................................................
  encrypted_id key: 'AJ03lQmVmtomCfug'
  # includes ..................................................................
  include CarrierWave
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("position DESC") }
  scope :banner, -> { where(:banner => true) }
  scope :with_gifts, -> { where(:banner => true) }
  scope :without_gifts, -> { where(:banner => true) }
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
end
