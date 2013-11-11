require 'bundler/capistrano'
require 'capistrano-unicorn'

set :application, "splash"
set :repository,  "git@github.com:jeremyby/splash.git"
set :branch, "master"
set :deploy_to, "/var/www/spash"
set :keep_releases, 3

set :scm, :git
set :user, "deployer"
set :use_sudo, false
set :deploy_via, :remote_cache

default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash -l'


server "edinburgh", :app, :web, :db, :primary => true

# role :web, "ec2-54-241-119-74.us-west-1.compute.amazonaws.com"                          # Your HTTP server, Apache/etc
# role :app, "ec2-54-241-119-74.us-west-1.compute.amazonaws.com"                          # This may be the same as your `Web` server
# role :db,  "ec2-54-241-119-74.us-west-1.compute.amazonaws.com", :primary => true       # This is where Rails migrations will run
# role :db,  "your slave db-server here"


after 'deploy:restart', 'unicorn:reload'    # app IS NOT preloaded
after 'deploy:restart', 'unicorn:restart'   # app preloaded
after 'deploy:restart', 'unicorn:duplicate' # before_fork hook implemented (zero downtime deployments)

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"


namespace :rake do  
  desc "Run a task on a remote server."  
  # run like: cap staging rake:invoke task=a_certain_task  
  task :invoke do  
    run("cd #{deploy_to}/current; bundle exec rake #{ENV['task']} RAILS_ENV=production")  
  end  
end