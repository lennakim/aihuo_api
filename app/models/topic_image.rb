class TopicImage < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include EncryptedId
  mount_uploader :image, PhotoUploader
  # relationships .............................................................
  belongs_to :topic
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'rJm3L6cTJshDyL3b'
  # class methods .............................................................
  # public instance methods ...................................................
  def format_image_url
    /http:\/\//.match(image) ? image : image_url
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
