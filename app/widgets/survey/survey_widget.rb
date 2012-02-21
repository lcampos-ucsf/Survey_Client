class Survey::SurveyWidget < Apotomo::Widget

include SurveysHelper

helper_method :update_multiple, :surveyerrors
responds_to_event :submit, :with => :update_multiple


	has_widgets do
		@survey = options[:survey]
		puts "^^^^^^^^^^^^^^^^^^^^ survey_widget.rb Kaminari execution ^^^^^^^^^^^^^^^^^^^^"
		
		#security enhancement
		@pageno = (params[:page]!= nil) ? ( params[:page].match(/^[0-9]*$/) == nil ? 1 : Sanitize.clean(params[:page]).to_i ) : 1

		puts "-------------------- after sanitize, pageno = '#{@pageno}' "
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
					puts "------------------- pageno = '#{@pageno}' "
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
			@rdata = session[:client].query("select Id, Name, Invitation__c, Label_Response__c, Line_Item__c, Line_Item_Resource__c, Line_Item_Sort_Order__c, Line_Name__c, Line_Sort_Order__c, Response_Type__c, Survey__c, Text_Long_Response__c, Text_Response__c, Integer_Response__c, Date_Response__c from Response__c where Line_Item_Resource__c in #{@qstring} and Invitation__c = '#{inviteid}' ")

			@h_rq = {}
			if !@rdata.empty?
	            @rdata.each { |r| @h_rq[r.Line_Item_Resource__c] ? @h_rq[r.Line_Item_Resource__c] << r : @h_rq[r.Line_Item_Resource__c] = [r] }
	        end

	        #adding response values to conditional formula
	        @expressions.each do |e|
	        	if e.include? '@' 
	        		question = e.match(/@[a-zA-Z0-9_\-]+/)
	        		#add no response validation
	        		qv = '0'

	        		if @h_rq.has_key?("#{question}")
		        		if @h_rq["#{question}"][0].Response_Type__c == 'Integer' || @h_rq["#{question}"][0].Response_Type__c == 'Calculation'
		        			#puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Integer Response = '#{@h_rq["#{question}"][0].Integer_Response__c }' "
		        			qv =  (@h_rq["#{question}"][0].Integer_Response__c == '' || @h_rq["#{question}"][0].Integer_Response__c == nil ) ? '0' : @h_rq["#{question}"][0].Integer_Response__c.to_s 
		        		elsif @h_rq["#{question}"][0].Response_Type__c == 'Date' 
		        			#puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Date Response = '#{@h_rq["#{question}"][0].Date_Response__c }' "
		        			qv =  (@h_rq["#{question}"][0].Text_Long_Response__c == '' || @h_rq["#{question}"][0].Text_Long_Response__c == nil ) ? '0' : @h_rq["#{question}"][0].Text_Long_Response__c
		        		else
		        			puts "----------------- response = '#{@h_rq["#{question}"][0].Text_Long_Response__c}' " 
		        			a = (@h_rq["#{question}"][0].Text_Long_Response__c == ''|| @h_rq["#{question}"][0].Text_Long_Response__c == nil ) ? '' : @h_rq["#{question}"][0].Text_Long_Response__c
		        			qv = "'" + a + "'"
		        		end
		        	end
	        		e["#{question}"] = qv

	        	elsif e.include? '#' 
	        		answer = e.match(/#[a-zA-Z0-9_\-:]+/)
	        		m_ans = "'" + answer.to_s + "'"
	        		e["#{answer}"] = m_ans
	        	end
	        end

			puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! expressions = '#{@expressions}' "
			@evalstring = @expressions * ""

			#date evaluations for conditional formula
			b = @evalstring.scan(/[0][\<\>\=]+\d{2}\/\d{2}\/\d{4}|\d{2}\/\d{2}\/\d{4}[\<\>\=]+\d{2}\/\d{2}\/\d{4}/)
=begin			
			puts "--------- evalstring = '#{@evalstring}' "
			c = @evalstring.scan(/[(\#\w+\;)]*/)
			d= @evalstring.scan(/\w{^\#.\;$}/)
			puts "-----------c.scan = '#{c}' "
			puts "-----------d.scan = '#{d}' "
=end
			puts "-----------b.scan = '#{b}' "
			if !b.empty?
				b.each do |g|
					ee = g.split(/[\<\>\=]+/)
					sign = g.scan(/[\<\>\=]+/)

					puts "ee = '#{ee}', sign = '#{sign}' "

					if ee[0] == '0' || ee[1] == '0'
						@evalstring = @evalstring.gsub(g,'false')
					else
						fval = Date.strptime(ee[0], '%m/%d/%Y')
						lval = Date.strptime(ee[1], '%m/%d/%Y')
						if sign[0] == '>'
							evalv = (fval > lval) ? 'true' : 'false'
							@evalstring = @evalstring.gsub(g,evalv)
						elsif sign[0] == '<'
							evalv = (fval < lval) ? 'true' : 'false'
							@evalstring = @evalstring.gsub(g,evalv)
						elsif sign[0] == '=='
							evalv = (fval == lval) ? 'true' : 'false'
							@evalstring = @evalstring.gsub(g,evalv)
						elsif sign[0] == '>='
							evalv = (fval >= lval) ? 'true' : 'false'
							@evalstring = @evalstring.gsub(g,evalv)
						elsif sign[0] == '<='
							evalv = (fval <= lval) ? 'true' : 'false'
							@evalstring = @evalstring.gsub(g,evalv)
						end
					end
				end
			end

			
=begin
			if !c.empty?
				@m_ans = c[0].split(/\;/)
				puts "--------------- '#{@m_ans}' "
				@m_ans.each do |mm|
					puts "--------------- '#{mm}'"

				end
			end
=end
			puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for evalstring = '#{@evalstring}' , eval = '#{eval(@evalstring)}' "
			#all evaluations for conditional formula
			return eval(@evalstring)
			
		end
	end

	def display
		render 
	end

end
