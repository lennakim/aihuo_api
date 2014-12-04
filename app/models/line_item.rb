class LineItem < ActiveRecord::Base
  # extends ...................................................................
  acts_as_paranoid
  # includes ..................................................................
  include EncryptedId, Commable
  # relationships .............................................................
  belongs_to :order, :touch => true
  belongs_to :cart, :touch => true
  belongs_to :product
  belongs_to :product_prop
  # validations ...............................................................
  validates :product_id, presence: true, numericality: true
  validates :product_prop_id, presence: true, numericality: true
  validates :sale_price, presence: true
  validates :quantity, presence: true, numericality: true
  # callbacks .................................................................
  after_create :update_product_prop_info
  # scopes ....................................................................
  scope :in_a_week, -> { joins(:order).merge(Order.in_a_week) }
  scope :sort_by_sales_volumes_in_a_week, -> {
    in_a_week
      .select("line_items.*, SUM(line_items.quantity) AS qt")
      .group("product_id")
      .reorder("qt DESC")
  }
  # additional config (i.e. accepts_nested_attribute_for etc...) ..............
  encrypted_id key: 'nYiLoW9yfjxWAr8G'
  # class methods .............................................................

  # TODO: 这里可以移动到缓存中, 因为每天只生成一次
  def self.collect_product_ids_by_sales_volumes_in_a_week
    sort_by_sales_volumes_in_a_week.inject([]) { |sum, li| sum << li.product_id }
  end
  # public instance methods ...................................................
  # protected instance methods ................................................
  # private instance methods ..................................................
  private

  def update_product_prop_info
    update_attributes({
      sku: product_prop.sku,
      # Named Bug:
      # The purchase_price in line_items as same as the original_price in product_props.
      # 命名错误:
      # line_items 中 purchase_price 是市场价，而 product_props 中 original_price 是市场价
      purchase_price: product_prop.original_price,
      product_prop_name: product_prop.name,
      product_prop_value: product_prop.values
    })
  end
end
