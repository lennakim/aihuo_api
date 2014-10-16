require 'test_helper'

class TaskLoggingTest < ActiveSupport::TestCase
  def login_task
    tasks(:one)
  end

  # 情景1：一个设备一天可以成功签到1次
  def test_task_logging_secne_1_validation
    member = Member.find_by(id: 1)
    task_logging = TaskLogging.new(task_id: login_task.id, member_id: member.id)
    assert task_logging.save
  end

  # 情景2：一个设备当天成功签到之后不能再继续签到
  def test_task_logging_secne_2_invalidation
    member = Member.find_by(id: 2)
    task_logging = TaskLogging.new(task_id: login_task.id, member_id: member.id)
    refute task_logging.save
    assert_equal "此任务已完成。", task_logging.errors[:task_id][0]
  end

  # 情景3：一个设备可以每天完成多个非签到任务
  def test_task_logging_secne_3_validation
    test_task = tasks(:two)
    member = Member.find_by(id: 2)
    task_logging = TaskLogging.new(task_id: test_task.id, member_id: member.id)
    assert task_logging.save # 第一次完成任务
    assert task_logging.save # 第二次完成任务
  end

  # 情景4：设备完成签到任务，member 增加金币
  def test_increase_coin_after_login_task_successful
    member = Member.find_by(id: 1)
    assert_equal 5, member.coin_total

    task_logging = TaskLogging.new(task_id: login_task.id, member_id: member.id)
    assert task_logging.save

    member = Member.find_by(id: 1) # we need reload member object.
    assert_equal 15, member.coin_total
  end
end
