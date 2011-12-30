class InviteController < ApplicationController
	
	before_filter :authenticate

	has_widgets do |root|
		root << widget(:invites)
	end
	
  def index
  end

  def new
  	#materialization
	invite = session[:client].materialize("Invitation__c") 

  	@invite = invite.new
  end

  def create
  	#materialization
	invite = session[:client].materialize("Invitation__c") 
	arec = invite.new(params[:invitation__c])
	arec.Completed__c = false
	arec.Invite_Sent__c = false
	arec.Is_Preview__c = false
	#arec = invite.new(:OwnerId => '005A0000001e1G6', :Completed__c => false, :Invite_Sent__c => false, :Is_Preview__c => false)
			
  	puts "--------------------------- invite create params = '#{params}' , params[:invitation__c] = '#{params[:invitation__c]}' "
  	respond_to do |format|
      if arec.save
        format.html { render :action => "index" }
        format.xml  { head :ok }
      else
        format.html  { render :action => "new" }
        format.xml  { render :xml => @partner.errors, :status => :unprocessable_entity }
      end
    end

  end

end
