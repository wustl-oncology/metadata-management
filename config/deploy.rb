require_relative 'deploy/puma'

# config valid for current version and patch releases of Capistrano
lock "~> 3.19.1"

set :application, 'genoview'
set :deploy_to, '/var/www/genoview/'

set :repo_url, "git@github.com:wustl-oncology/metadata-management.git"

set :rbenv_type, :user

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads', 'public/downloads', 'storage'

set :migration_role, :web
