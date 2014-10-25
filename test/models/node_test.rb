require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  def node
    @node ||= Node.find_by(id: 1)
  end

  def test_node_has_many_members
    assert_equal 2, node.members.count
  end

  # 情景：当请求男性，女性的节点时候，不要显示我加入的节点
  def test_nodes_exclude_of_member_joins
    member = Member.find_by(id: 1)
    assert_equal 1, Node.by_filter(:male, member.id).count

    member = Member.find_by(id: 2)
    assert_equal 0, Node.by_filter(:male, member.id).count
  end
end
