
class SurveysController < ApplicationController
	include Databasedotcom::Rails::Controller

  include SurveysHelper
  helper_method :current_invitation

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
    #@invite = Invitation__c.find(params[:id])
    @survey = Survey__c.find(params[:sid])

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

    @responses = Response__c.query("Survey__c = '#{params[:sid]}' order by Line_Sort_Order__c, Line_Item_Sort_Order__c ")
  end

  private 

  def current_invitation
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% current_invitation, invitation id = '#{params[:id]}' "
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "
    puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% "
    @current_invitation ||= Invitation__c.query("Survey__c = '#{params[:sid]}' and User__c = '#{ENV['sf_user']}'  limit 1")
    
    #session[:current_invitation]

  end

end
