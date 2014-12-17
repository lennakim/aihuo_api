require "test_helper"

class OrderTest < ActiveSupport::TestCase

  def test_in_a_week
    assert_equal 21, Order.in_a_week.count
  end
end
