SampleApp::Application.configure do
  
  # Settings specified here will take precedence over those in config/application.rb

  #NPI-DEV
  ENV['SALESFORCE_KEY'] = ""
  ENV['SALESFORCE_SECRET'] = ""
  ENV['SALESFORCE_SANDBOX_KEY'] = "3MVG9GiqKapCZBwGKWN18VcBTA1KmaZj2YV7uCR9OHjJefgNd6buWczB6y1MxYKYAr_isA1D8hizunIxddixO"
  ENV['SALESFORCE_SANDBOX_SECRET'] = "6626264033670450966"
  ENV['SALESFORCE_PRERELEASE_KEY'] = ""
  ENV['SALESFORCE_PRERELEASE_SECRET'] = ""
  ENV['DATABASE_DOT_COM_KEY'] = ""
  ENV['DATABASE_DOT_COM_SECRET'] = ""
  ENV['SALESFORCE_CUSTOM_KEY'] = "3MVG9GiqKapCZBwGKWN18VcBTA0zJQA8mXhFhZzBuJFdcK4FqhW0n1V8b71_YyPlGABPVBjmLDnh6xO8ungwM"
  ENV['SALESFORCE_CUSTOM_SECRET'] = "8360737005257889046"

  ENV['DEFAULT_CUSTOM_URL'] = "https://medctr--npidev.cs11.my.salesforce.com"
  ENV['DEFAULT_SANDBOX_URL'] = "https://test.salesforce.com"
  ENV['SURVEY_BUILDER_URL'] = "https://ucsf-builder-dev.heroku.com/index"  
  ENV['IDP_UCSF_LOGOUT'] = ' https://idp-stage.ucsf.edu/idp/shib_logout.jsp?url=https://npi-dev.heroku.com'
 
=begin
  #NPI-QA
  ENV['SALESFORCE_KEY'] = ""
  ENV['SALESFORCE_SECRET'] = ""
  ENV['SALESFORCE_SANDBOX_KEY'] = "3MVG9GiqKapCZBwHxOJHdUt59hnj4Vwa8tt1yuKT.sTZM2jcpMQ7iqhJR.PX3n9uHHhyIA1gQaQOsyltuCMq8"
  ENV['SALESFORCE_SANDBOX_SECRET'] = "3121908814678959968"
  ENV['SALESFORCE_PRERELEASE_KEY'] = ""
  ENV['SALESFORCE_PRERELEASE_SECRET'] = ""
  ENV['DATABASE_DOT_COM_KEY'] = ""
  ENV['DATABASE_DOT_COM_SECRET'] = ""
  ENV['SALESFORCE_CUSTOM_KEY'] = "3MVG9GiqKapCZBwHxOJHdUt59hvmAWrHeW0.k8nxwdOOzxEtMPKLExVkHnQBiSgIfW2t8u1R26mIMONEPPHSN"
  ENV['SALESFORCE_CUSTOM_SECRET'] = "479086689104364566"

  ENV['DEFAULT_CUSTOM_URL'] = "https://medctr--npiqa.cs11.my.salesforce.com"
  ENV['DEFAULT_SANDBOX_URL'] = "https://test.salesforce.com"
  ENV['SURVEY_BUILDER_URL'] = "https://ucsf-builder-qa.heroku.com/index"  
  ENV['IDP_UCSF_LOGOUT'] = ' https://idp-stage.ucsf.edu/idp/shib_logout.jsp?url=https://npi-qa.heroku.com'
=end
  
  ENV['DEFAULT_PROVIDER'] = "customurl"
  ENV['sfdc_api_version'] = '23.0'
  ENV['app_timeout'] = '3600' #(15 mins) time in seconds

  ENV['MY_RUBY_HOME'] = ''
  
  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = false

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
