class ApplicationController < ActionController::Base

  	protect_from_forgery
  
  	include SessionsHelper

  	
	Apotomo::Widget.append_view_path "app/views/"
	
end
