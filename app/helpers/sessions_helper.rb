module SessionsHelper

class T
  include HTTParty
  format :json
end

require 'omniauth-oauth2'
  
  def signed_in?
      !session[:auth_hash].nil?
  end

  def sign_out
      session[:auth_hash] = nil
      session[:expires_at] = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def authenticate
    #deny_access unless signed_in?
    puts "authenticate, '#{signed_in?}' "
    puts "authenticate, '#{signed_in?}' "
    puts "authenticate, '#{signed_in?}' "
    puts "authenticate session[:auth_hash][:refresh_token] , '#{session[:auth_hash][:refresh_token]}' "
    puts "authenticate session[:client].oauth_token , '#{ session[:client].oauth_token }' "

    refreshToken

    if signed_in?
      puts "time-now = '#{Time.now}'"
      timevar = ENV['app_timeout'].to_i
      expire_time = timevar.minutes.from_now
      puts "expire_time = '#{expire_time}'"
      if session[:expires_at].blank?
        session[:expires_at] = expire_time
        puts "if session[:expires_at].blank? = '#{session[:expires_at]}' "
      else
        @time_left = (session[:expires_at].utc - Time.now.utc).to_i
        puts "else, timeleft = '#{@time_left}' " 
        unless @time_left > 0
          reset_session
          store_location
          redirect_to root_path, :notice => "Your session has expired. Please login."
        end
      end
    else
      puts 'else, deny_access'
      deny_access
    end
  end

  def authenticateSF
    puts "authenticateSF url params = '#{request.fullpath}' "
    #set default values
    auth_params = nil
    provider = 'salesforcesandbox'

    auth_params = {
      :display => 'touch',
      :immediate => 'false',
      :scope => 'full',
      :customurl => ENV['SF_CUSTOM_DOMAIN'] #'https://medctr--npidev.cs11.my.salesforce.com/'
    }    

    #look for defined options
    if !params[:options].blank?
      provider = sanitize_provider(params[:options]['provider'])
      auth_params = {
        :display => params[:options]['display'],
        :immediate => params[:options]['immediate'],
        :scope => params[:options].to_a.flatten.keep_if{|v| v.start_with? "scope|"}.collect!{|v| v.sub(/scope\|/,"")}.join(" "),
        :customurl => params[:options]['provider']=='customurl' ? params[:options]['curl'] : nil
      }
    end



    auth_params = URI.escape(auth_params.collect{|k,v| "#{k}=#{v}"}.join('&'))
    
    puts "authenticateSF , auth_params  = '#{auth_params}' "

    redirect_to "/auth/#{provider}?#{auth_params}"
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def refreshToken
    puts '>>> AUTH TOKEN EXPIRED ... USING REFRESH TOKEN >>> '
    payload = 'grant_type=refresh_token' + '&client_id=' + ENV['SALESFORCE_SANDBOX_KEY']+ '&client_secret=' + ENV['SALESFORCE_SANDBOX_SECRET'] + '&refresh_token=' + session[:auth_hash][:refresh_token]
    result = T.post('https://cs11.salesforce.com/services/oauth2/token',:body => payload)
    puts "---------- result = '#{result}' "
    puts ">>>>>> session[:client].oauth_token = '#{session[:client].oauth_token}' "
    
    #client = Databasedotcom::Client.new :host => 'https://cs11.salesforce.com'
    #client.version = "23.0"
    
    #client.client_id = ENV['SALESFORCE_SANDBOX_KEY']
    #client.client_secret = ENV['SALESFORCE_SANDBOX_SECRET']
    instUrl = session[:auth_hash][:instance_url]
    puts ">>>>>> result['access_token'] = '#{result['access_token']}' "
    #session[:auth_hash][:refresh_token] = result['access_token']
    session[:client].oauth_token = result['access_token']
    puts ">>>>>> session[:client].oauth_token = '#{session[:client].oauth_token}' "
    session[:client].authenticate :token => result['access_token'], :instance_url => instUrl, :refresh_token => session[:auth_hash][:refresh_token]
   
    
    #serviceauth.save
  end
                   
  private
  
      def store_location
        session[:return_to] = request.fullpath
      end

      def clear_return_to
        session[:return_to] = nil
      end

      def sanitize_provider(provider = nil)
        provider.strip! unless provider == nil
        provider.downcase! unless provider == nil
        provider = "salesforce" unless %w(salesforcesandbox salesforceprerelease databasedotcom customurl).include? provider
        provider
      end

end