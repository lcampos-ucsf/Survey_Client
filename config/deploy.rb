set :application, "RailsForce_AppTemplate"
set :repository,  "git@github.com:lcampos/RailsForce_AppTemplate.git"
set :deploy_to, "/home/luis/rails_apps/RailsForce_AppTemplate"
set :user, "luis"
set :scm_passphrase, "9x2cKL&re4"
set :branch, "master"
set :git_enable_submodules, 1
set :ssh_options,{:forward_agent => true}

set :deploy_via, :remote_cache
set :use_sudo, false


set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "64.54.142.34"                          # Your HTTP server, Apache/etc
role :app, "64.54.142.34"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
	task :start do ; end
	task :stop do ; end
	task :restart, :roles => :app, :except => { :no_release => true } do
	 run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
	end
	desc "Installs required gems"  
	task :gems, :roles => :app do  
	 run "cd #{current_path} && sudo rake gems:install RAILS_ENV=production"  
	end  
	after "deploy:setup", "deploy:gems"     

	#this puts a maintenance page on the app while deployment takes place
	#before "deploy", "deploy:web:disable"  
	#after "deploy", "deploy:web:enable"  
end