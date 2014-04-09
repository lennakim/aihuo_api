source 'https://rubygems.org'
# source 'http://ruby.taobao.org/'

# An opinionated micro-framework for creating REST-like APIs in Ruby.
# https://github.com/intridea/grape
gem 'grape', "0.7.0"

gem "rack", "~> 1.5.0"
gem 'mysql2'
gem 'activerecord', '4.1.0.rc2'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.2'
# Use Jbuilder with Grape https://github.com/milkcocoa/grape-jbuilder
gem 'grape-jbuilder'
gem 'grape-kaminari', github: 'wjp2013/grape-kaminari'
gem 'grape-shaman_cache', '0.2.0', github: 'wjp2013/grape-shaman_cache'
# gem 'newrelic-grape'

# gem 'acts-as-taggable-on', '~> 2.4.1', github: 'wjp2013/acts-as-taggable-on'
# https://github.com/pencil/encrypted_id
gem 'encrypted_id'
# https://github.com/collectiveidea/awesome_nested_set
gem 'awesome_nested_set', '~> 3.0.0.rc.1'

# https://github.com/radar/paranoia
gem 'paranoia', '~> 2.0.1'
gem 'china_sms'
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

#supports CORS
gem 'rack-cors'

group :development do
  # Use mina for deployment
  # https://github.com/nadarei/mina
  gem 'mina'
  # A robust Ruby code analyzer, based on the community Ruby style guide.
  # https://github.com/bbatsov/rubocop
  gem 'rubocop', '~> 0.18.1'
  gem "rake"
  # https://github.com/sickill/racksh
  gem "racksh"
  # reloading rack development server / forking version of rackup
  # Start your app by running 'shotgun'
  gem 'shotgun'
end

group :test do
  gem 'minitest', require: false
  gem 'rack-test', require: 'rack/test'
end

group :development, :test do
  # gem 'api_taster', '0.6.0'
  gem 'pry'
end

group :production do
  # Ruby Web Server
  gem 'puma'
end

