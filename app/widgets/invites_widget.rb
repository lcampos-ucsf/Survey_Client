class InvitesWidget < Apotomo::Widget
#include Databasedotcom::Rails::Controller

  def display
  	invite = session[:client].materialize("Invitation__c") 
  	puts " invite = '#{invite}' "
  	@invites = invite.query("User__c = '#{ENV['sf_user']}' and Status__c = 'In Progress' order by LastModifiedDate desc ")
    #puts " invite = '#{invite}', @invites = '#{@iq[0]}' "
    #@invites = @iq[0]
    #@invites = invite.all
    render
  end
end
