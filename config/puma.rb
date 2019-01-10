application_path = File.expand_path("../../..", __FILE__)
railsenv = 'staging'
directory application_path
environment railsenv
daemonize true
pidfile "#{application_path}/tmp/pids/puma-#{railsenv}.pid"
state_path "#{application_path}/tmp/pids/puma-#{railsenv}.state"
stdout_redirect "#{application_path}/log/puma-#{railsenv}.stdout.log","#{application_path}/log/puma-#{railsenv}.stderr.log"
threads 1, 2
workers 1
preload_app!
bind "unix://#{application_path}/tmp/sockets/#{railsenv}.sock"
