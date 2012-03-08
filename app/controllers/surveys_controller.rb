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

    @answerlabels = nil
    if @GridAnsSeqIds != '()'
      @answerlabels = session[:client].query("select Id, Name, Answer_Sequence__c, Answer_Text__c, Resource__c, Resource_Name__c, Sort_Order__c from Answer_Label__c where Answer_Sequence__c in #{@GridAnsSeqIds} order by Sort_Order__c asc")
    end

    @h_answers = {}
    if !@answerlabels.blank?
      @answerlabels.each { |a| @h_answers[a.Answer_Sequence__c] ? @h_answers[a.Answer_Sequence__c] << a : @h_answers[a.Answer_Sequence__c] = [a] }
    end

    #cleans response array from subgrid questions
    @respN = @responses
    @respN.delete_if{|x| @gsq.has_key?(x.Id) }
  end

  def print
    @invite = session[:client].query("select Id, Name, Survey__c, Survey__r.Name, Survey__r.Description__c from Invitation__c where Id = '#{params[:id]}'")
    @lines_query = session[:client].query("select Id, Name, Description__c, Sort_Order__c, Survey__c from Line__c where Survey__c = '#{@invite[0].Survey__c}' order by Sort_Order__c asc")


    
    @lines_list = ''
    @li_list = ''
    @h_grid = {}
    @gsq = {} #controls grid views

    #@larray = Array.new

    @lines_query.each do |li|
     # @larray << li
      @lines_list = (@lines_list == '') ? ( @lines_list + "\'#{li.Id}\'" ) : ( @lines_list + ", \'#{li.Id}\'" )
    end
    @lines_list = "("+@lines_list+")"
    @line_items = session[:client].query( "select Id, Name, Answer_Sequence__c, Content_Description__c, Display_Format__c, Line__c, Line_Item_Type__c, Question_Description__c, Question_Type__c, Resource__c, Resource__r.Name, Resource_Name__c, Sort_Order__c, URL__c, Content_Type__c, Enable_Autocomplete__c, Help_Text__c, Calculation_Logic__c, Length__c, Max_Value__c, Min_Value__c, Required__c, Parent_Line_Item__c from Line_Item__c where Line__c in #{@lines_list} order by Sort_Order__c asc")

    @h_li = {}
    @aseq = ''
    if !@line_items.empty?
        @line_items.each { |a| 
          
          if a.Question_Type__c == 'GridSubQuestion'
            #logic to add child to parent grid on hash
            @h_grid[a.Parent_Line_Item__c] ? @h_grid[a.Parent_Line_Item__c] << a : @h_grid[a.Parent_Line_Item__c] = [a]
          else
            @h_li[a.Line__c] ? @h_li[a.Line__c] << a : @h_li[a.Line__c] = [a] 
          end

          @aseq = (@aseq == '') ? ( @aseq + "\'#{a.Answer_Sequence__c}\'" ) : ( @aseq + ", \'#{a.Answer_Sequence__c}\'" )
        }
    end
    @aseq = "("+@aseq+")"

    @answerlabels = session[:client].query("select Id, Name, Answer_Sequence__c, Answer_Text__c, Resource__c, Resource_Name__c, Sort_Order__c from Answer_Label__c where Answer_Sequence__c in #{@aseq} order by Sort_Order__c asc")

    @h_aseq = {}
    if !@answerlabels.empty?
        @answerlabels.each { |a| @h_aseq[a.Answer_Sequence__c] ? @h_aseq[a.Answer_Sequence__c] << a : @h_aseq[a.Answer_Sequence__c] = [a] }
    end

  end
  
  private

  def survey_error(exception)
      puts "waaaaaaaaahhhhhhhhhhhjjjjjjjjjjjjjjjjsadDDsasa^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ exception = '#{exception}' "
      #redirect_to "/invite/index", :alert => exception.message
      redirect_to invite_index_path, :alert => exception.message
  end

  def survey_error_review(exception)
    puts "Build error on survey, sent user to review page"
    #redirect_to "/surveys/#{params[:id]}/review"
    redirect_to "/client/surveys/#{params[:id]}/review"
  end

end
