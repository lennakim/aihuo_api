ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
require "minitest/pride"

require 'minitest/focus'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #
  # Fixed: FixtureClassNotFound: No class attached to find
  # http://stackoverflow.com/questions/7020494/how-do-you-solve-fixtureclassnotfound-no-class-attached-to-find
  # http://dev.mensfeld.pl/tag/deprecation-warning/
  set_fixture_class adv_contents: Advertisement
  fixtures :all

end
