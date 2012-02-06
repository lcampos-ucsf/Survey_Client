class InvitesWidget < Apotomo::Widget

  def display
  	@invites_query = session[:client].query("select Id, Name, User__c, Status__c, Start_Date__c, End_Date__c, Survey_Name__c, Survey__c, Progress_Save__c, Survey_Subject__c, Survey_Subject__r.Name, LastModifiedDate, Invitation_Subject__c, Is_Preview__c from Invitation__c where User__c = '#{session[:user_id]}' and (Status__c = 'New' or Status__c = 'In Progress') and Is_Preview__c = false order by Survey_Name__c, Status__c, LastModifiedDate desc ")
  	#@invites = session[:client].query("select Id, Name, User__c, Status__c, Start_Date__c, End_Date__c, Survey_Name__c, Survey__c, Progress_Save__c, Survey_Subject__c, Survey_Subject__r.Name, LastModifiedDate, Invitation_Subject__c, Is_Preview__c from Invitation__c where User__c = '#{session[:user_id]}' and (Status__c = 'New' or Status__c = 'In Progress') and Is_Preview__c = false order by Survey_Name__c, Status__c, LastModifiedDate desc ")
   
    #security enhancement
	@pageno = (params[:page]!= nil) ? ( params[:page].match(/^[1-9]*$/) == nil ? '1' : Sanitize.clean(params[:page]).to_i ) : '1'
    @invites = Kaminari.paginate_array(@invites_query).page(@pageno).per(10) # Paginates the array
    render
  end
end
