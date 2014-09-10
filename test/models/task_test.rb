require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def test_login_task
    task = Task.login_task
    assert_equal 1, task.id
  end
end
