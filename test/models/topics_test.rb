require 'test_helper'

class TopicsTest < ActiveSupport::TestCase
  def ios_app
    @iso_app = Application.find_by(id: 4)
  end

  def node
    @node_2 = Node.find_by(id: 2)
  end

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

  def test_topic_replies_asc
    replies = topic.replies
    assert_equal 30, replies.count
    assert replies.first.created_at < replies.second.created_at

    replies = topic.replies.sort("asc")
    assert_equal 30, replies.count
    assert replies.first.created_at < replies.second.created_at
  end

  # 测试回复按创建时间倒序排序
  def test_topic_replies_desc
    replies = topic.replies.sort("desc")
    assert replies.first.created_at > replies.second.created_at
  end

#iOS版上架--因APP审核问题，在上架之前要配合扫黄审查，因此在审查期间打开过滤黄色配置
  # 情景1:iOS应用请求最新帖子时会返回指定id的帖子：47691
  def test_iso_get_new_topics
    assert_equal 47691, Topic.scope_by_filter(:new, "1212", ios_app)[0].id
  end

  # 情景2:iOS应用请求最热帖子时会返回指定id的帖子：47691
  #最新最热帖子返回数据相同
  def test_iso_get_hot_topics
    assert_equal 47691, Topic.scope_by_filter(:hot, "1212", ios_app)[0].id
  end

  # 情景3:iOS应用请求精华帖子时会返回指定id的帖子：448805
  def test_iso_get_best_topics
    assert_equal 448805, Topic.scope_by_filter(:best, "1212", ios_app)[0].id
  end

  # 情景4:iOS应用请求某一node下最新帖子时会返回指定id的帖子：47691
  def test_iso_get_node_new_topics
    assert_equal 47691, node.topics.scope_by_filter(:new, "1212", ios_app)[0].id
  end

  # 情景5:iOS应用请求某一node下最热帖子时会返回指定id的帖子：47691
  def test_iso_get_node_hot_topics
    assert_equal 47691, node.topics.scope_by_filter(:hot, "1212", ios_app)[0].id
  end

  # 情景6:iOS应用请求某一node下精华帖子时会返回指定id的帖子：448805
  def test_iso_get_node_best_topics
    assert_equal 448805, node.topics.scope_by_filter(:best, "1212", ios_app)[0].id
  end

  # 情景7:测试scope_by_filter修改后的兼容性测试#回归测试
  def test_regerss_topics
    assert_equal 47691, Topic.scope_by_filter(:best, "1212")[0].id
  end

  # 情景8:测试scope_by_filter修改后的兼容性测试#回归测试-某一节点下
  def test_regerss_topics_node
    assert_equal 47691, node.topics.scope_by_filter(:best, "1212")[0].id
  end

  def test_have_harmonious_word?
    result = Topic.find_by(id: "448806").have_harmonious_word? ? true : false
    assert_equal true, result
  end

  def test_member_topic_filter
    Topic.member_topic_filter.pluck("members.id").each do |item|
      assert_equal 2, item
    end
  end

  def test_hot_to_recommend_filter
    assert_equal [1], Topic.hot_to_recommend_filter(5).pluck(:id)
  end
end
