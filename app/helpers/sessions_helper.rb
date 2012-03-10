module SessionsHelper

require 'omniauth-oauth2'
  
  def signed_in?
    !session[:auth_hash].nil?
  end

  def sign_out(sm = 0)
      puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb sign_out ^^^^^^^^^^^^^^^^^^^^"
      instURL = ''
      if signed_in?
        puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb sign_out , signedin ^^^^^^^^^^^^^^^^^^^^"
        instURL = session[:auth_hash][:instance_url]
      else
        puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb sign_out , NOT signedin ^^^^^^^^^^^^^^^^^^^^"
        instURL = session[:orgurl]
      end
      
      redirect_to signoutsf_path(:orgurl => instURL,:sm => sm)
  end

  def signout_exp
    puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb signout_exp ^^^^^^^^^^^^^^^^^^^^"
    sign_out(1)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def authenticate
    puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb authenticate, signed_in ? = '#{signed_in?}' ^^^^^^^^^^^^^^^^^^^^"

    #check ip
    puts "//////////////////// session_helper.rb, check ip. session[:user_ip] = '#{session[:user_ip]}', request ip = '#{request.remote_ip}' "
    if session[:user_ip] != request.remote_ip
      deny_access
      return false
    end

    #check session
    if signed_in?
      ve_to = ENV['app_timeout'].to_i / 60
      expire_time = ve_to.minutes.from_now
      if session[:expires_at].blank?
        session[:expires_at] = expire_time
        puts "if session[:expires_at].blank? = '#{session[:expires_at]}' "
      else
        @time_left = (session[:expires_at].utc - Time.now.utc).to_i
        puts "else, timeleft = '#{@time_left}' " 
        unless @time_left > 0
          puts "^^^^^^^^^^^^^^^^^^^^ session_helper.rb authenticate unless ^^^^^^^^^^^^^^^^^^^^"
          #session[:expires_at] = expire_time
          @orgurl = session[:auth_hash][:instance_url]
          reset_session
          store_location
          session[:orgurl] = @orgurl 
          signout_exp
          return
        end
        #renew session timeout
        puts "-----------renew session timeout, session = '#{session[:expires_at]}' "
        puts "-----------renew session timeout, now = '#{expire_time}' "
        puts "-----------renew session timeout, now = '#{expire_time}' "
        puts "-----------renew session timeout, now = '#{expire_time}' "
        session[:expires_at] = expire_time
      end
    else
      deny_access
    end
  end

  def admin_only
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& admin_only &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& admin_only &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& admin_only &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
    if session[:user_profile] != 'Admin'
      raise Exceptions::InsufficientPriviledges.new('Insufficient Privileges to access this section.')
    end
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
    redirect_to "/client/auth/#{provider}?#{auth_params}"
  end

  def deny_access
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