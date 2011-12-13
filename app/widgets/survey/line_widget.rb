class Survey::LineWidget < Apotomo::Widget

include Databasedotcom::Rails::Controller

	has_widgets do
		@line = options[:line_data]
		@surveyid = options[:surveyid]
		@line_items = Line_Item__c.query( "Line__c = '#{@line.Id}' order by Sort_Order__c asc")

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

		#queries that get responses and answer labels for every line item
		@response = Response__c.query("Survey__c = '#{@surveyid}' and Line_Item__c in #{@li_list} order by Line_Item_Sort_Order__c asc ")
		@answerlabels = Answer_Label__c.query("Answer_Sequence__c in #{@li_as_list} order by Sort_Order__c asc")

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
