require "test_helper"

class OrderTest < ActiveSupport::TestCase

  def test_in_a_week
    assert_equal 21, Order.in_a_week.count
  end

  def test_belongs_to_franchised_store?
    (1..10).each do |item|
     assert_equal false, Order.find_by_id(item).belongs_to_franchised_store?
     assert_equal nil, Order.find_by_id(item + 10).belongs_to_franchised_store?
     assert_equal true, Order.find_by_id(item + 20).belongs_to_franchised_store?
    end
  end
end
