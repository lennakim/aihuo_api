require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def topic
    @topic || Topic.find_by(id: 1)
  end

  def report_params(reportable_obj_id, reportable_obj_type)
    {
      device_id: '863092024963194',
      reportable_id: reportable_obj_id,
      reportable_type: reportable_obj_type,
      reason: 'Guess'
    }
  end


  def test_after_callback_report_device_and_member
    report = Report.create(report_params(topic.id, 'Topic'))
    assert_equal 3, Report.count
  end

  def test_skip_callback_report_device
    report = Report.create(report_params('863092024963194', 'Device'))
    assert_equal 1, Report.count
  end

  def test_skip_callback_report_member
    report = Report.create(report_params('1', 'Member'))
    assert_equal 1, Report.count
  end

end
