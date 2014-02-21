require 'puma'
#!/usr/bin/env puma
environment "production"
daemonize true

workers 2
threads 8, 32

wd = File.expand_path('../../', __FILE__)
tmp_path = File.join(wd, 'log')
Dir.mkdir(tmp_path) unless File.exist?(tmp_path)

bind  "unix:///var/run/adultshop_api.sock"
pidfile File.join(tmp_path, 'api_puma.pid')
state_path File.join(tmp_path, 'api_puma.state')
stdout_redirect File.join(tmp_path, 'api_puma.out.log'), File.join(tmp_path, 'api_puma.err.log'), true

preload_app! #utilizing copy-on-write
activate_control_app
