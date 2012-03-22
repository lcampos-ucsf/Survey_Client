module SessionsHelper

require 'omniauth-oauth2'
  
  def signed_in?
    !session[:auth_hash].nil?
  end

  def sign_out(sm = 0)
      puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb sign_out , refresh_token = #{session[:auth_hash][:token]}^^^^^^^^^^^^^^^^^^^^"
      instURL = ''
      if signed_in?
        instURL = session[:auth_hash][:instance_url]
      else
        instURL = session[:orgurl]
      end
      
      redirect_to signoutsf_path(:orgurl => instURL,:sm => sm)
  end

  def signout_exp
    puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb signout_exp ^^^^^^^^^^^^^^^^^^^^"
    #clear_session
    sign_out(1)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def authenticate
    puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb authenticate, signed_in ? = '#{signed_in?}' ^^^^^^^^^^^^^^^^^^^^"

    #check session
    if signed_in?
      ve_to = ENV['app_timeout'].to_i / 60
      expire_time = ve_to.minutes.from_now
      if session[:expires_at].blank?
        session[:expires_at] = expire_time
        puts "if session[:expires_at].blank? = '#{session[:expires_at]}' "
      else
        @time_left = (session[:expires_at].utc - Time.now.utc).to_i
        unless @time_left > 0
          puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb authenticate unless ^^^^^^^^^^^^^^^^^^^^"
          @orgurl = session[:auth_hash][:instance_url] ? session[:auth_hash][:instance_url] : @orgurl
          #reset_session
          clear_session
          store_location
          session[:orgurl] = @orgurl 
          signout_exp
          return
        end
        #renew session timeout
        session[:expires_at] = expire_time
        puts "-------- session_helper.rb authenticate, session time left = #{session[:expires_at].utc - Time.now.utc}"
        
      end
    else 
      if session[:orgurl]
        signout_exp
      else
        deny_access
      end

    end
  end

  def admin_only
    puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb, admin_only ^^^^^^^^^^^^^^^^^^^^"
    if session[:user_profile] != 'Admin'
      raise Exceptions::InsufficientPriviledges.new('Insufficient Privileges to access this section.')
    end
  end

  def clear_session
    puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb, clear_session ^^^^^^^^^^^^^^^^^^^^"
    session[:client] = nil
    session[:user_profile] = nil
    session[:user_id] = nil
    session[:name] = nil
    #session[:auth_hash][:token] = nil
    #session[:auth_hash][:refresh_token] = nil
  end

  def authenticateSF
    puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb authenticateSF, url params = '#{request.fullpath}' ^^^^^^^^^^^^^^^^^^^^"

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
    elsif provider == 'salesforcesandbox'
      auth_params[:customurl] = ENV['DEFAULT_SANDBOX_URL']
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

    #redirect_to "/auth/#{provider}?#{auth_params}"
    redirect_to "#{ ENV['URL_Prefix'] }/auth/#{provider}?#{auth_params}"
  end

  def deny_access
    puts "----------------- session_helper.rb deny_access -------------------- "
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
                    
  private
  
      def store_location
        puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb store_location ^^^^^^^^^^^^^^^^^^^^"
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