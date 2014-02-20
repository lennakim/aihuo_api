require 'puma'
#!/usr/bin/env puma

# Start Puma with next command:
# bundle exec puma -e production -C ./config/puma.rb
application_path = '/var/www/api.aihuo360.com/current'

# The directory to operate out of.
directory application_path

# Set the environment in which the rack's app will run.
environment 'production'

# Daemonize the server into the background. Highly suggest that
# this be combined with `pidfile` and `stdout_redirect`.
daemonize true

workers 2
threads 8, 32

# Store the pid of the server in the file at `path`.
pidfile "#{application_path}/tmp/pids/puma.pid"

# Use `path` as the file to store the server info state. This is
# used by `pumactl` to query and control the server.
state_path "#{application_path}/tmp/pids/puma.state"

# Redirect STDOUT and STDERR to files specified.
stdout_redirect "#{application_path}/log/puma.stdout.log", "#{application_path}/log/puma.stderr.log"

# Bind the server.
bind "unix://#{application_path}/tmp/sockets/puma.sock"

preload_app! #utilizing copy-on-write
activate_control_app "unix://#{application_path}/tmp/sockets/puma.sock"
