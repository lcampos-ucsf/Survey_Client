class ApplicationController < ActionController::Base

  	protect_from_forgery
  	include SessionsHelper
  	#this fixes issues with kaminari pagination paginating inside an apotomo widget
 	Apotomo::Widget.append_view_path "app/views/"
	
end
