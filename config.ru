# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../config/environment',  __FILE__)

use Rack::Config do |env|
  env['api.tilt.root'] = ::File.expand_path('../app/views',  __FILE__)
end

if ENV['RACK_ENV'] == "development"
  # http://rack.rubyforge.org/doc/Rack/CommonLogger.html
  # Common Log Format: httpd.apache.org/docs/1.3/logs.html#common
  # lilith.local - - [07/Aug/2006 23:58:02] "GET / HTTP/1.1" 500 -
  # use Rack::CommonLogger

  # use Rack::ContentLength
  # use Rack::ContentType, "text/plain"
  use Rack::Reloader
  use Rack::ShowExceptions
  # use Rack::Logger, Logger.new('log/development.log', :debug)
  use Rack::CommonLogger
else
  use Rack::CommonLogger, Logger.new('log/production.log', :debug)
end

# Puma, Sinatra, ActiveRecord and "could not obtain a database connection"
# http://snippets.aktagon.com/snippets/621-puma-sinatra-activerecord-and-could-not-obtain-a-database-connection-
use ActiveRecord::ConnectionAdapters::ConnectionManagement

run ShouQuShop::API
