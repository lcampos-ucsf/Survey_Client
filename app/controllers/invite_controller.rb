class InviteController < ApplicationController
	
	before_filter :authenticate

	has_widgets do |root|
		root << widget(:invites)
	end
	
  def index
  end

  def new
    @surveyees = session[:client].query("select Id, Name from Surveyee__c") #surveyee.all 
    @surveys = session[:client].query("select Id, Name from Survey__c") #survey.all
    @users = session[:client].query("select Id, Name from User") #user.all
    puts "------- Users = '#{@users}' "
  	@invite = 'invitation__c'
  end

  def create
    puts "--------------------------- invite create params = '#{params}' , params[:invitation__c] = '#{params[:invitation__c]}', surveyees = '#{params[:invitation__c][:Surveyee__c]}' "
    if params[:invitation__c][:Surveyee__c].size() > 0
      
      params[:invitation__c][:Surveyee__c].each do |s|

        session[:client].create('Invitation__c',{
            'Survey__c' => params[:invitation__c][:Survey__c], 
            'User__c' => params[:invitation__c][:User__c],
            'Status__c' => params[:invitation__c][:Status__c],
            'Surveyee__c' => s, 
            'Start_Date__c' => Time.parse(params[:invitation__c][:Start_Date__c]).getutc , 
            'End_Date__c' => Time.parse(params[:invitation__c][:End_Date__c]).getutc, 
            'OwnerId' => ENV['sf_user'], 
            'Is_Preview__c' => false, 
            'Invite_Sent__c' => false, 
            'Completed__c' => false })

      end
      render :action => "index"

  	end
  	
  end

end
