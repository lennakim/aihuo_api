require 'test_helper'

class NodeTest < ActiveSupport::TestCase
  def node
    @node ||= Node.find_by(id: 1)
  end

  def test_node_has_many_members
    assert_equal 2, node.members.count
  end

end
