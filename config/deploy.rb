# Deploy with Ansible on a new server:
#   $ (cd config/provision && ansible-playbook -i178.62.254.62, playbook.yml)
#   $ bundle exec cap production deploy
#   $ bundle exec cap production rake task=db:seed

lock '3.14.1'

set :application, 'parser_app'
set :repo_url, 'https://github.com/dima-antonenko/parser_app.git'
set :branch, 'master'
set :deploy_to, '/home/deploy/applications/parser_app'

set :log_level, :info
set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads public/sitemaps node_modules}

set :rbenv_type, :user
set :rbenv_ruby, '2.7.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_roles, :all
set :keep_releases, 1

set :puma_init_active_record, true

desc 'Run rake tasks on server'
task :rake do
  on roles(:app), in: :sequence, wait: 5 do
    within release_path do
      with rails_env: :production do
        execute :rake, ENV['task'], 'RAILS_ENV=production'
      end
    end
  end
end
# before "_kek:assets:precompile", "_kek:yarn_install"
namespace :_kek do
  desc 'Run rake yarn:install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end
end
# before "_kek:assets:precompile", "deploy:npm_install"
namespace :deploy do
  desc 'Run rake npm install'
  task :npm_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && npm install")
      end
    end
  end
  desc 'Start puma'
  task :start do
    on roles(fetch(:puma_role)) do |role|
      git_plugin.puma_switch_user(role) do
        if test "[ -f #{fetch(:puma_conf)} ]"
          info "using conf file #{fetch(:puma_conf)}"
        else
          invoke 'puma:config'
        end
        if test("[ -f #{fetch(:puma_pid)} ]") && test(:kill, "-0 $( cat #{fetch(:puma_pid)} )")
          info 'Already Puma is running'
        else
          within current_path do
            with rack_env: fetch(:puma_env) do
              execute :puma, "-C #{fetch(:puma_conf)} --daemon"
            end
          end
        end
      end
    end
  end
  %w[halt stop status].map do |command|
    desc "#{command} puma"
    task command do
      on roles fetch(:puma_role) do |role|
        within current_path do
          git_plugin.puma_switch_user(role) do
            with rack_env: fetch(:puma_env) do
              if test "[ -f #{fetch(:puma_pid)} ]"
                if test :kill, "-0 $( cat #{fetch(:puma_pid)} )"
                  execute :pumactl, "-S #{fetch(:puma_state)} -F #{fetch(:puma_conf)} #{command}"
                else
                  # delete invalid pid file , process is not running.
                  execute :rm, fetch(:puma_pid)
                end
              else
                # pid file not found, so puma is probably not running or it using another pidfile
                warn 'Puma not running'
              end
            end
          end
        end
      end
    end
  end
  %w[phased-restart restart].map do |command|
    desc "#{command} puma"
    task command do
      on roles fetch(:puma_role) do |role|
        within current_path do
          git_plugin.puma_switch_user(role) do
            with rack_env: fetch(:puma_env) do
              if test("[ -f #{fetch(:puma_pid)} ]") && test(:kill, "-0 $( cat #{fetch(:puma_pid)} )")
                # NOTE pid exist but state file is nonsense, so ignore that case
                execute :pumactl, "-S #{fetch(:puma_state)} -F #{fetch(:puma_conf)} #{command}"
              else
                # Puma is not running or state file is not present : Run it
                invoke 'puma:start'
              end
            end
          end
        end
      end
    end
  end
  task :check do
    on roles(fetch(:puma_role)) do |role|
      # Create puma.rb for new deployments
      unless test "[ -f #{fetch(:puma_conf)} ]"
        warn 'puma.rb NOT FOUND!'
        git_plugin.upload_puma_rb(role)
        info 'puma.rb generated'
      end
    end
  end
  task :smart_restart do
    if !git_plugin.puma_preload_app? && git_plugin.puma_workers.to_i > 1
      invoke 'puma:phased-restart'
    else
      invoke 'puma:restart'
    end
  end
  # after  :finishing,    :restart
end
# before "deploy:assets:precompile", "yarn:install"
namespace :yarn do
  desc 'Install all JavaScript dependencies as specified via Yarn'
  task :install do
    system('./bin/yarn install --no-progress --production')
  end
end
# Run Yarn prior to Sprockets assets precompilation, so dependencies are available for use.
if Rake::Task.task_defined?('assets:precompile')
  Rake::Task['assets:precompile'].enhance ['yarn:install']
end
