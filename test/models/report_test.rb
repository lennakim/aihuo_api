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

  def report_a_topic
    device_id = topic.device_id
    topic_report_up_limit = Setting.find_by(name: "Topic_report_up_limit").value.to_i
    topic_report_up_limit.times.each do |item|
      report = Report.create(report_params(topic.id, 'Topic'))
    end
    device_id
  end

  # def test_device_could_not_see_topic
  #   #帖子因为被举报而假删除
  #   device_id = report_a_topic
  #   filter = :mine
  #   assert_equal Topic.find_by(id: 1), Topic.vision_of_topic(device_id).scope_by_filter(filter, device_id).first
  #   #帖子因为因为假删除而更新了update_at时间，测试在帖子删除之后，帖子的属性没有变化
  #   filter = %i(recommend best checking)
  #   filter.each do |i_filter|
  #     assert_not_equal Topic.find_by(id: 1), Topic.vision_of_topic(device_id).scope_by_filter(i_filter, device_id).first
  #     assert_not_equal Topic.find_by(id: 1), Topic.scope_by_filter(i_filter, device_id).first
  #   end

    #帖子成为贴主眼中的hot & new， 子别人差看不到
    # filter = %i(hot new all)
    # filter.each do |i_filter|
    #   assert_equal Topic.find_by(id: 1), Topic.vision_of_topic(device_id).scope_by_filter(i_filter, device_id).first
    #   assert_not_equal Topic.find_by(id: 1), Topic.scope_by_filter(i_filter, device_id).first
    # end
  # end
end
