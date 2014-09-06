require "test_helper"

class ApplicationTest < ActiveSupport::TestCase

  def application
    @application = Application.find_by(id: 1)
  end

  def test_valid
    assert_equal "爽翻天", application.name
  end

  # 1 渠道存在，正常返回
  # 2 渠道存在，但是希望关闭，也就是返回空
  # 3 渠道不存在，返回默认渠道
  def test_application_has_correct_tactics
    app = Application.find_by(id: 1)
    setting = app.advertisement_settings.by_channel("默认渠道").first
    assert_equal 1, setting.count
    assert_equal 4, setting.tactics.count
  end

  def test_application_has_correct_tactics
    app = Application.find_by(id: 1)
    setting = app.advertisement_settings.by_channel("百度市场").first
    assert_nil setting
  end

  # 当渠道被关闭的时候，策略返回为空
  def test_adv_setting_can_disable
    app = Application.find_by(id: 2)
    assert_equal 0, app.tactics.size
  end

  # 当渠道被关闭的时候，关联广告为空
  def test_advertisements_should_be_zero_when_setting_disable
    app = Application.find_by(id: 2)
    assert_equal 0, app.advertisements.size
  end

  # 返回的数据仅包含渠道设置有效
  def test_app_has_many_advertisements
    assert_equal 6, application.advertisements.size
  end

  # def test_app_advertisements_available
  #   assert_equal 1, application.advertisements.available.size
  # end

end
