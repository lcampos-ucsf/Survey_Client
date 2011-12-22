SampleApp::Application.configure do
  
  # Settings specified here will take precedence over those in config/application.rb
  
  ENV['full_host'] = "https://yourtemplateapp.heroku.com"
  ENV['sfdc_login'] = "https://login.salesforce.com"

  #You setup these in Setup > Development > Remote Access
  #Set your callback url to https://yourtemplateapp.heroku.com/auth/forcedotcom/callback  


  #NPIQA
  ENV['sfdc_consumer_key'] = "3MVG9GiqKapCZBwHxOJHdUt59hg74sCk_cEtqnjN5_Oz8VwuyGp7qS8hznIUW7_S8ovR7zPh6vrjWNVNJ.oog"
  ENV['sfdc_consumer_secret'] = "2416048170923412785" 

=begin
  #NPIDEV
  ENV['sfdc_consumer_key'] = "3MVG9GiqKapCZBwGKWN18VcBTA5d82sFCh7vEQx5F1GRPo5guUOp1SJrDNereyBomRnYHv5oE7a1VJuu8fBdC"
  ENV['sfdc_consumer_secret'] = "1042066715413818107"
=end
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

  ENV['DEFAULT_CUSTOM_URL'] = "https://ucsf--myaccessdv.cs9.my.salesforce.com/"
  
  ENV['sf_user'] = "005A0000001e1G6"
  ENV['sfdc_api_version'] = '23.0'
  
  #ENV['DATABASEDOTCOM_CLIENT_ID'] = ENV['sfdc_consumer_key']
  #ENV['DATABASEDOTCOM_CLIENT_SECRET'] = ENV['sfdc_consumer_secret'] 

  

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
