require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  def test_turn_transport_format
    offline_pay = Setting.find_by_name("offline_pay")
    result_hash = {"name" => "offline_pay", "transport_price" =>"24.121321", "transport_free_price" =>"23.12332132", "transport_description" => "namessadfa"}
    setting_hash = Setting.turn_transport_format([offline_pay])[0]
    assert_equal "offline_pay", setting_hash["name"]
    assert_equal "24.121321", setting_hash["transport_price"]
    assert_equal "23.12332132", setting_hash["transport_free_price"]
  end

  def test_transport_setting
    offline_pay = Setting.find_by_name("offline_pay")
    # binding.pry
    # setting_hash = Setting.transport_setting("online_pay")[0]
    setting_hash = offline_pay.transport_setting[0]
    assert_equal "offline_pay", setting_hash["name"]
    assert_equal "24.121321", setting_hash["transport_price"]
    assert_equal "23.12332132", setting_hash["transport_free_price"]

    offline_pay = Setting.find_by_name("online_pay")
    setting_hash = offline_pay.transport_setting[0]
    assert_equal "online_pay", setting_hash["name"]
    assert_equal "12.121321", setting_hash["transport_price"]
    assert_equal "23.12332132", setting_hash["transport_free_price"]

    offline_pay = Setting.find_by_name("transport")
    setting_hash = offline_pay.transport_setting[0]
    assert_equal "offline_pay", setting_hash["name"]
    assert_equal "24.121321", setting_hash["transport_price"]
    assert_equal "23.12332132", setting_hash["transport_free_price"]

    setting_hash = offline_pay.transport_setting[1]
    assert_equal "online_pay", setting_hash["name"]
    assert_equal "12.121321", setting_hash["transport_price"]
    assert_equal "23.12332132", setting_hash["transport_free_price"]
  end
end
