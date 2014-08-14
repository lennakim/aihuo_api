require "test_helper"

class MembersTest < ActiveSupport::TestCase

  def setup
    @member_1 = Member.find_by(id: 1)
  end

  def test_valid
    assert @member_1.valid?
  end

  # def test_send_sms
  #   result = @member_1.send_captcha("13641374170")
  #   assert result[:success]
  # end

end
