require "test_helper"

class LineItemTest < ActiveSupport::TestCase

  def test_by_this_week
    assert_equal 28, LineItem.by_this_week.count
  end

  def test_sort_by_sales_volumes
    line_items = LineItem.sort_by_sales_volumes
    assert_equal 28, line_items.length
    assert line_items.first.quantity > line_items.last.quantity
  end
end
