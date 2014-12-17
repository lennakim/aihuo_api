require "test_helper"

class OrderTest < ActiveSupport::TestCase

  def test_in_a_week
    assert_equal 21, Order.in_a_week.count
  end
  
  def test_express_company
    assert_equal "圆通快递", Order.where(id: 31).first.express_company
  end
  #测试运单company为空时
  def test_express_company_null
    assert_equal "顺丰快递", Order.where(id: 32).first.express_company
  end
end
