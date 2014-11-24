require "test_helper"

class OrderTest < ActiveSupport::TestCase

  def test_by_this_week
    assert_equal 21, Order.by_this_week.count
  end
end
