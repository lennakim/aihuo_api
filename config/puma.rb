require 'puma'
#!/usr/bin/env puma
environment "production"
daemonize true

workers 2
threads 8, 32

wd = File.expand_path('../../', __FILE__)
log_path = File.join(wd, 'log')
tmp_path = File.join(wd, 'tmp')
Dir.mkdir(log_path) unless File.exist?(log_path)
Dir.mkdir(tmp_path) unless File.exist?(tmp_path)

bind  "unix:///var/run/api.aihuo360.com.sock"
pidfile File.join(tmp_path, 'puma.pid')
state_path File.join(tmp_path, 'puma.state')
stdout_redirect File.join(log_path, 'puma.out.log'), File.join(log_path, 'puma.err.log'), true

preload_app! #utilizing copy-on-write
activate_control_app
