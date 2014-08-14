require File.expand_path('../boot', __FILE__)

# require 'rails/all'
# Pick the frameworks you want:
require 'active_record/railtie'
# require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'sprockets/railtie'
require 'rake/testtask'
# require "rails/test_unit/railtie"
require "minitest/rails/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShouquApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Beijing'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.paths.add File.join('app', 'apis'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'apis', '*')]

    config.active_record.default_timezone = :local

    config.cache_store = :file_store, "tmp/cache"

    # Config minitest-rails
    # https://github.com/blowmage/minitest-rails#usage
    config.generators do |g|
      g.test_framework :minitest, spec: true, fixture: true
    end
  end
end
