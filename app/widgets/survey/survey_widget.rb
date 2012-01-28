class Survey::SurveyWidget < Apotomo::Widget

include SurveysHelper

helper_method :update_multiple, :surveyerrors
responds_to_event :submit, :with => :update_multiple


	has_widgets do
		@survey = options[:survey]
		puts "^^^^^^^^^^^^^^^^^^^^ survey_widget.rb Kaminari execution ^^^^^^^^^^^^^^^^^^^^"
		
		@pageno = params[:page].to_i
		@lines_query = session[:client].query("select Id, Name, Description__c, Display_Logic__c, Sort_Order__c, Survey__c from Line__c where Survey__c = '#{@survey[0].Survey__c}' order by Sort_Order__c asc")
		
		@liq_array = []
		 
		for liq in @lines_query do
			@liq_array << liq
		end

		@showsections = []
		@it_stop = 0
		while @showsections.empty? && @it_stop < 100
			@lines = Kaminari.paginate_array(@liq_array).page(@pageno).per(1) # Paginates the array
			@currentpg = @lines.current_page.to_f - 1
			@totalpg = @lines.num_pages.to_f
			@it_stop = @it_stop + 1
			@progressbar = (@currentpg  / @totalpg) * 100
			@lines.each do |l|
				if l.Display_Logic__c != nil
					eval_dl = displaylogic(l, params[:id])
					
					if eval_dl #display logic is true
						@showsections << l
					end
				else
					@showsections << l
				end
			end

			if @showsections.empty?
				if params[:dir] == '0'
					@pageno -= 1
					params[:page] = @pageno
				else
					@pageno += 1
					params[:page] = @pageno
				end
			end
		end #end while

		#catch survey sections being empty
		if @showsections.to_s == '[]'
			puts "^^^^^^^^^^^^^^^^^^^^ survey_widget.rb survey displaylogic error ^^^^^^^^^^^^^^^^^^^^"
			surveyerrors
		else
			@showsections.each_with_index do |t, i|
				child_id = "line_'#{i}'"
		       	next if self[child_id]  # we already added it.
		        self << widget("survey/line", child_id, :line_data => t, :surveyid => @survey[0].Survey__c, :inviteid => params[:id])
			end 
		end
	end

	def displaylogic(conditional, inviteid)
		#display logic should go here
		#puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! displaylogic, conditional = '#{conditional}'  "
	
		if conditional.Display_Logic__c != nil
			@string = conditional.Display_Logic__c 
			@expressions = @string.split(/\s/)

			@qstring = ''
			@string.split.each do |s|
				if s.include? '@'
					#ternary operator that I should remember to use on survey_helper.rb
					@qstring == '' ? (@qstring = "\'#{s.gsub(/\(|\)/,"")}\'") : (@qstring += ", \'#{s.gsub(/\(|\)/,"")}\'")
				end
			end

			@qstring = "("+@qstring+")"
			@rdata = session[:client].query("select Id, Name, Invitation__c, Label_Response__c, Line_Item__c, Line_Item_Resource__c, Line_Item_Sort_Order__c, Line_Name__c, Line_Sort_Order__c, Response_Type__c, Survey__c, Text_Long_Response__c, Text_Response__c, Integer_Response__c from Response__c where Line_Item_Resource__c in #{@qstring} and Invitation__c = '#{inviteid}' ")

			@h_rq = {}
			if !@rdata.empty?
	            @rdata.each { |r| @h_rq[r.Line_Item_Resource__c] ? @h_rq[r.Line_Item_Resource__c] << r : @h_rq[r.Line_Item_Resource__c] = [r] }
	        end

	        @expressions.each do |e|
	        	if e.include? '@' 
	        		question = e.match(/@[a-zA-Z0-9_\-]+/)
	        		#add no response validation
	        		if @h_rq["#{question}"][0].Response_Type__c == 'Integer' || @h_rq["#{question}"][0].Response_Type__c == 'Calculation'
	        			puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Integer Response = '#{@h_rq["#{question}"][0].Integer_Response__c }' "
	        			qv =  @h_rq["#{question}"][0].Integer_Response__c.to_s 
	        			puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! qv = '#{qv}' "
	        		else
	        			qv = "'" + @h_rq["#{question}"][0].Text_Long_Response__c + "'"
	        		end

	        		e["#{question}"] = qv

	        	elsif e.include? '#' 
	        		answer = e.match(/#[a-zA-Z0-9_\-]+/)
	        		m_ans = "'" + answer.to_s + "'"
	        		e["#{answer}"] = m_ans
	        	end
	        end

			puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! expressions = '#{@expressions}' "
			
			@evalstring = @expressions * ""
			puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for evalstring = '#{@evalstring}' "
			puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for evalstring = '#{@evalstring}' , eval = '#{eval(@evalstring)}' "

			return eval(@evalstring)
			
		end
	end

	def display
		render 
	end

end
