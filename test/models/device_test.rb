require 'test_helper'

class DeviceTest < ActiveSupport::TestCase

  def report_params(reportable_obj_id, reportable_obj_type)
    {
      device_id: '863092024963194',
      reportable_id: reportable_obj_id,
      reportable_type: reportable_obj_type,
      reason: 'Guess'
    }
  end

  def test_is_in_safe_condition?
    Setting.find_by_name("device_safe_up_limit").value.to_i.times do
       Report.create(report_params('863092024963194', 'Device'))
    end
    result = Device.is_in_safe_condition?("863092024963194") ? true : false
    assert_equal false, result
    Report.delete_all

    (Setting.find_by_name("device_safe_up_limit").value.to_i - 1).times do
       Report.create(report_params('863092024963194', 'Device'))
    end
    result = Device.is_in_safe_condition?("863092024963194") ? true : false
    assert_equal true, result
  end
end
