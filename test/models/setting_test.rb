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

  def test_fetch_by_key
    key = "private_message_send_for_register_member"
    setting = Setting.fetch_by_key key
    assert_equal "asndfansdfo", setting
  end

  def test_invitation_content
    setting = Setting.invitation_content
    assert_equal "asndfansdfo", setting
  end

  def test_invitation_sender
    setting = Setting.invitation_sender
    assert_equal "2", setting
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

  def test_meet_condition?
    pay_types = [0, 1]
    pay_types.each do |pay_type|
      online_free_shipping_conditione = Setting.get_paytype_shipping_conditione(pay_type).floor
      (1...online_free_shipping_conditione).each do |item_total|
        assert_equal false, Setting.meet_condition?(pay_type, item_total)
        #用于检测test 是否正确
        # puts("*" * 10 + item_total.to_s + "-" * 10 + "false")
      end

      ((online_free_shipping_conditione + 1)...(online_free_shipping_conditione + 10)).each do |item_total|
        assert_equal true, Setting.meet_condition?(pay_type, item_total)
        # puts("*" * 10 + item_total.to_s + "-" * 10 + "true")
      end
    end
  end
end
