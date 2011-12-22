require "omniauth"
require "omniauth-salesforce"

Rails.application.config.middleware.use OmniAuth::Builder do

    provider :salesforce,
             ENV['SALESFORCE_KEY'],
             ENV['SALESFORCE_SECRET']
    provider OmniAuth::Strategies::SalesforceSandbox,
             ENV['SALESFORCE_SANDBOX_KEY'],
             ENV['SALESFORCE_SANDBOX_SECRET']
    provider OmniAuth::Strategies::SalesforcePreRelease,
             ENV['SALESFORCE_PRERELEASE_KEY'],
             ENV['SALESFORCE_PRERELEASE_SECRET']
    provider OmniAuth::Strategies::DatabaseDotCom,
             ENV['DATABASE_DOT_COM_KEY'],
             ENV['DATABASE_DOT_COM_SECRET']
    provider OmniAuth::Strategies::CustomUrl,
             ENV['SALESFORCE_CUSTOM_KEY'],
             ENV['SALESFORCE_CUSTOM_SECRET']
end