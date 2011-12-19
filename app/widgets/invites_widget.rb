class InvitesWidget < Apotomo::Widget
include Databasedotcom::Rails::Controller

  def display
  	@invites = Invitation__c.query("User__c = '#{ENV['sf_user']}' and Status__c = 'In Progress' order by LastModifiedDate desc ")
    render
  end
end
