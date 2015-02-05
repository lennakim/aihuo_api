require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def topic
    @topic || Topic.find_by(id: 1)
  end

  def reply
    Reply.find_by(id: 59)
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


  def test_delete_topic
    topic_report_up_limit = Setting.find_by(name: "Topic_report_up_limit").value.to_i
    topic_report_up_limit.times.each do |item|
      report = Report.create(report_params(topic.id, 'Topic'))
    end
    assert_nil Topic.find_by(id: 1)
    assert_not_nil Topic.with_deleted.find_by(id: 1)

  end

  def test_delete_reply
    reply_report_up_limit = Setting.find_by(name: "Reply_report_up_limit").value.to_i
    reply_report_up_limit.times.each do |item|
      report = Report.create(report_params(reply.id, 'Reply'))
    end
    assert_nil reply
    assert_not_nil Reply.with_deleted.find_by(id: 59)
  end
end
