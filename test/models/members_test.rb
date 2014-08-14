require "test_helper"

class MembersTest < ActiveSupport::TestCase

  def setup
    @member_1 = Member.find_by(id: 1)
  end

  def test_valid
    assert @member_1.valid?
  end

end
