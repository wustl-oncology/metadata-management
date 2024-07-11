server "genoview", user: 'ubuntu', roles: %w{web db app}

set :branch, 'main'
set :rbenv_ruby, '3.3.3'

set :rails_env, 'production'

append :linked_files, 'config/master.key'

# if !ENV['CI']
#   set :ssh_options, {
#     keys: ENV['CIVIC_PROD_KEY'],
#     forward_agent: false,
#     auth_methods: %w(publickey)
#   }
# end
