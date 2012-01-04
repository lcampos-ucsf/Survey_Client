class InvitesWidget < Apotomo::Widget

  def display
  	@invites = session[:client].query("select Id, Name, User__c, Status__c, Start_Date__c, End_Date__c, Survey_Name__c, Progress_Save__c from Invitation__c where User__c = '#{ENV['sf_user']}' and (Status__c = 'New' or Status__c = 'In Progress') order by LastModifiedDate desc ")

    render
  end
end
