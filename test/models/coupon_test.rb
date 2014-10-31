require "test_helper"

class CouponTest < ActiveSupport::TestCase

  def test_coupons_by_sdk_ver
    assert_equal 0, Coupon.by_sdk_ver("1.1").count
    assert_equal 2, Coupon.by_sdk_ver("2.0").count
  end

  def test_coupons_by_sdk_ver_and_ver_is_blank
    assert_equal 0, Coupon.by_sdk_ver("").count
    assert_equal 3, Coupon.by_sdk_ver(nil).count
  end
end
