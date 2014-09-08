require "test_helper"

class ApplicationTest < ActiveSupport::TestCase

  def setup
    @app_1 = Application.find_by(id: 1)
    @app_2 = Application.find_by(id: 2)
  end

  def test_valid
    assert_equal "爽翻天", @app_1.name
  end

  # 测试渠道设置
  # 情景1: 渠道存在，正常返回
  def test_app_setting_is_open
    setting = @app_1.advertisement_settings.by_channel("默认渠道").first
    assert_equal 1, setting.id
    assert_equal 4, setting.tactics.count
  end

  # 情景2: 渠道存在，但是希望关闭，也就是返回空
  def test_app_setting_is_closed
    setting = @app_1.advertisement_settings.by_channel("百度市场").first
    assert_nil setting
  end

  # 情景3: 渠道不存在，返回默认渠道
  def test_app_setting_is_none
    setting = @app_1.advertisement_settings.by_channel("小米市场").first
    assert_equal 1, setting.id
    assert_equal 4, setting.tactics.count
  end

  # 测试物料关联
  # 情景1: 返回的物料不重复
  # 情景2: 返回的物料不包含停用的
  # 情景3: 返回的物料不包含已经超量的
  def test_app_advertisements_not_repeat
    setting = @app_1.advertisement_settings.by_channel("默认渠道").first
    tactics = setting.tactics
    assert_equal [1, 4, 5, 6], Advertisement.by_tactics(tactics).pluck(:id)
    assert_equal 4, Advertisement.by_tactics(tactics).size
  end

end
