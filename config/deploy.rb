# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'githubawards'
set :repo_url, 'git@github.com:vdaubry/github-awards.git'
set :branch, 'display-redis-ranks'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/srv/www/githubawards'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

# Puma conf
set :puma_pid, -> { File.join(shared_path, 'tmp', 'pids', 'puma.pid') }
set :puma_access_log, -> { File.join(shared_path, 'log', 'puma_access.log') }
set :puma_error_log, -> { File.join(shared_path, 'log', 'puma_error.log') }

# Sidekiq conf
set :sidekiq_pid, -> { File.join(shared_path, 'tmp', 'pids', 'sidekiq.pid') }


namespace :deploy do
  
  desc "Check that we can access everything"
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute :rake, 'cache:clear'
      end
    end
  end
  
  desc "Upload config files"
  task :upload_conf  do
    on roles(:web) do
      puma_template = ERB.new File.read("config/deploy/templates/puma.erb")
      upload! StringIO.new(puma_template.result(binding)), File.join(shared_path, 'puma.rb')
      
      sidekiq_template = ERB.new File.read("config/deploy/templates/sidekiq.erb")
      upload! StringIO.new(sidekiq_template.result(binding)), File.join(shared_path, 'sidekiq.yml')
      
      upload! 'config/database.yml', "#{deploy_to}/shared/database.yml"
      upload! 'config/newrelic.yml', "#{deploy_to}/shared/newrelic.yml"
    end
  end
  
  desc "Symlinks config files"
  task :symlink_config do
    on roles(:web) do
      execute "ln -nfs #{deploy_to}/shared/database.yml #{current_path}/config/database.yml"
      execute "ln -nfs #{deploy_to}/shared/newrelic.yml #{current_path}/config/newrelic.yml"
    end
  end
  
  desc "restart process watched by monit"
  task :monit_restart do
    on roles(:web) do
      puts "restarting services"
      sudo "monit restart puma"
      sudo "monit restart sidekiq"
    end
  end

  after "deploy:published", "deploy:symlink_config"
  after "deploy:symlink_config", "deploy:monit_restart"
end
