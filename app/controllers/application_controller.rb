require "exceptions"

class ApplicationController < ActionController::Base

  	protect_from_forgery :secret => "pu70ny0urr3d5h035anddanc37h3blu35"
  	include SessionsHelper
  	#this fixes issues with kaminari pagination paginating inside an apotomo widget
 	Apotomo::Widget.append_view_path "app/views/"
	

end
