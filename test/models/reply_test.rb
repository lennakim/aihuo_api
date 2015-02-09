require 'test_helper'

class ReplyTest < ActiveSupport::TestCase
  def topic
    @topic || Topic.find_by(id: 1)
  end

  def member
    @member || Member.find_by(id: 2)
  end

  def test_add_reply_should_change_member_score_total
    assert_equal 0, member.level
    assert_equal 5, member.score_total
    topic.replies.create({body: "test", device_id: "2222", member_id: 2})
    assert_equal 6, member.score_total
  end

  def test_add_reply_should_change_member_level
    topic.replies.create({body: "test", device_id: "2222", member_id: 3})
    member = Member.find_by(id: 3)
    assert_equal 3, member.level
  end


  def test_reply_topic_filter
    Reply.member_reply_filter.pluck("members.id").each do |item|
      assert_equal 1, item
    end
  end

end
