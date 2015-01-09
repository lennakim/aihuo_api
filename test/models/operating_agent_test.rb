require "test_helper"

class OperatingAgentTest < ActiveSupport::TestCase
  def sender; Member.find_by(id: 2); end

  def receiver; Member.find_by(id: 3); end

  def test_wechat_activitie
    assert_equal 1, receiver.received_private_messages.count
    OperatingAgent.wechat_activitie(receiver.id)
    assert_equal 2, receiver.received_private_messages.count
  end
end
