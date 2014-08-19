require "test_helper"

class AdvStatisticTest < ActiveSupport::TestCase

  def test_valid
    assert adv_statistics(:fix_1).valid?
  end

  def test_scope_by_app
    adv_statistics = AdvStatistic.by_app(1)
    assert_equal 60, adv_statistics.size
  end

  def test_scope_by_advertisement
    advertisement = adv_contents(:one)
    adv_statistics = AdvStatistic.by_advertisement(advertisement.id)
    assert_equal 60, adv_statistics.size
  end

  def test_scope_today
    adv_statistics = AdvStatistic.today
    assert_equal 3, adv_statistics.size
  end

  def test_scope_by_day
    adv_statistics = AdvStatistic.by_day(Date.today)
    assert_equal 3, adv_statistics.size
  end

  def test_scope_by_days
    adv_statistics = AdvStatistic.by_days(2)
    assert_equal 9, adv_statistics.size
  end

  def test_statistic_increase_count
    %i(install click view).each_with_index do |action, index|
      adv_statistics(:fix_1).increase_count(action, 1)
      count = 1000 * (index + 1) + 2
      assert_equal count, adv_statistics(:fix_1).send("#{action}_count")
    end
  end

end
