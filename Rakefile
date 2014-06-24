# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

desc "API Routes"
task :routes do
  puts "method     path"
  ::API.routes.each do |route|
    method = route.route_method.ljust(10)
    path = route.route_path
    puts "#{method} #{path}"
  end
end

Rails.application.load_tasks
