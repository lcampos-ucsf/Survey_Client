class InviteController < ApplicationController
	
	before_filter :authenticate
  before_filter :admin_only, :only => [:new,:create,:edit,:update,:all]
  before_filter :setinviteformvalues, :only => [:new]

  rescue_from Exceptions::InsufficientPriviledges, :with => :custom_error

  

	has_widgets do |root|
		root << widget(:invites)
	end
	
  def index
  end

  def new
  	@invite = 'invitation__c'
  end

  def create
    puts "--------------------------- invite create params = '#{params}' , params[:invitation__c] = '#{params[:invitation__c]}', survey subject = '#{params[:invitation__c][:Survey_Subject__c]}' "
    
   
    @iter = (params[:invitation__c][:Bulk__c].blank? ) ? '1' : ( params[:invitation__c][:Bulk__c].match(/^[0-9]*$/) == nil ? '1' : Sanitize.clean(params[:invitation__c][:Bulk__c]).to_i )  
    puts "-------------- @iter = '#{@iter}' "
    i = 0
    while i < @iter.to_i

      if params[:invitation__c][:Survey_Subject__c] 
        params[:invitation__c][:Survey_Subject__c].each do |s|
          puts "&&&&&&&&&&&&&&&&&&&&&&&& invitation if, s = '#{s}' " 
          createinvite(params[:invitation__c],s)
        end

      else
        createinvite(params[:invitation__c],'')
    	end

      i += 1
    end  
  	redirect_to invite_index_path
  end

  def edit
    @users = session[:client].query("select Id, Name from User order by Name asc") 
    if session[:user_profile] == 'Admin'
       @subjects = session[:client].query("select Id, Name from Survey_Subject__c order by Name asc")
    end
    @invite = session[:client].query("select Id, Name, Survey__c, Survey_Name__c, User__c, User__r.Name, Status__c, Start_Date__c, End_Date__c, OwnerId, Text_Survey_Subject__c, Survey_Subject__c, Survey_Subject__r.Name from Invitation__c where Id = '#{Sanitize.clean(params[:id])}' ")  
  end

  def update
    if session[:user_profile] == 'Admin'
      
      session[:client].upsert('Invitation__c','Id', params[:Id], { 
        'User__c' => Sanitize.clean(params[:invitation__c][:User__c]), 
        'OwnerId' => Sanitize.clean(params[:invitation__c][:User__c]),
        'Status__c' => Sanitize.clean(params[:invitation__c][:Status__c]),
        'Survey_Subject__c' => params[:invitation__c][:Survey_Subject__c],
        'Start_Date__c' => Date.strptime(Sanitize.clean(params[:invitation__c][:Start_Date__c]), "%m/%d/%Y").to_datetime(), 
        'End_Date__c' => Date.strptime(Sanitize.clean(params[:invitation__c][:End_Date__c]), "%m/%d/%Y").to_datetime(),
        'Text_Survey_Subject__c' => Sanitize.clean(params[:invitation__c][:Text_Survey_Subject__c]) })
    else
      session[:client].upsert('Invitation__c','Id', params[:Id], { 'User__c' => Sanitize.clean(params[:invitation__c][:User__c]), 'OwnerId' => Sanitize.clean(params[:invitation__c][:User__c]) })
    end

    redirect_to invite_index_path
  end

  def all
    #@invites_new = session[:client].query("select Id, Name, User__c, User__r.Name, Status__c, Start_Date__c, End_Date__c, Survey_Name__c, Survey__c, Progress_Save__c, Survey_Subject__c, Survey_Subject__r.Name, LastModifiedDate, Invitation_Subject__c, Is_Preview__c from Invitation__c where Is_Preview__c = false and Status__c = 'New' order by Survey_Name__c, Status__c, LastModifiedDate desc  ")
    #@invites_inprogress = session[:client].query("select Id, Name, User__c, User__r.Name, Status__c, Start_Date__c, End_Date__c, Survey_Name__c, Survey__c, Progress_Save__c, Survey_Subject__c, Survey_Subject__r.Name, LastModifiedDate, Invitation_Subject__c, Is_Preview__c from Invitation__c where Is_Preview__c = false and Status__c = 'In Progress' order by Survey_Name__c, Status__c, LastModifiedDate desc  ")
    #@invites_complete = session[:client].query("select Id, Name, User__c, User__r.Name, Status__c, Start_Date__c, End_Date__c, Survey_Name__c, Survey__c, Progress_Save__c, Survey_Subject__c, Survey_Subject__r.Name, LastModifiedDate, Invitation_Subject__c, Is_Preview__c from Invitation__c where Is_Preview__c = false and Status__c = 'Completed' order by Survey_Name__c, Status__c, LastModifiedDate desc  ")
    
    @invites_query = session[:client].query("select Id, Name, User__c, User__r.Name, Status__c, Start_Date__c, End_Date__c, Survey_Name__c, Survey__c, Progress_Save__c, Survey_Subject__c, Survey_Subject__r.Name, LastModifiedDate, Invitation_Subject__c, Is_Preview__c from Invitation__c where Is_Preview__c = false and Status__c = 'New' order by Survey_Name__c, Status__c, LastModifiedDate desc  ")
  
    #security enhancement
    @pageno = (params[:page]!= nil) ? ( params[:page].match(/^[0-9]*$/) == nil ? 1 : Sanitize.clean(params[:page]).to_i ) : 1
    @invites_new = Kaminari.paginate_array(@invites_query).page(@pageno).per(10) # Paginates the array

  end

  def all_inprogress
    @invites_query = session[:client].query("select Id, Name, User__c, User__r.Name, Status__c, Start_Date__c, End_Date__c, Survey_Name__c, Survey__c, Progress_Save__c, Survey_Subject__c, Survey_Subject__r.Name, LastModifiedDate, Invitation_Subject__c, Is_Preview__c from Invitation__c where Is_Preview__c = false and Status__c = 'In Progress' order by Survey_Name__c, Status__c, LastModifiedDate desc  ")
  
    #security enhancement
    @pageno = (params[:page]!= nil) ? ( params[:page].match(/^[0-9]*$/) == nil ? 1 : Sanitize.clean(params[:page]).to_i ) : 1
    @invites_inprogress = Kaminari.paginate_array(@invites_query).page(@pageno).per(10) # Paginates the array

  end

  def all_complete
    @invites_query = session[:client].query("select Id, Name, User__c, User__r.Name, Status__c, Start_Date__c, End_Date__c, Survey_Name__c, Survey__c, Progress_Save__c, Survey_Subject__c, Survey_Subject__r.Name, LastModifiedDate, Invitation_Subject__c, Is_Preview__c from Invitation__c where Is_Preview__c = false and Status__c = 'Completed' order by Survey_Name__c, Status__c, LastModifiedDate desc  ")
    
    #security enhancement
    @pageno = (params[:page]!= nil) ? ( params[:page].match(/^[0-9]*$/) == nil ? 1 : Sanitize.clean(params[:page]).to_i ) : 1
    @invites_complete = Kaminari.paginate_array(@invites_query).page(@pageno).per(10) # Paginates the array

  end

  def stats
    
  end

  protected

  def custom_error(exception)
    puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ invite_controller.rb, custom_error exception = '#{exception}' "
    redirect_to "/invite/index", :alert => exception.message    
  end

  def setinviteformvalues
    @subjects = session[:client].query("select Id, Name from Survey_Subject__c order by Name asc")
    @surveys = session[:client].query("select Id, Name, Type__c from Survey__c where Type__c = 'Published' order by Name asc")
    @users = session[:client].query("select Id, Name from User order by Name asc")
  end

  def createinvite(rdata, s)
    puts "------createinvite method, rdata = '#{rdata}' ----------- "

    session[:client].create('Invitation__c',{
      'Survey__c' => Sanitize.clean(rdata[:Survey__c]), 
      'User__c' => Sanitize.clean(rdata[:User__c]),
      'Status__c' => 'New',
      'Survey_Subject__c' => s, 
      'Start_Date__c' => Date.strptime(Sanitize.clean(rdata[:Start_Date__c]), "%m/%d/%Y").to_datetime(), 
      'End_Date__c' => Date.strptime(Sanitize.clean(rdata[:End_Date__c]), "%m/%d/%Y").to_datetime(), 
      'OwnerId' => session[:user_id], 
      'Is_Preview__c' => false, 
      'Invite_Sent__c' => false, 
      'Completed__c' => false,
      'Text_Survey_Subject__c' => rdata[:Text_Survey_Subject__c] != '' ? Sanitize.clean(rdata[:Text_Survey_Subject__c]) : ''  })

    
    
  end

end
