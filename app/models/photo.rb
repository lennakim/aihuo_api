class Photo < ActiveRecord::Base
  # extends ...................................................................
  mount_uploader :image, ImageUploader
  encrypted_id key: 'XRiQcywupJ44cAaR'
  # includes ..................................................................
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
