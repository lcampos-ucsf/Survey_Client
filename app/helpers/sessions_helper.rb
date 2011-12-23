module SessionsHelper
  
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
    puts "authenticate session[:return_to] , '#{session[:return_to]}' "

    if signed_in?
      puts "from now = '#{Time.now}'"
      expire_time = 2.minutes.from_now
      puts "from now = '#{expire_time}'"
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
      :scope => 'full'
      #:customurl => ENV['DEFAULT_CUSTOM_URL']
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
    redirect_to "/auth/#{provider}?#{auth_params}"
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
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