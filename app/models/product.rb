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
  scope :gifts, -> { joins(:product_props).where("product_props.sale_price = 0").group('products.id') }

  scope :search, ->(keyword, date, today) {
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
      # 用户日期不在三天内，不显示0元购
      if date && today && date < 2.days.ago(today)
        gifts_ids = self.gifts.pluck(:id)
        products = products.where.not(id: gifts_ids)
      end
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
