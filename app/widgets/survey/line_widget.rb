class Survey::LineWidget < Apotomo::Widget

#include Databasedotcom::Rails::Controller

	has_widgets do
		@line = options[:line_data]
		@surveyid = options[:surveyid]
		@inviteid = options[:inviteid]
		@line_items = session[:client].query( "select Id, Name, Answer_Sequence__c, Content_Description__c, Display_Format__c, Line__c, Line_Item_Type__c, Question_Description__c, Question_Type__c, Resource__c, Resource__r.Name, Resource_Name__c, Sort_Order__c, URL__c, Content_Type__c, Enable_Autocomplete__c, Help_Text__c, Calculation_Logic__c from Line_Item__c where Line__c = '#{@line.Id}' order by Sort_Order__c asc")

		@li_list = ''
		@li_as_list = ''
		@line_items.each_with_index do |li, i|
			#line item ids
			if @li_list == ''
				@li_list += "\'#{li.Id}\'"
			else
				@li_list += ", \'#{li.Id}\'"
			end

			#line item answer sequence ids
			if @li_as_list == ''
				@li_as_list += "\'#{li.Answer_Sequence__c}\'"
			else
				@li_as_list += ", \'#{li.Answer_Sequence__c}\'"
			end
		end
		@li_list = "("+@li_list+")"
		@li_as_list = "("+@li_as_list+")"
		@response = session[:client].query("select Id, Name, Date_Response__c, DateTime_Response__c, Integer_Response__c, Invitation__c, Label_Response__c, Line_Item__c, Line_Item_Sort_Order__c, Line_Name__c, Line_Sort_Order__c, Response_Type__c, Survey__c, Survey_Subject__c, Text_Long_Response__c, Text_Response__c from Response__c where Survey__c = '#{@surveyid}' and Invitation__c = '#{@inviteid}' and Line_Item__c in #{@li_list} order by Line_Item_Sort_Order__c asc ")
		@answerlabels = session[:client].query("select Id, Name, Answer_Sequence__c, Answer_Text__c, Resource__c, Resource_Name__c, Sort_Order__c from Answer_Label__c where Answer_Sequence__c in #{@li_as_list} order by Sort_Order__c asc")

		@h_response = {}
		if !@response.empty?
            @response.each { |r| @h_response[r.Line_Item__c] ? @h_response[r.Line_Item__c] << r : @h_response[r.Line_Item__c] = [r] }
        end

		@h_answers = {}
		if !@answerlabels.empty?
            @answerlabels.each { |a| @h_answers[a.Answer_Sequence__c] ? @h_answers[a.Answer_Sequence__c] << a : @h_answers[a.Answer_Sequence__c] = [a] }
        end

		@line_items.each_with_index do |t, i|
			child_id = "line_item_'#{i}'"
	       	next if self[child_id]  # we already added it.
	        self << widget("survey/line_item", child_id, :li_data => t, :surveyid => @surveyid, :li_resp => @h_response[t.Id], :ans => @h_answers[t.Answer_Sequence__c])
		end 

	end


  def display
    render
  end


end
