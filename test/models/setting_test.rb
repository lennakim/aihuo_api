require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def test_transport_settings
    transport_settings = Setting.transport_settings
    assert_equal 6, transport_settings.size
  end

  def test_online_shipping_fee
    setting = Setting.find_by_name(:online_shipping_fee)
    assert_equal "24.0", setting.value
  end

  def test_get_paytype_shipping_conditione
   shipping_charge = Setting.get_paytype_shipping_conditione 0
   assert_equal (100.0).round(2), shipping_charge

   shipping_charge = Setting.get_paytype_shipping_conditione 1
   assert_equal (150.0).round(2), shipping_charge
  end

  def test_get_defalut_paytype_shipping_conditione
    Setting.find_by_name("online_free_shipping_conditione").destroy
    Setting.find_by_name("cash_free_shipping_conditione").destroy

    shipping_charge = Setting.get_paytype_shipping_conditione 0
    assert_equal 158.round(2), shipping_charge

    shipping_charge = Setting.get_paytype_shipping_conditione 1
    assert_equal 199.round(2), shipping_charge
  end

end
