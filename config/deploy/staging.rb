set :branch, :master

server '34.208.235.177', roles: %w(app db), user: 'ubuntu'

set :assets_roles, [:app]
set :rails_env, 'staging'
set :migrate_env, 'staging'

# set :sidekiq_config, "#{release_path}/config/sidekiq.yml"
# set :sidekiq_log, "#{release_path}/log/sidekiq.log"

namespace :deploy do
  namespace :assets do

    Rake::Task['deploy:assets:precompile'].clear_actions
    desc 'Precompile assets locally and upload to servers'
    task :precompile do
      run_locally do
        with rails_env: fetch(:rails_env) do
          execute 'bundle exec rake assets:precompile RAILS_ENV=staging'
        end
      end
      on roles(:app) do |host|
        puts '---------Host-------'
        puts host
        run_locally {execute 'mv ./public/assets/.sprockets**.json ./public/assets/manifest.json'}
        upload!('./public/assets/manifest.json', "#{shared_path}/public/assets/")
        upload!('config/application.yml', "#{release_path}/config/application.yml")
      end
      run_locally { execute 'rm -rf public/assets' }
    end
  end
end