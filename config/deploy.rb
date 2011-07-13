#$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
#require "rvm/capistrano"                  # Load RVM's capistrano plugin.
#set :rvm_ruby_string, 'ree@mood_chart'        # Or whatever env you want it to run in.

require 'bundler/capistrano'

set :application, "mood_chart"

set :repository,  "git@github.com:alx/mood-chart.git"
set :scm, :git

set :ssh_options, { :forward_agent => true, :port => 22104 }

set :user, "alex"
set :group, "alex"
set :deploy_to, "/home/alex/#{application}"

role :web, "moods.tetalab.org"                          # Your HTTP server, Apache/etc
role :app, "moods.tetalab.org"                          # This may be the same as your `Web` server
role :db,  "moods.tetalab.org", :primary => true # This is where Rails migrations will run

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

task :link_shared_directories do     
  run "ln -s #{shared_path}/bot_config.yml #{release_path}/bot/bot_config.yml"
  run "ln -s #{shared_path}/production.db #{release_path}/production.db"
  run "ln -s #{shared_path}/bot.rb.pid #{release_path}/bot/bot.rb.pid"
end    

after "deploy:update_code", :link_shared_directories

