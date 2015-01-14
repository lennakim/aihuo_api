class Application < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include EncryptedId
  # relationships .............................................................
  belongs_to :user
  has_many :homepages
  has_many :coupons
  has_many :resources, class_name: 'Resource'
  has_many :articles, through: :resources, source: :resable, source_type: "Article"
  has_many :products, through: :resources, source: :resable, source_type: "Product"
  has_many :tags, through: :resources, source: :resable, source_type: "Tag"
  has_many :advertisement_settings
  has_many :tactics, through: :advertisement_settings
  # Remember to remove `adv_contents_applications` later.
  # has_and_belongs_to_many :advertisements,
  #   join_table: 'adv_contents_applications',
  #   foreign_key: 'application_id',
  #   association_foreign_key: 'adv_content_id'

  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'VUUZzOQXNwx8HuyD'
  # class methods .............................................................
  # public instance methods ...................................................
  def advertisements
    Advertisement.by_tactics(tactics)
  end

  def belongs_to_franchised_store?
    user && %w(jm_admin jm_cs jms).include?(user.role)
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
