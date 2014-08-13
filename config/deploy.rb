# config valid only for Capistrano 3.2.1
lock '3.2.1'

set :rails_env, :production

# Load values for remote user, ip & port
set :secrets, YAML.load(ERB.new(
  File.read(File.join('config', 'secrets.yml'))).result
)[fetch(:rails_env).to_s]

# Set application & repo
set :application, 'underflow'
set :full_app_name, "#{fetch :application}_#{fetch :stage}"

set :repo_url, 'git@github.com:leemour/underflow.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/srv/www/#{fetch :full_app_name}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %W{
  config/secrets.yml
  config/unicorn.rb
}

# Default value for linked_dirs is []
set :linked_dirs, %w{
  bin
  log
  tmp/pids tmp/cache tmp/sockets
  vendor/bundle
  public/system public/uploads
}

# Shared dirs to be created
set :create_shared_dirs, %w{
  bin
  config
  db
  log
  public
}

# Shared dirs to be uploaded
set :upload_dirs, %w{
  bin/.
}

# Shared config files to be uploaded and linked
set :upload_files, [
  {from: 'config/secrets.yml',          to: 'config/secrets.yml'},
  # {from: 'config/shared/monit',         to: 'config/monit'},
  {from: 'config/shared/unicorn.rb',    to: 'config/unicorn.rb'},
  {from: 'config/shared/unicorn.sh',    to: 'config/unicorn.sh'},
  {from: 'config/shared/nginx_staging.conf',    to: 'config/nginx_staging.conf'},
  {from: 'config/shared/nginx_production.conf', to: 'config/nginx_production.conf'},
]

# Make config files executable
set :executable_files, %w{
  config/unicorn.sh
}

# Make some files writeable
set :writable_files, []# %W{
#   db/#{fetch :application}_#{fetch :rack_env}.db
# }

# Create files unless they exist
set :touch_files, %w{
  unicorn.sock
  log/nginx_access.log
  log/nginx_error.log
  log/unicorn.log
  log/unicorn.err.log
}

# Symlink config files to system paths
set :symlinks, [
  {
    from: "config/nginx_#{fetch :stage}.conf",
    to:   "/etc/nginx/sites-enabled/#{fetch :full_app_name}"
  },
  # {
  #   from: "config/monit",
  #   to:   "/etc/monit/conf.d/#{fetch :full_app_name}.conf"
  # },
  {
    from: "config/unicorn.sh",
    to:   "/etc/init.d/unicorn_#{fetch :application}"
  }
]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# SSH
set :ssh_options, {
  forward_agent: true,
  port: fetch(:secrets)['remote_port']
}

# Setup rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch :rbenv_path} RBENV_VERSION=#{fetch :rbenv_ruby} #{fetch :rbenv_path}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# Setup Bundler
set :bundle_bins, fetch(:bundle_bins, []) + %w{unicorn}

namespace :deploy do
  before :deploy, "check:revision"

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "unicorn:restart"
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
  after :restart, "private_pub:restart"

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

namespace :unicorn do
  %w[start stop restart reload upgrade].each do |command|
    desc "#{command} Unicorn server"
    task command do
      on roles(:app) do
        within current_path do
          execute "service unicorn_#{fetch :application} #{command} #{fetch :stage}"
        end
      end
    end
  end
end