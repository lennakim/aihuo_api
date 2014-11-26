require 'test_helper'

class Ios_Topic_Test < ActiveSupport::TestCase
  def ios_app
    @iso_app = Application.find_by(id: 4)
  end

  def node
    @node_2 = Node.find_by(id: 2)
  end
  # 测试iOS请求最新最热精华帖子
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
end
