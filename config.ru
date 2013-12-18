# This file is used by Rack-based servers to start the application.

# Fixed: extended the Logger class to handle the write method.
# https://github.com/customink/stoplight/issues/14
require 'logger'
class ::Logger; alias_method :write, :<<; end

require ::File.expand_path('../config/environment',  __FILE__)

use Rack::Config do |env|
  env['api.tilt.root'] = ::File.expand_path('../app/views',  __FILE__)
end

if ENV['RACK_ENV'] == "development"
  # use Rack::ContentLength
  # use Rack::ContentType, "text/plain"
  use Rack::ShowExceptions
  use Rack::CommonLogger, Logger.new('log/development.log')
else
  use Rack::CommonLogger, Logger.new('log/production.log')
end

# Make garner works
use Rack::ConditionalGet
use Rack::ETag
# use Rack::Cache, {
#   :verbose => true,
#   :metastore => 'file:/Users/victor/Work/Projects/aihuo_api/tmp/cache/meta',
#   :entitystore => 'file:/Users/victor/Work/Projects/aihuo_api/tmp/cache/body'
# }


# Puma, Sinatra, ActiveRecord and "could not obtain a database connection"
# http://snippets.aktagon.com/snippets/621-puma-sinatra-activerecord-and-could-not-obtain-a-database-connection-
use ActiveRecord::ConnectionAdapters::ConnectionManagement

# run ShouQuShop::API
run ShouQuShop::App.instance
