
class SurveysController < ApplicationController
	include Databasedotcom::Rails::Controller

  include SurveysHelper

  helper_method :current_survey, :conditionalbranch

  has_widgets do |root|
    root << widget("survey/survey", :survey)
    root << widget("survey/surveylist", :surveylist)
  end


  def index
  end

  def new
  end

  def create
  end

  def show
    #@survey = Survey__c.find(params[:sid])
    
    @survey = current_survey

    puts " $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ show, current_survey = '#{@survey}' "
    puts " $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ show"
    puts " $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ show"
    puts " $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ show"
    puts " $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ show"

  end

  def review
=begin
    @ids = [] 
    @ids[0] = 'a0DU0000000dRih'
    @ids[1] = 'a0DU0000000dRic'

    @ids = @ids.to_s.gsub('[','(')
    @ids = @ids.gsub(']',')')
    puts "@ids = '#{@ids.to_s.gsub('[','(')}'"

    @ids = "(\'a0DU0000000dRih\', \'a0DU0000000dRic\')"
    @responses = Response__c.query("Survey__c = '#{params[:id]}' and Id in #{@ids} order by Line_Sort_Order__c, Line_Item_Sort_Order__c ")
 
=end

    @responses = Response__c.query("Survey__c = '#{params[:sid]}' and Invitation__c = '#{params[:id]}' order by Line_Sort_Order__c, Line_Item_Sort_Order__c ")
  end
  


end
