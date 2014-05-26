# https://gist.github.com/stas/4539489
require 'mina/bundler'
# require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '115.29.164.196'
set :deploy_to, '/var/www/api.aihuo360.com'
set :repository, 'git@bitbucket.org:Xiaopuzhu/adultshop_new.git'
set :branch, 'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log', 'tmp']

# Optional settings:
set :user, 'root'    # Username in the server to SSH to.
set :port, '19009'     # SSH port number.

set :rvm_path, '/usr/local/rvm/scripts/rvm'
set :app_path, lambda { "#{deploy_to}/#{current_path}" }
# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[ruby-2.1.1@api]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    # invoke :'bundle:install --binstubs'
    # invoke :'rails:db_migrate'
    # invoke :'rails:assets_precompile'

    to :launch do
      # queue "touch #{deploy_to}/tmp/restart.txt"
      invoke :restart
    end
  end
end

desc 'Starts the application'
task :start => :environment do
  # queue "cd #{app_path} ; bundle exec puma -C config/puma.rb -e production -d"
  queue "cd #{app_path} ; bundle exec puma"
end

desc 'Stop the application'
task :stop => :environment do
  queue "cd #{app_path} ; bundle exec pumactl -P #{app_path}/tmp/pids/puma.pid stop"
end

desc 'Restart the application'
task :restart => :environment do
  invoke :stop
  invoke :start
  # queue "cd #{app_path} ; bundle exec pumactl -P #{app_path}/tmp/pids/puma.pid restart"
end

task :cat_server_log => :environment do
  queue "tail -n 200 #{app_path}/log/production.log"
end

task :cat_err_log => :environment do
  queue "tail -n 200 #{app_path}/log/puma.err.log"
end

task :clean_cache => :environment do
  queue! 'echo "Clean Cache:"'
  queue! "echo 'rm -rf #{app_path}/tmp/cache/*'"
  queue! "rm -rf #{app_path}/tmp/cache/*"
end

desc 'run racksh'
task :console => :environment do
  queue "cd #{app_path} ; bundle exec racksh"
end


# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

