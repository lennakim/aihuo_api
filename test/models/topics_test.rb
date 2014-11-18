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

  # 测试顶，踩，转发
  def test_like_should_change_likes_count
    assert_equal 100, topic.likes_count
    topic.liked
    assert_equal 101, topic.likes_count
  end

  def test_forward_should_change_forward_count
    assert_equal 50, topic.forward_count
    topic.forward
    assert_equal 51, topic.forward_count
  end

  # 测试回复默认排序
  def test_topic_replies_asc_is_default
    assert_equal 30, topic.replies.count
    assert topic.replies.first.created_at < topic.replies.second.created_at
  end

  # 测试回复按创建时间倒序排序
  def test_topic_replies_desc
    replies = topic.replies.sort("desc")
    assert replies.first.created_at > replies.second.created_at
  end
end
