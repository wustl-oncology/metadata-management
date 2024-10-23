if ENV['FLY_APP_NAME'].nil?
  app_dir = '/var/www/genoview/current'

  max_threads_count = 2
  min_threads_count = 2
  threads min_threads_count, max_threads_count

  plugin :solid_queue

  bind "unix://#{app_dir}/tmp/sockets/puma.sock"
  state_path "#{app_dir}/tmp/pids/puma.state"
  activate_control_app "unix://#{app_dir}/tmp/sockets/pumactl.sock"

  stdout_redirect "#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true

  environment ENV.fetch("RAILS_ENV") { "production" }

  # Specifies the `pidfile` that Puma will use.
  pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

  workers 2

  preload_app!

  plugin :tmp_restart
end
