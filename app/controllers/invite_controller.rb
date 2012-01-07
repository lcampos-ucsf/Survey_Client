class InviteController < ApplicationController
	
	before_filter :authenticate

	has_widgets do |root|
		root << widget(:invites)
	end
	
  def index
  end

  def new
    @surveyees = session[:client].query("select Id, Name from Surveyee__c order by Name asc") #surveyee.all 
    @surveys = session[:client].query("select Id, Name from Survey__c order by Name asc") #survey.all
    @users = session[:client].query("select Id, Name from User order by Name asc") #user.all
    puts "------- Users = '#{@users}' "
  	@invite = 'invitation__c'
  end

  def create
    puts "--------------------------- invite create params = '#{params}' , params[:invitation__c] = '#{params[:invitation__c]}', surveyees = '#{params[:invitation__c][:Surveyee__c]}' "
    if params[:invitation__c][:Surveyee__c]
      params[:invitation__c][:Surveyee__c].each do |s|
        session[:client].create('Invitation__c',{
            'Survey__c' => params[:invitation__c][:Survey__c], 
            'User__c' => params[:invitation__c][:User__c],
            'Status__c' => params[:invitation__c][:Status__c],
            'Surveyee__c' => s, 
            'Start_Date__c' => Date.strptime(params[:invitation__c][:Start_Date__c], "%m/%d/%Y").to_datetime(), 
            'End_Date__c' => Date.strptime(params[:invitation__c][:End_Date__c], "%m/%d/%Y").to_datetime(), 
            'OwnerId' => session[:user_id], 
            'Is_Preview__c' => false, 
            'Invite_Sent__c' => false, 
            'Completed__c' => false })

      end

    else
      session[:client].create('Invitation__c',{
            'Survey__c' => params[:invitation__c][:Survey__c], 
            'User__c' => params[:invitation__c][:User__c],
            'Status__c' => params[:invitation__c][:Status__c],
            'Start_Date__c' => Date.strptime(params[:invitation__c][:Start_Date__c], "%m/%d/%Y").to_datetime(), 
            'End_Date__c' => Date.strptime(params[:invitation__c][:End_Date__c], "%m/%d/%Y").to_datetime(), 
            'OwnerId' => session[:user_id], 
            'Is_Preview__c' => false, 
            'Invite_Sent__c' => false, 
            'Completed__c' => false })

  	end
  	redirect_to invite_index_path
  end

  def edit
    @users = session[:client].query("select Id, Name from User order by Name asc") 
    @invite = session[:client].query("select Id, Name, Survey__c, Survey_Name__c, User__c, User__r.Name, Status__c, Start_Date__c, End_Date__c, OwnerId from Invitation__c where Id = '#{params[:id]}' ")  
  end

  def update
    session[:client].upsert('Invitation__c','Id', params[:Id], { 'User__c' => params[:invitation__c][:User__c], 'OwnerId' => params[:invitation__c][:User__c] })
    redirect_to invite_index_path
  end

end
