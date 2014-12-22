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
end
