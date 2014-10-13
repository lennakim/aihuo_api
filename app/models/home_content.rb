class HomeContent < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  include CarrierWaveMini
  # relationships .............................................................
  belongs_to :homepage, foreign_key: :page_id
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("position") }
  scope :submenus, -> { where(block: 0).limit(3) }
  scope :sections, ->(num) { where(block: num) }
  scope :categories, -> { where(block: 4)}
  scope :brands, -> { where(block: 5)}
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  alias_attribute :type, :typename
  SECTIONS = [1, 2, 3, 6, 7]
  # class methods .............................................................
  # public instance methods ...................................................
  def id
    case typename
    when "Product"
      Product.encrypt(Product.encrypted_id_key, self[:typeid])
    when "Article"
      Article.encrypt(Article.encrypted_id_key, self[:typeid])
    else
      nil
    end
  rescue
    "ID error"
  end

  def image
    store_host + "/images/homepages/#{page_id}/#{self[:image]}" if self[:image]
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
