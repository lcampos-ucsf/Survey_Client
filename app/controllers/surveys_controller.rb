
class SurveysController < ApplicationController
	include Databasedotcom::Rails::Controller

  include SurveysHelper

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
    @survey = Survey__c.find(params[:id])
  end

end
