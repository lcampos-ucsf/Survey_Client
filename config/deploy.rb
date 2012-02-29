# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

#run the bundle install 
require 'bundler/capistrano'

# Load RVM's capistrano plugin. 
require 'rvm/capistrano'

#fixes no tty present and no askpass program specified error
default_run_options[:pty] = true

set :application, "RailsForce_AppTemplate"
set :repository,  "git@github.com:lcampos/RailsForce_AppTemplate.git"
set :deploy_to, "/var/www/webapps/RailsForce_AppTemplate"
set :user, "luis"
set :scm_passphrase, "9x2cKL&re4"
set :branch, "master"
set :git_enable_submodules, 1

#uses github local keys instead of keys on the server
set :ssh_options,{:forward_agent => true}

# Or whatever env you want it to run in.
#set :rvm_ruby_string, 'ree@rails3'

#user looks for rvm in $HOME/.rvm where as system uses the /usr/local as set for system wide installs
#set :rvm_type, :system 

set :deploy_via, :copy
set :use_sudo, true



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

#set :default_environment, {
#  'PATH' => "/path/to/.rvm/gems/ree/1.8.7/bin:/path/to/.rvm/bin:/path/to/.rvm/ree-1.8.7-2009.10/bin:$PATH",
#  'RUBY_VERSION' => 'ruby 1.8.7',
#  'GEM_HOME'     => '/path/to/.rvm/gems/ree-1.8.7-2010.01',
#  'GEM_PATH'     => '/path/to/.rvm/gems/ree-1.8.7-2010.01',
#  'BUNDLE_PATH'  => '/path/to/.rvm/gems/ree-1.8.7-2010.01'  # If you are using bundler.
#}

#namespace :rvm do
#  task :trust_rvmrc do
#    run \"rvm rvmrc trust \#\{release_path\}\"
#  end
#end

#after "deploy", "rvm:trust_rvmrc"


