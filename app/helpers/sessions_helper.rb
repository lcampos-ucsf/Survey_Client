module SessionsHelper

class T
  include HTTParty
  format :json
end

require 'omniauth-oauth2'
  
  def signed_in?
    !session[:auth_hash].nil?
  end

  def sign_out(sm = 0)
      instURL = ''
      if signed_in?
        instURL = session[:auth_hash][:instance_url]
      end
      
      redirect_to signoutsf_path(:orgurl => instURL,:sm => sm)
  end

  def signout_exp
    sign_out(1)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def authenticate
    deny_access unless signed_in?
  end

  def authenticateSF
    puts "authenticateSF url params = '#{request.fullpath}' "
    #set default values
    auth_params = nil
    provider = ENV['DEFAULT_PROVIDER']

    auth_params = {
      :display => 'touch',
      :immediate => 'false',
      :scope => 'full'
    }    

    if provider == 'customurl'
      auth_params[:customurl] = ENV['DEFAULT_CUSTOM_URL']
    end

    #look for defined options
    if !params[:options].blank?
      provider = sanitize_provider(params[:options]['provider'])
      auth_params = {
        :display => params[:options]['display'],
        :immediate => params[:options]['immediate'],
        :scope => params[:options].to_a.flatten.keep_if{|v| v.start_with? "scope|"}.collect!{|v| v.sub(/scope\|/,"")}.join(" ") 
      }

      if params[:options]['provider'] == 'customurl'
        auth_params[:customurl] = params[:options]['curl']
      end

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
    pl2 = 'grant_type=refresh_token&refresh_token=5Aep861ZcIr522KYf5zSCffhRGjmdmjiNSask1IfvF9Fdv9ZcutMl0hU70TPgTObXuUNBq4QK_0JQ%3D%3D&client_id=3MVG9GiqKapCZBwGKWN18VcBTA1KmaZj2YV7ufz52FM8PLm6XWITmy2BseIvf3ROwvzZzKVVYFzAy.glsMTAj&client_secret=2582046431606031750'
    result = T.post('https://cs11.salesforce.com/services/oauth2/token',:body => pl2)
    puts "---------- payload = '#{payload}' "
    puts "---------- pl2 = '#{pl2}' "
    puts "---------- pl2 decode = '#{URI.unescape(pl2)}' "
    puts "---------- result = '#{result}' "
    puts ">>>>>> session[:client].oauth_token = '#{session[:client].oauth_token}' "
    instUrl = session[:auth_hash][:instance_url]
    puts ">>>>>> result['access_token'] = '#{result['access_token']}' "
    session[:client].oauth_token = result['access_token']
    puts ">>>>>> session[:client].oauth_token = '#{session[:client].oauth_token}' "
    session[:client].authenticate :token => result['access_token'], :instance_url => instUrl, :refresh_token => session[:auth_hash][:refresh_token]

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