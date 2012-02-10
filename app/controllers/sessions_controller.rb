require 'httparty'

class SessionsController < ApplicationController
  include HTTParty
  
  def new
    @title = "Sign in"
  end

  def login
    redirect_to root_path
  end

  def signout_revoke
    @title = 'Sign Out'

        @sfloguturl = nil
        @idplogouturl = nil

        puts "---------------signout_revoke---------------------"
        if params[:orgurl] != nil
            puts "signout_revoke --------------- orgurl = '#{params[:orgurl]}' "

            #Set ifram url for salesforce logout
            @sfloguturl = "#{params[:orgurl]}/secur/logout.jsp"

            if ENV['DEFAULT_PROVIDER'] == "customurl"
              @idplogouturl = ENV['IDP_UCSF_LOGOUT']
            end
            puts "signout_revoke 1 --------------- signed_in? = '#{signed_in?}' "
            #Revoke refresh token
            if signed_in?
              puts "signout_revoke 2 --------------- signed_in? = '#{signed_in?}' "
                result = HTTParty.post("#{params[:orgurl]}/services/oauth2/revoke",:body => "token= #{session[:auth_hash][:refresh_token]}")
                puts "Revoke post response = "+result.inspect
            end
        end

        puts "signout_revoke --------------- params[:sm] = '#{params[:sm]}' "
        if params[:sm] == '1'
            store_location
        end
    session[:client] = nil
    reset_session
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def create
    puts "^^^^^^^^^^^^^^^^^^^^ session_controller.rb create, , session[:return_to] = '#{session[:return_to]}' ^^^^^^^^^^^^^^^^^^^^"
    #puts 'Full Auth Hash >>>>>'
    #puts env['omniauth.auth']
    
    #add reset_session here and copy any signup path
    @starturl = session[:return_to]
    reset_session

    session[:return_to] = @starturl

    #puts 'User Login >>>>'
    session[:auth_hash] = env['omniauth.auth']['credentials']
    #puts 'tokens: '+env['omniauth.auth']['credentials'].to_s
    session[:user_id] = env['omniauth.auth']['extra']['user_id']
    #puts 'user id: '+env['omniauth.auth']['extra']['user_id'].to_s
    session[:org_id] = env['omniauth.auth']['extra']['organization_id']
    #puts 'org id: '+env['omniauth.auth']['extra']['organization_id'].to_s
    session[:image] = env['omniauth.auth']['info']['image']
    #puts 'image : '+env['omniauth.auth']['info']['image'].to_s
    session[:name] = env['omniauth.auth']['info']['name']
    #puts 'name : '+env['omniauth.auth']['info']['name'].to_s

    #add user ip
    session[:user_ip] = request.remote_ip

    puts "///////////////////// user ip is = '#{session[:user_ip]}' " 
    puts "///////////////////// user ip is = '#{session[:user_ip]}' " 
    puts "///////////////////// user ip is = '#{session[:user_ip]}' " 

    #obtain name of the service
    params[:provider] ? service_route = params[:provider] : service_route = 'No service recognized (invalid callback)'

    # get the full hash from omniauth
    omniauth = env['omniauth.auth']


    # continue only if hash and parameter exist
    if omniauth and params[:provider]
      client = Databasedotcom::Client.new :host => session[:auth_hash][:instance_url]
      client.version = "23.0"

      instUrl = session[:auth_hash][:instance_url]
      client.instance_url = instUrl

      case params[:provider] 
        when 'salesforce'
          client.client_id = ENV['SALESFORCE_KEY']
          client.client_secret = ENV['SALESFORCE_SECRET']
        when 'salesforcesandbox'
          client.client_id = ENV['SALESFORCE_SANDBOX_KEY']
          client.client_secret = ENV['SALESFORCE_SANDBOX_SECRET']
        when 'salesforceprerelease'
          client.client_id = ENV['SALESFORCE_PRERELEASE_KEY']
          client.client_secret = ENV['SALESFORCE_PRERELEASE_SECRET']
        when 'databasedotcom'
          client.client_id = ENV['DATABASE_DOT_COM_KEY']
          client.client_secret = ENV['DATABASE_DOT_COM_SECRET']
        when 'customurl'
          client.client_id = ENV['SALESFORCE_CUSTOM_KEY']
          client.client_secret = ENV['SALESFORCE_CUSTOM_SECRET']
      end

      #puts '<<<<<<<<<<<<<<<<<<<<<<< INSTANCE URL >>>>>>>>>>>>>>>>>>>>>'
      #puts instUrl
      
      client.authenticate :token => session[:auth_hash][:token], :instance_url => instUrl, :refresh_token => session[:auth_hash][:refresh_token]
      session[:client]= client
      flash[:success] = "Welcome #{env['omniauth.auth']['info']['name']}!"

      u_data = session[:client].query("select Id, Survey_Role__c from User where Id = '#{session[:user_id]}' ")
   
      if u_data[0].Survey_Role__c != nil
        session[:user_profile] = u_data[0].Survey_Role__c
      else
        session[:user_profile] = ''
      end

      redirect_back_or(invite_path)
    else
      flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '. The service did not return valid data.'
      redirect_to signup_path
    end

    return

  end

  def fail
    flash[:error] = "Oops, there was an error in the authentaction process."
    redirect_to root_path
  end
  
  def destroy
    sign_out
  end

end