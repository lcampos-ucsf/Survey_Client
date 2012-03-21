source 'http://rubygems.org'

gem 'rails', '3.1.0'

#this is for linux purposes
gem 'sqlite3-ruby', :require => 'sqlite3'

gem 'gravatar_image_tag', '1.0.0.pre2'

gem 'httparty'
gem 'savon'
gem 'cells', "~>3.6.7"
gem 'rack', "1.3.6"
gem 'multi_json', '1.0.4'
gem 'rake', '0.9.2.2'

#api connection with salesforce
gem 'databasedotcom', :git => 'git://github.com/lcampos/databasedotcom.git'

#adding widget gem apotomo
gem 'apotomo', '1.2.1'
gem 'jquery-rails', '~> 1.0.12'

#authentication strategy with salesforce
gem 'omniauth'
gem 'omniauth-salesforce', :git => 'git://github.com/jonathansnd/omniauth-salesforce.git'

#add pagination to surveys
gem 'kaminari'

#add security before saving input
gem 'sanitize', '2.0.3'

#adds new relic
gem 'newrelic_rpm'

#heroku dependency
group :production do
	#this is commented for fedora purposes
	#gem 'pg', '0.12.0'
end

group :development do
  	gem 'rspec-rails'
  	gem 'annotate', '2.4.0'
	gem 'faker', '0.3.1'
end

group :test do
  gem 'rspec'
  gem 'webrat', '0.7.1'
  gem 'factory_girl_rails', '1.0'
end
