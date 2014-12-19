require "test_helper"

class MemberTest < ActiveSupport::TestCase

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
    assert_equal 3, @member_2.nodes.count
  end

  def test_member_quit_a_group
    @member_2.nodes.delete @node
    assert_equal 2, @member_2.nodes.count
  end

  def test_member_points_to_next_level
    assert_equal 0, @member_2.level
    assert_equal 10, @member_2.points_to_next_level
  end

  # def test_send_sms
  #   result = @member_1.send_captcha("13641374170")
  #   assert result[:success]
  # end

  def test_nick_name
    # member = Member.where(nickname: 'Ha111111nMeiMei').first
    member = Member.find_by_id(6)
    assert_equal "Ha***nMei**Me*i", member.nickname

    member = Member.find_by_id(7)
    assert_equal "*HanMeiMei*nmnnasndfa一夜", member.nickname
  end

  # def test_send_private_message
  #   member = Member.find_by_id(1)
  #   Member.send_private_message member
  #   assert_equal 1, member.received_private_messages.size
  #   assert_equal "asndfansdfo", member.received_private_messages.last.body
  # end
end
