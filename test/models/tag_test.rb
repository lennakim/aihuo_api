require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def test_tag_banners
    assert_equal 1, Tag.banner.size
  end
end
