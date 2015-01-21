require "test_helper"
require 'shipping_charge' # Notice: this line is very **IMPORTANT**

class ShippingChargeTest < ActiveSupport::TestCase
  def province; @province ||= Province.find 1; end

  def test_province_shipping_charge
    assert_equal [5, 10], province.shipping_charge
  end

  def test_city_shipping_charge
    city = province.cities.find 1
    assert_equal [5, 9], city.shipping_charge
  end

  def test_city_use_province_shipping_charge_when_city_shipping_charge_is_zero
    city = province.cities.find 2
    assert_equal [5, 10], city.shipping_charge
  end

  def test_district_shipping_charge
    city = province.cities.find 1
    district = city.districts.find 1
    assert_equal [5, 8], district.shipping_charge
  end

  def test_district_use_province_shipping_charge_when_district_shipping_charge_is_zero
    city = province.cities.find 1
    district = city.districts.find 2
    assert_equal [5, 9], district.shipping_charge
  end

  def test_shipping_charege_find_by_address_validation
    shipping_charge = ShippingCharge.find_by_address('吉林省', '吉林市', '朝阳区').first
    assert_equal [5, 8], [shipping_charge.cash_on_delivery, shipping_charge.pay_online]

    shipping_charge = ShippingCharge.find_by_address('吉林省', '吉林市', nil).first
    assert_equal [5, 9], [shipping_charge.cash_on_delivery, shipping_charge.pay_online]

    shipping_charge = ShippingCharge.find_by_address('吉林省', nil, nil).first
    assert_equal [5, 10], [shipping_charge.cash_on_delivery, shipping_charge.pay_online]

    shipping_charge = ShippingCharge.find_by_address('山东省', nil, nil).first
    assert_equal [12, 12], [shipping_charge.cash_on_delivery, shipping_charge.pay_online]
  end
end
