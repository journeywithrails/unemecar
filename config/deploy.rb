
# Staging
# See config/deploy/* 
set :stages, %w(staging development production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'
#set :application, "staging.racemenu.com"
#set :deploy_to, "/home/#{user}/domains/#{application}"

# Login Details
set :user, "jill"
set :password, "mak3itliv3a"
set :runner, user
set :use_sudo, false

# Repository Details
set :repository,  "git@gnrah6aa.joyent.us:racemenu.git"
set :scm, "git"
set :scm_passphrase, ""
set :branch, "master"
set :deploy_via, :remote_cache

# Other Settings
default_run_options[:pty] = true
set :chmod755, "app config db lib public vendor script script/* public/disp*"

# Servers
set :servers, "gnrah6aa.joyent.us"
role :app, servers
role :web, servers
role :db, servers, :primary => true

# Deploy Tasks
namespace :deploy do

	# Passenger Restart
	namespace :passenger do
		desc "Restart Application"
		task :restart, :roles => :app do
			run "cd #{current_path}; touch tmp/restart.txt"
		end
	end

	# Mongrel Restart
	namespace :mongrel do
		desc "Mongrel restart"
		task :restart, :roles => :app do
			deploy.mongrel.stop
			puts "Stoped mongrel service. Should hopefully respawn. Otherwise run deploy:mongrel:start"
			# Not starting. Mongrel server respawns
			#deploy.mongrel.start
		end

		desc "Mongrel start"
		task :start, :roles => :app do
			run "mongrel_rails start -c #{current_path} -p #{mongrel_pid} -d -e #{env} -a 127.0.0.1 -P log/mongrel-#{mongrel_pid}.pid"
		end

		desc "Mongrel stop"
		task :stop, :roles => :app do
			run "cd #{current_path}; /opt/local/bin/mongrel_rails stop -P log/mongrel-#{mongrel_pid}.pid"
		end
	end

	# Restart ( Mongrel Restart shortcut )
	desc "Custom restart task"
	task :restart, :roles => :app, :except => { :no_release => true } do
		deploy.mongrel.restart
	end

	# Server Settings
	desc "Use custom (domain specific) database.yml and facebooker.yml file"
	task :copy_custom_files, :roles => :app do
		run "cd #{current_path}; cp config/database_#{application}.yml config/database.yml"
		run "cd #{current_path}; cp config/facebooker_racemenu.yml config/facebooker.yml"
	end

	# Static content path
	desc "Static content path"
	task :link_content_path, :roles => :app do
		run "cd #{current_path}; ln -s #{shared_path}/system/assets public/assets"
		run "cd #{current_path}; ln -s #{shared_path}/system/uploads public/uploads"
	end
end

# Gem Tasks
# Compile
desc "Compile gems on-demand" ## usage: build_gems=1 cap deploy
task :after_update_code, :roles => :app do
  if ENV['build_gems'] and ENV['build_gems'] == '1'
    run "rake -f #{release_path}/Rakefile gems:build"
  end
end

# Tests
namespace :env do
	desc "Echo environment vars" 
	task :echo do
		run "echo $PATH"
		run "env"
	end
	
	desc "Test Task, Print pervious release" 
	task :previous_release do
		run "echo #{previous_release}"
	end
end

# Callbacks
after "deploy:update", "deploy:copy_custom_files"
after "deploy:update", "deploy:link_content_path"
after "deploy:restart", "deploy:cleanup"
before "deploy:restart", "deploy:migrate"

