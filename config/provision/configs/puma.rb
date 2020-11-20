
#!/usr/bin/env puma

directory '/home/deploy/applications/parser_app/current/'
rackup "/home/deploy/applications/parser_app/current/config.ru"
environment 'production'

pidfile "/home/deploy/applications/parser_app/shared/tmp/pids/puma.pid"
state_path "/home/deploy/applications/parser_app/shared/tmp/pids/puma.state"
stdout_redirect '/home/deploy/applications/parser_app/shared/log/puma_access.log', '/home/deploy/applications/parser_app/shared/log/puma_error.log', true


threads 0,16

bind 'unix:///home/deploy/applications/parser_app/shared/tmp/sockets/puma.sock'

workers 0

daemonize true

prune_bundler


on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = "/home/deploy/applications/parser_app/current/Gemfile"
end
