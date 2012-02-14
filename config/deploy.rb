set :application, "RailsForce_AppTemplate"
set :repository,  "git@github.com:lcampos/RailsForce_AppTemplate.git"
set :deploy_to, "/rails_apps/RailsForce_AppTemplate"
set :user, "webapp"
set :scm_passphrase, ""
set :branch, "master"
set :git_enable_submodules, 1
ssh_options[:forward_agent] = true

set :deploy_via, :remote_cache
set :use_sudo, false


set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "64.54.246.168:443"                          # Your HTTP server, Apache/etc
role :app, "64.54.246.168:443"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
	task :start do ; end
	task :stop do ; end
	task :restart, :roles => :app, :except => { :no_release => true } do
	 run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
end
end