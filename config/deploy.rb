# config valid only for current version of Capistrano
lock "3.8.1"

set :application, 'Promorails'
set :repo_url, 'git@bitbucket.org:bitcot/promotracks-rails.git'
set :deploy_to, '/home/ubuntu/www/promo'
set :rvm_ruby_version, 'ruby-2.3.0@promo'

# Default value for :format is :airbrussh.
set :format, :pretty

set :deploy_user, 'ubuntu'
set :ssh_options, {:forward_agent => true}
set :keep_releases, 5
set :user, 'ubuntu'
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :pty, false

# SSHKit.config.command_map[:sidekiq] = "source ~/.bash_profile && bundle exec sidekiq"
# SSHKit.config.command_map[:sidekiqctl] = "source ~/.bash_profile && bundle exec sidekiqctl"

after "deploy", "deploy:restart"

set :slackistrano, {
    klass: Slackistrano::SlackistranoMessaging,
    channel: %w(#promo-tracks #promotracks),
    webhook: 'https://hooks.slack.com/services/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'
}

namespace :deploy do
  after 'deploy:publishing', 'thin:restart'
  after :finishing, "deploy:cleanup"
end