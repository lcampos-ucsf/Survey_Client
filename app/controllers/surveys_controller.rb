class SurveysController < ApplicationController
	
  before_filter :authenticate

  include SurveysHelper

  helper_method :current_survey
  has_widgets do |root|
    @s = current_survey
    puts " building widget survey, @s = '#{@s}' "
    root << widget("survey/survey", :survey, :survey => @s)
  end
  
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def review
    @s = current_survey
    @surveyid = @s[0].Survey__c
    #response = session[:client].materialize("Response__c") 
    #@responses = response.query("Survey__c = '#{@surveyid}' and Invitation__c = '#{params[:id]}' order by Line_Sort_Order__c, Line_Item_Sort_Order__c ")
    @responses = session[:client].query("select Id, Name, Date_Response__c, DateTime_Response__c, Integer_Response__c, Invitation__c, Label_Long_Response__c, Label_Response__c, Line_Item__c, Line_Item_Sort_Order__c, Line_Name__c, Line_Sort_Order__c, Original_Question_Text__c, Response_Type__c, Survey__c, Surveyee__c, Text_Long_Response__c, Text_Response__c from Response__c where Survey__c = '#{@surveyid}' and Invitation__c = '#{params[:id]}' order by Line_Sort_Order__c, Line_Item_Sort_Order__c " )
    puts "------------------ review, @responses = '#{@responses}' " 
  end
  


end
