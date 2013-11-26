class LineItem < ActiveRecord::Base
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  belongs_to :order
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
  # additional config .........................................................
  # class methods .............................................................
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
