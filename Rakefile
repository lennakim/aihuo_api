require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

# add command 'rake routes'
require 'rake'

task :environment do
  ENV["RACK_ENV"] ||= 'development'
  require File.expand_path("../config/environment", __FILE__)
end

task :routes => :environment do
  ShouQuShop::API.routes.each do |route|
    method = route.route_method.ljust(10)
    path = route.route_path
    puts "#{method} #{path}"
  end
end

# add command 'rake test'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  # t.libs << "lib"
  t.libs << "test"
end

# run 'rake' will be run 'rake test'
task default: :test
