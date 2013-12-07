class Product < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  acts_as_taggable_on :tags
  encrypted_id key: 'XRbLEgrUCLHh94qG'
  # includes ..................................................................
  include CarrierWave
  include EncryptedIdFinder
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  has_many :product_props
  has_many :photos
  has_many :line_items
  has_many :orders, :through => :line_items
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("products.out_of_stock, products.rank DESC") }
  scope :search, ->(keyword) {
    case keyword # was case keyword.class
    when Array
      case keyword[0] # was case keyword[0].class
      when Integer # keyword is ids
        where(id: keyword)
      when String # keyword is tags
        tagged_with(keyword, :any => true)
      end
    when String # keyword is a tag or word.
      products = tagged_with(keyword, :any => true)
      products = where("products.title like ?", "%#{keyword}%") if products.size.zero?
    end
  }
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................

  # 市場價（原價）顯示SKU售賣價的最高值
  def market_price
    product_props.order("original_price DESC").first.original_price
  end

  # 零售價（現價）顯示SKU售賣價的最低值
  def retail_price
    product_props.order("sale_price").first.sale_price
  end

  def labels
    Tag.for_popularize.collect(&:name) & tag_list
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
end
