class PagesController < ApplicationController
  def home
      @title = 'Home'
      if params.key?(:sm) && !params[:sm].blank?
        
      case params[:sm] 
            when '0'
            flash[:success] = "You've successfully signed out!"
            when '1'
            flash[:notice] = "Your session has expired. Please login."
          end

      end
  end

  def contact
    @title = 'Contact'
  end
  
  def about
    @title = 'About'
  end

  def help
    @title = 'Help'
  end

end
