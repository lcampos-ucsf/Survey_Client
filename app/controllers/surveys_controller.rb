
class SurveysController < ApplicationController
	include Databasedotcom::Rails::Controller

  has_widgets do |root|
    root << widget("survey/survey", :survey)
  end


	#before_filter :load_survey, :only => [:show]

  def index
  	#@surveys = Survey__c.all
    @s_query = Survey__c.all
    @surveys = Kaminari.paginate_array(@s_query).page(params[:page]).per(1) # Paginates the array


    respond_to do |format|
      format.html # index.html.erb
    end
    
  end

  def new
  end

  def create
  end

  def show
  end

  private

  def load_survey
  	@survey = Survey__c.find(params[:id])
  end

end
