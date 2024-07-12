server "genoview", user: 'ubuntu', roles: %w{web db app}

set :branch, 'main'
set :rbenv_ruby, '3.3.3'

set :rails_env, 'production'

append :linked_files, 'config/master.key'

# from https://github.com/capistrano/rails?tab=readme-ov-file#uploading-your-masterkey
namespace :deploy do
  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app) do
        unless test("[ -f #{shared_path}/config/master.key ]")
          upload! 'config/master.key', "#{shared_path}/config/master.key"
        end
      end
    end
  end
end
