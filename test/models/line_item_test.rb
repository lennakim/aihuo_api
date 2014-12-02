require "test_helper"

class LineItemTest < ActiveSupport::TestCase

  def test_in_a_week
    assert_equal 28, LineItem.in_a_week.count
  end

  def test_sort_by_sales_volumes
    line_items = LineItem.sort_by_sales_volumes_in_a_week
    assert_equal 28, line_items.length
    assert line_items.first.quantity > line_items.last.quantity
  end

  def test_collect_product_ids_by_sales_volumes_in_a_week
    product_ids = LineItem.collect_product_ids_by_sales_volumes_in_a_week
    assert_equal 28, product_ids.size
    assert_equal 7, product_ids.first
  end
end
