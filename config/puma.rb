require 'puma'
#!/usr/bin/env puma

# Set the environment in which the rack's app will run.
environment 'production'

# Daemonize the server into the background. Highly suggest that
# this be combined with `pidfile` and `stdout_redirect`.
daemonize true

workers 2
threads 8, 32

wd = File.expand_path('../../', __FILE__)
tmp_path = File.join(wd, 'tmp')
log_path = File.join(wd, 'log')
Dir.mkdir(tmp_path) unless File.exist?(tmp_path)

# Store the pid of the server in the file at `path`.
pidfile File.join(tmp_path, 'pids', 'puma.pid')

# Use `path` as the file to store the server info state. This is
# used by `pumactl` to query and control the server.
state_path File.join(tmp_path, 'sockets', 'puma.state')

# Redirect STDOUT and STDERR to files specified.
stdout_redirect File.join(log_path, 'puma.out.log'), File.join(log_path, 'puma.err.log'), true

# Bind the server.
bind "unix:///var/run/api.aihuo360.com.sock"

# Thread safety
# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

preload_app! #utilizing copy-on-write
activate_control_app
