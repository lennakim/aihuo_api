require "test_helper"

class ApplicationTest < ActiveSupport::TestCase

  def application
    @application = Application.find_by(id: 1)
  end

  def test_valid
    assert_equal "爽翻天", application.name
  end

  def test_app_has_many_advertisements
    assert_equal 2, application.advertisements.size
  end

  def test_app_advertisements_available
    assert_equal 1, application.advertisements.available.size
  end

end
