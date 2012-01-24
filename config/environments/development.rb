SampleApp::Application.configure do

  # Settings specified here will take precedence over those in config/application.rb

  #NPI-DEV
  ENV['SALESFORCE_KEY'] = ""
  ENV['SALESFORCE_SECRET'] = ""
  ENV['SALESFORCE_SANDBOX_KEY'] = "3MVG9GiqKapCZBwGKWN18VcBTA1KmaZj2YV7ufz52FM8PLm6XWITmy2BseIvf3ROwvzZzKVVYFzAy.glsMTAj"
  ENV['SALESFORCE_SANDBOX_SECRET'] = "2582046431606031750"
  ENV['SALESFORCE_PRERELEASE_KEY'] = ""
  ENV['SALESFORCE_PRERELEASE_SECRET'] = ""
  ENV['DATABASE_DOT_COM_KEY'] = ""
  ENV['DATABASE_DOT_COM_SECRET'] = ""
  ENV['SALESFORCE_CUSTOM_KEY'] = "3MVG9GiqKapCZBwGKWN18VcBTA0zJQA8mXhFhfxzf99_c9nB3f5ITBipAIYuBUb9Xox_UkcAsIVJuWTcjVOVQ"
  ENV['SALESFORCE_CUSTOM_SECRET'] = "7879557555915093217"

  ENV['DEFAULT_CUSTOM_URL'] = "https://medctr--npidev.cs11.my.salesforce.com"
  ENV['DEFAULT_SANDBOX_URL'] = "https://test.salesforce.com"
  ENV['SURVEY_BUILDER_URL'] = "https://ucsf-builder-dev.heroku.com/index"  
  ENV['IDP_UCSF_LOGOUT'] = ' https://idp-stage.ucsf.edu/idp/shib_logout.jsp?url=https://npi-dev.heroku.com'


=begin
  #NPI-QA
  ENV['SALESFORCE_KEY'] = ""
  ENV['SALESFORCE_SECRET'] = ""
  ENV['SALESFORCE_SANDBOX_KEY'] = "3MVG9GiqKapCZBwHxOJHdUt59hnj4Vwa8tt1y5prV6Jk4WPd7oHKSAh5o41FkqvzRa6czvRYr_NqHdSf5K2Ob"
  ENV['SALESFORCE_SANDBOX_SECRET'] = "7327542734086133767"
  ENV['SALESFORCE_PRERELEASE_KEY'] = ""
  ENV['SALESFORCE_PRERELEASE_SECRET'] = ""
  ENV['DATABASE_DOT_COM_KEY'] = ""
  ENV['DATABASE_DOT_COM_SECRET'] = ""
  ENV['SALESFORCE_CUSTOM_KEY'] = "3MVG9GiqKapCZBwHxOJHdUt59hnj4Vwa8tt1yBg5fW3OtJIEfoFnsGW_rT5huS5Zg02WpKjFPQ9Tmss.HKgAk"
  ENV['SALESFORCE_CUSTOM_SECRET'] = "2691895098048201861"

  ENV['DEFAULT_CUSTOM_URL'] = "https://medctr--npiqa.cs11.my.salesforce.com"
  ENV['DEFAULT_SANDBOX_URL'] = "https://test.salesforce.com"
  ENV['SURVEY_BUILDER_URL'] = "https://ucsf-builder-qa.heroku.com/index" 
  ENV['IDP_UCSF_LOGOUT'] = ' https://idp-stage.ucsf.edu/idp/shib_logout.jsp?url=https://npi-qa.heroku.com'
=end    


  
  ENV['DEFAULT_PROVIDER'] = "customurl" #'salesforcesandbox'
  ENV['sfdc_api_version'] = '23.0'
  ENV['app_timeout'] = '900' #(15 mins)time in seconds


  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
end

