require "test_helper"

class MembersTest < ActiveSupport::TestCase

  def setup
    @member_1 ||= Member.find_by(id: 1)
    @member_2 ||= Member.find_by(id: 2)
    @node ||= Node.find_by(id: 1)
  end

  def test_valid
    assert @member_1.valid?
  end

  def test_member_verified_with_increase_coin
    @member_1.verified!
    assert_equal 20, @member_1.coin_total
  end

  def test_member_verified_without_increase_coin
    @member_1.verified!(need_increase_coin: false)
    assert_equal 5, @member_1.coin_total
  end

  def test_member_join_a_group
    @member_2.nodes << @node
    assert_equal 1, @member_2.nodes.count
  end

  def test_member_quit_a_group
    @member_2.nodes.delete @node
    assert_equal 0, @member_2.nodes.count
  end

  # def test_send_sms
  #   result = @member_1.send_captcha("13641374170")
  #   assert result[:success]
  # end

end
