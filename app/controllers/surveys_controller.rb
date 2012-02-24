class SurveysController < ApplicationController
	
  before_filter :authenticate

  rescue_from Exceptions::SurveyNotAvailable, :with => :survey_error
  rescue_from Exceptions::SurveyBuildError, :with => :survey_error_review

  include SurveysHelper

  helper_method :current_survey
  has_widgets do |root|
    @s = current_survey
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
    @responses = session[:client].query("select Id, Name, Date_Response__c, DateTime_Response__c, Integer_Response__c, Invitation__c, Label_Long_Response__c, Label_Response__c, Line_Item__c, Line_Item_Sort_Order__c, Line_Name__c, Line_Sort_Order__c, Original_Question_Text__c, Response_Type__c, Survey__c, Survey_Subject__c, Text_Long_Response__c, Text_Response__c, Invitation__r.Progress_Save__c, Line_Item__r.Parent_Line_Item__c, Line_Item__r.Parent_Line_Item__r.Answer_Sequence__c, Line_Item__r.Parent_Line_Item__r.Question_Description__c from Response__c where Survey__c = '#{@surveyid}' and Invitation__c = '#{params[:id]}' order by Line_Sort_Order__c, Line_Item_Sort_Order__c " )
    
    @h_grid = {}
    @h_gridHeader = {}
    @h_gridResp = {}
    @respN = @responses
    @gsq = {} #controls grid views
    @responses.each_with_index do |r, i|

      if r.Response_Type__c == 'GridSubQuestion'
        #logic to add child to parent grid on hash
        if @h_grid.has_key?(r.Line_Item__r.Parent_Line_Item__c)
          @gsq[r.Id] = r
        end

        @h_grid[r.Line_Item__r.Parent_Line_Item__c] ? @h_grid[r.Line_Item__r.Parent_Line_Item__c] << r : @h_grid[r.Line_Item__r.Parent_Line_Item__c] = [r]
        @h_gridHeader[r.Line_Item__r.Parent_Line_Item__c] = r.Line_Item__r.Parent_Line_Item__r.Answer_Sequence__c
        @h_gridResp[r.Id] = r
      end

    end

    @GridAnsSeqIds = ''

    #get grid answer sequence ids
    @h_gridHeader.values.each{|ha| @GridAnsSeqIds = (@GridAnsSeqIds == '' || @GridAnsSeqIds == nil) ? "\'#{ha}\'" : @GridAnsSeqIds + ", \'#{ha}\'" }
    @GridAnsSeqIds = "("+@GridAnsSeqIds+")"

    @answerlabels = session[:client].query("select Id, Name, Answer_Sequence__c, Answer_Text__c, Resource__c, Resource_Name__c, Sort_Order__c from Answer_Label__c where Answer_Sequence__c in #{@GridAnsSeqIds} order by Sort_Order__c asc")
    @h_answers = {}
    if !@answerlabels.empty?
      @answerlabels.each { |a| @h_answers[a.Answer_Sequence__c] ? @h_answers[a.Answer_Sequence__c] << a : @h_answers[a.Answer_Sequence__c] = [a] }
    end

    #cleans response array from subgrid questions
    @respN = @responses
    @respN.delete_if{|x| @gsq.has_key?(x.Id) }
  end
  
  private

  def survey_error(exception)
      puts "waaaaaaaaahhhhhhhhhhhjjjjjjjjjjjjjjjjsadDDsasa^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ exception = '#{exception}' "
      redirect_to "/invite/index", :alert => exception.message
  end

  def survey_error_review(exception)
    puts "Build error on survey, sent user to review page"
    redirect_to "/surveys/#{params[:id]}/review"
  end

end
