class SurveysController < ApplicationController
	
  before_filter :authenticate

  include SurveysHelper

  helper_method :current_survey
  has_widgets do |root|
    root << widget("survey/survey", :survey, :survey => current_survey)
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
    @surveyid = current_survey[0].Survey__c
    response = session[:client].materialize("Response__c") 
    @responses = response.query("Survey__c = '#{@surveyid}' and Invitation__c = '#{params[:id]}' order by Line_Sort_Order__c, Line_Item_Sort_Order__c ")
  end
  


end
