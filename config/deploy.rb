#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'bundler/capistrano'
require 'rvm/capistrano'
load 'deploy/assets'
yourhost = 'your_host_here'
default_run_options[:pty] = true
set :application, "named"
set :repository,  "ssh://git@#{yourhost}/webdlz.git"
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :user, 'named'
set :ssh_options, { :forward_agent => true }
set :default_env, 'production'
set :deploy_to, "/home/named/#{application}/www"
set :ssh_options, :port => '22'
set :scm_verbose, true
set :port, '22'
set :runner, "named"
set :use_sudo, false
set :domain, "named@#{yourhost}"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"
set :rvm_ruby_string, 'ruby-2.0.0-p247'
set :rvm_type, :user
role :web, "#{yourhost}"                          # Your HTTP server, Apache/etc
role :app, "#{yourhost}"                          # This may be the same as your `Web` server
                                                  #role :db,  "172.16.5.55", :primary => true # This is where Rails migrations will run


before "deploy:assets:precompile", "bundle:install"
after "deploy", "deploy:bundle"
after "deploy:bundle", "deploy:migrate"
after "deploy:migrate", "deploy:unicorn_upgrade"
                                                  ###after "deploy:unicorn_restart", "deploy:nginx_reload"
namespace :deploy do
  task :bundle, :roles => :app do
    run "cd #{deploy_to}/current/ && bundle install"
  end

  #task :assets, :roles => :app do
  #  run "cd /home/named/named/www/current/ &&  bundle exec rake assets:precompile"
  #end

  task :unicorn_upgrade, :roles => :app, :except => { :no_release => true } do
    run "sudo /etc/init.d/unicorn_named upgrade"
  end
  task :migrate, :roles => :app do
    run "cd /home/named/named/www/current/ && RAILS_ENV=production bundle exec rake db:migrate"
  end
###  task :nginx_reload, :roles => :app  do
###    run "sudo /etc/init.d/nginx reload"
###  end
###end
end
#default deploy.rb

#set :application, "set your application name here"
#set :repository,  "set your repository location here"
#
#set :scm, :subversion
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
