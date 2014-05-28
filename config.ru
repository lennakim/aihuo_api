# This file is used by Rack-based servers to start the application.

# supports JavaScript Cross-Domain XMLHttpRequest Calls works
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    # resource '*', headers: :any, methods: :get
    resource '*', headers: :any
  end
end

# Fixed: extended the Logger class to handle the write method.
# https://github.com/customink/stoplight/issues/14
require 'logger'
class ::Logger; alias_method :write, :<<; end

# /Users/victor/Work/Projects/aihuo_api
# $:.unshift File.expand_path('..', __FILE__)
require ::File.expand_path('../config/environment', __FILE__)

use Rack::Config do |env|
  env['api.tilt.root'] = ::File.expand_path('../lib/views', __FILE__)
end

if ENV['RACK_ENV'] == "development"
  # use Rack::ContentLength
  # use Rack::ContentType, "text/plain"
  use Rack::ShowExceptions
  use Rack::CommonLogger, Logger.new('log/development.log')

  puts "Loading NewRelic in developer mode ..."
  require 'new_relic/rack/developer_mode'
  use NewRelic::Rack::DeveloperMode
else
  use Rack::CommonLogger, Logger.new('log/production.log')
end

use Rack::ConditionalGet
use Rack::ETag

# Puma, Sinatra, ActiveRecord and "could not obtain a database connection"
# http://snippets.aktagon.com/snippets/621-puma-sinatra-activerecord-and-could-not-obtain-a-database-connection-
use ActiveRecord::ConnectionAdapters::ConnectionManagement

# NewRelic::Agent.manual_start

# run ShouQuShop::API
run ShouQuShop::App.instance
