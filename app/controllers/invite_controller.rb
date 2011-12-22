class InviteController < ApplicationController
	
	before_filter :authenticate

	has_widgets do |root|
		root << widget(:invites)
	end
	
  def index
  end

end
