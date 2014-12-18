module SortProduct
  extend ActiveSupport::Concern

  included do
    scope :sort, ->(keyword, type = :tag, order = :desc) {
      case type
      when :tag
        order_by_tag_name(order, keyword)
      when :rank
        order_by_tag_name(order, keyword)
      when :price
        order_by_price(order)
      when :volume
        order_by_sales_volumes(order)
      when :newly
        order_by_newly(order)
      end
    }

    scope :order_by_tag_id, ->(tag_id) {
      joins("LEFT JOIN tag_product_sorts on products.id = tag_product_sorts.product_id")
        .where(tag_product_sorts: {tag_id: tag_id})
        .reorder("tag_product_sorts.positoin ASC, products.out_of_stock, products.rank DESC")
    }

    scope :order_by_tag_name, ->(order, tag_name) {
      tag = Tag.find_by(name: tag_name)
      return unless tag
      product_ids = order_by_tag_id(tag.id).pluck(:id) + pluck(:id)
      order_by_type(:product_ids, order, product_ids)
    }

    scope :order_by_price, ->(order) {
      scoped = joins("LEFT JOIN (select tmp.*,max(tmp.rzx_stock) as maxstock from (select * from product_props order by rzx_stock desc, sale_price asc) as tmp group by tmp.product_id) as pp on products.id = pp.product_id")
      scoped.order_by_type(:sale_price, order)
    }

    scope :order_by_rank, ->(order) { order_by_type(:rank, order) }

    scope :order_by_newly, ->(order) { order_by_type(:created_at, order) }

    scope :order_by_sales_volumes, ->(order) {
      product_ids = LineItem.collect_product_ids_by_sales_volumes_in_a_week
      order_by_type(:product_ids, order, product_ids)
    }

    scope :order_by_type, ->(type, order, ids = []) {
      case type
      when :product_ids
        ids = (order == :desc ? ids.uniq : ids.uniq.reverse).join(",")
        reorder("FIELD(products.id", ids, "0)")
      else
        reorder("#{type} #{order}")
      end
    }

  end
end
