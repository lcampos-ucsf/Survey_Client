source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'sqlite3'
gem 'gravatar_image_tag', '1.0.0.pre2'

gem 'httparty'
gem 'savon'
gem 'cells', "~>3.6.7"
gem 'rack', "1.3.5"
gem 'multi_json', '1.0.3'

#api connection with salesforce
gem 'databasedotcom', :git => 'git://github.com/lcampos/databasedotcom.git'

#adding widget gem apotomo
gem 'apotomo', '1.2.1'
gem 'jquery-rails', '>= 1.0.12'

#authentication strategy with salesforce
gem 'omniauth'
gem 'omniauth-salesforce', :git => 'git://github.com/jonathansnd/omniauth-salesforce.git'

#add pagination to surveys
gem 'kaminari'

#heroku dependency
group :production do
	#gem 'pg'
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
