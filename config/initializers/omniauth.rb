

module OmniAuth
  module Strategies
    #tell omniauth to load our strategy
   # autoload :Forcedotcom, 'lib/forcedotcom'
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do 
	provider :salesforce, ENV['sfdc_consumer_key'], ENV['sfdc_consumer_secret'], { :display => 'touch', :scope => 'full' }

end