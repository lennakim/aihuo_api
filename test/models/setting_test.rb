require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def test_transport_settings
    transport_settings = Setting.transport_settings
    assert_equal 4, transport_settings.size
  end

  def test_online_shipping_fee
    setting = Setting.find_by_name(:online_shipping_fee)
    assert_equal "24.0", setting.value
  end
end
