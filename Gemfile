source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'
gem 'grape', '0.7.0'
gem 'mysql2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'grape-shaman_cache', '0.3.0'
gem 'grape-jbuilder'
gem 'grape-kaminari'
gem 'acts-as-taggable-on'
gem 'newrelic-grape', :git => 'https://github.com/flyerhzm/newrelic-grape.git'
# https://github.com/collectiveidea/awesome_nested_set
gem 'awesome_nested_set', '~> 3.0.0.rc.1'
# https://github.com/radar/paranoia
gem 'paranoia', '~> 2.0.1'
gem 'china_sms'
gem 'bluestorm_sms', '0.0.5', github: 'wjp2013/bluestorm_sms'
gem 'dalli', github: 'flypiggy/dalli'
gem 'igetui-ruby', '1.2.0', require: 'igetui'

group :development do
  gem 'spring'
  # Use mina for deployment
  # https://github.com/nadarei/mina
  gem 'mina'
  # A robust Ruby code analyzer, based on the community Ruby style guide.
  # https://github.com/bbatsov/rubocop
  gem 'rubocop', '~> 0.18.1'
end

group :test do
  gem 'sqlite3'
  gem 'minitest-rails'
  gem 'minitest-focus'
  gem 'database_cleaner'
end

group :development, :test do
  # gem 'api_taster', '0.6.0'
  gem 'pry'
end

group :production do
  gem 'puma'
end
