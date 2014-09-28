require 'test_helper'

class TopicsTest < ActiveSupport::TestCase
  def topic
    @topic || Topic.find_by(id: 1)
  end

  def old_topic
    @old_topic || Topic.find_by(id: 2)
  end

  # 测试更新时间
  # 情景1：5天内创建的帖子，在顶，回复，分享的时候会修改更新时间
  def test_add_reply_should_change_topic_updated_at
    topic.replies.create({body: "test", device_id: "2222", member_id: 2})
    assert_equal Date.today.strftime('%Y-%m-%d'), topic.updated_at.strftime('%Y-%m-%d')
  end

  def test_like_should_change_topic_updated_at
    topic.liked
    assert_equal Date.today.strftime('%Y-%m-%d'), topic.updated_at.strftime('%Y-%m-%d')
  end

  def test_forward_should_change_topic_updated_at
    topic.forward
    assert_equal Date.today.strftime('%Y-%m-%d'), topic.updated_at.strftime('%Y-%m-%d')
  end
  # 情景2：5天前创建的帖子，在顶，回复，分享的时候不修改更新时间
  def test_add_reply_should_not_change_topic_updated_at
    old_topic.replies.create({body: "test", device_id: "2222", member_id: 2})
    refute_equal Date.today.strftime('%Y-%m-%d'), old_topic.updated_at.strftime('%Y-%m-%d')
  end

  def test_like_should_not_change_topic_updated_at
    old_topic.liked
    refute_equal Date.today.strftime('%Y-%m-%d'), old_topic.updated_at.strftime('%Y-%m-%d')
  end

  def test_forward_should_not_change_topic_updated_at
    old_topic.forward
    refute_equal Date.today.strftime('%Y-%m-%d'), old_topic.updated_at.strftime('%Y-%m-%d')
  end
end
