class InviteController < ApplicationController
	include Databasedotcom::Rails::Controller

	has_widgets do |root|
		root << widget(:invites)
	end
	
  def index
  end

end
