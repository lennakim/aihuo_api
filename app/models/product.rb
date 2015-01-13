class Product < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  acts_as_taggable_on :tags
  acts_as_taggable_on :recommends
  # includes ..................................................................
  include EncryptedId, CarrierWaveMini, RecommendProduct, SortProduct
  # relationships .............................................................
  has_many :product_props
  has_many :photos
  has_many :line_items
  has_many :orders, :through => :line_items
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  default_scope { order("products.out_of_stock, products.rank DESC") }
  scope :gifts, -> {
    select("products.id AS id").joins(:product_props).where(product_props: { sale_price: 0 })
      .group('products.id')
  }
  scope :healthy, -> { tagged_with("配合扫黄", any: true) }
  scope :banner, -> { where(:banner => true) }
  scope :serach_by_keyword, ->(keyword, match, context = "tags", tag_name) {
    products =
      case keyword # was case keyword.class
      when Array
        case keyword[0] # was case keyword[0].class
        when Integer # keyword is array of ids
          where(id: keyword)
        when String # keyword is array of tags
          case match
          when "any" # keyword is array of tags
            tagged_with(keyword, on: context, any: true).distinct
          when "match_all" # keyword is array of categories and brands
            # TODO: fix this method
            keyword.inject(self) {
              |mem, k| mem.tagged_with(k, on: context, any: true).distinct
            }
          end
        end
      when String # keyword is a tag or word.
        products = tagged_with(keyword, on: context, any: true).distinct
        products = where("products.title like ?", "%#{keyword}%") if products.blank?
        products
      when NilClass # keyword is nil, return all the products
        self
      end
    # 只显示打了 tag 的产品
    tagging_ids = self.with_tagging.pluck(:id)
    # 当传递了 tag_name 的时候，只显示该 tag 下的产品
    tagging_ids = tagged_with(tag_name, on: context, any: true).distinct.pluck(:id) if tag_name
    products = products.where(id: tagging_ids)
  }
  scope :search, ->(keyword, date, today, match, tag_name) {
    products = serach_by_keyword(keyword, match, tag_name)
    # 未传递用户注册日期，或用户注册日期不在三天内，不显示0元购
    if date.blank? || date && today && date < 2.days.ago(today)
      gifts_ids = self.gifts.pluck(:id)
      products = products.where.not(id: gifts_ids)
    end
    products
  }

  # Example: scope through associations :joins or :includes.
  # scope :without_children, -> {
  #   includes(:children).where(:children => { :id => nil })
  # }
  scope :price_between, ->(min, max) {
    if min && max
      joins(:product_props).where(product_props: { sale_price: min...max })
    end
  }

  scope :with_tagging, -> {
    select("taggings.taggable_id AS id")
      .joins(:taggings).where(taggings: { taggable_type: 'Product'})
      .group('taggings.taggable_id')
  }

  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'XRbLEgrUCLHh94qG'
  # class methods .............................................................
  # public instance methods ...................................................
  # 市场价（原价）显示SKU市场价的最高值
  def market_price
    product_props.reorder("original_price DESC").first.original_price
  rescue
    'No SKU'
  end

  # 零售价（现价）显示SKU零售价的最低值
  def retail_price
    product_props.retail_price
  rescue
    'No SKU'
  end

  def labels
    Tag.for_popularize.pluck(:name) & tag_list
  end

  def detail_link
    "http://image.yepcolor.com/product_detail/" + self[:detail_link] if self[:detail_link]
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end
