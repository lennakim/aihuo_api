require 'test_helper'

class HomepageTest < ActiveSupport::TestCase

  #对某个特定应用返回特定homepage,如果没有找到应该返回全局的homepage，此测试保证和tab页逻辑不冲突
  def test_default_home_page_for_one_application
    app = Application.find_by_id(4)
    homepage = Homepage.for_app(app)[0]
    assert_equal "全部应用", homepage.name
    assert_equal "官方", homepage.label
    assert_equal 3, homepage.id
  end
  #对某个特定应用返回特定tab页
  def test_certain_tab_page_for_one_application
    app = Application.find_by_id(1)
    assert_equal "首趣tab", Homepage.for_app_tabs(app).name
  end
  #对某个特定应用返回特定tab页,如果没有找到应该返回全局的homepage
  def test_default_tab_page_for_one_application
    app = Application.find_by_id(2)
    assert_equal "全局tab", Homepage.for_app_tabs(app).name
  end
end