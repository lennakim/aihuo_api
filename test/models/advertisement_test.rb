require "test_helper"

class AdvertisementTest < ActiveSupport::TestCase

  def test_valid
    assert adv_contents(:one).valid?
  end

  def test_adv_statistics
    assert_equal 2, adv_contents(:one).adv_statistics.today.count
  end

  def test_all_advertisements_can_increase_view_count
    Advertisement.increase_view_count

    assert_equal 501, adv_contents(:one).today_view_count
    assert_equal 601, adv_contents(:two).today_view_count
    assert_equal 701, adv_contents(:three).today_view_count

    assert_equal 2001, adv_contents(:one).total_view_count
    assert_equal 3001, adv_contents(:two).total_view_count
    assert_equal 4001, adv_contents(:three).total_view_count
  end

  def test_an_advertisement_can_increase_view_count
    adv_contents(:one).increase_view_count
    assert_equal 501, adv_contents(:one).today_view_count
    assert_equal 2001, adv_contents(:one).total_view_count
  end

end
