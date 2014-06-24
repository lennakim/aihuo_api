# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

use Rack::Config do |env|
  env['api.tilt.root'] = ::File.expand_path('../app/views', __FILE__)
end

if ENV['RACK_ENV'] == "development"
  puts "Loading NewRelic in developer mode ..."
  require 'new_relic/rack/developer_mode'
  use NewRelic::Rack::DeveloperMode
end

NewRelic::Agent.manual_start

run Rails.application
