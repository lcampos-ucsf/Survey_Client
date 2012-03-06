class Survey::SurveyWidget < Apotomo::Widget

include SurveysHelper

helper_method :update_multiple, :surveyerrors
responds_to_event :submit, :with => :update_multiple


	has_widgets do
		@survey = options[:survey]
		@inviteid = params[:id]
		@surveyid = @survey[0].Survey__c
		puts "^^^^^^^^^^^^^^^^^^^^ survey_widget.rb Kaminari execution ^^^^^^^^^^^^^^^^^^^^"
		
		#security enhancement
		@pageno = (params[:page]!= nil) ? ( params[:page].match(/^[0-9]*$/) == nil ? 1 : Sanitize.clean(params[:page]).to_i ) : 1

		puts "-------------------- survey_widget.rb after sanitize, pageno = '#{@pageno}' "
		@lines_query = session[:client].query("select Id, Name, Description__c, Display_Logic__c, Sort_Order__c, Survey__c from Line__c where Survey__c = '#{@survey[0].Survey__c}' order by Sort_Order__c asc")
		
		@liq_array = []
		 
		for liq in @lines_query do
			@liq_array << liq
		end

		@showsections = []
		@it_stop = 0
		#loop while showsections array is empty and it_stop is less than 100, this prevents infinite loop
		while @showsections.empty? && @it_stop < 100
			puts "-------------------- survey_widget.rb showsections while start"

			@lines = Kaminari.paginate_array(@liq_array).page(@pageno).per(1) # Paginates the array

			#calculations needed for progress bar
			@currentpg = @lines.current_page.to_f - 1
			@totalpg = @lines.num_pages.to_f
			@it_stop = @it_stop + 1
			@progressbar = (@currentpg  / @totalpg) * 100

			@ls = @lines.current_page.to_f

			puts "-------------------- survey_widget.rb current page = '#{@currentpg.to_i}' "

			#evaluate display logic on lines
			@lines.each do |l|
				puts "-------------------- survey_widget.rb lines for"
				if l.Display_Logic__c != nil
					puts "-------------------- survey_widget.rb display logic present"
					eval_dl = displaylogic(l, params[:id])
					puts "-------------------- survey_widget.rb eval_dl = '#{eval_dl}' "
					if eval_dl #display logic is true, add data to showsections array
						@showsections << l
					else

						puts "@ls = #{@ls}"
						#if display logic is not met, we need to check for responses in this section that need to be erased
						@response = session[:client].query("select Id, Name, Date_Response__c, DateTime_Response__c, Integer_Response__c, Line_Item__c, Text_Long_Response__c, Text_Response__c, Line_Sort_Order__c, Survey__c, Invitation__c from Response__c where Survey__c = '#{@surveyid}' and Invitation__c = '#{@inviteid}' and Line_Sort_Order__c = #{@ls} ")
						
						@responseDel_array = Array.new
						if !@response.empty?
							
							@response.each do |r|

								@responseDel_array << { :Id => r.Id,
												:Survey__c => r.Survey__c, 
												:Invitation__c => r.Invitation__c,
												:Line_Item__c => r.Line_Item__c,
												:Text_Long_Response__c => '',
												:Label_Long_Response__c => '', 
												:Date_Response__c => nil,
												:DateTime_Response__c => nil,
												:Integer_Response__c => nil }
							end

							puts "--------------- responseDel_array = #{@responseDel_array} "
							results = session[:client].http_post('/services/apexrest/v1/Response/',@responseDel_array.to_json)
							puts "---------- results = '#{results}' "

						end

					end
				else
					puts "-------------------- survey_widget.rb NO display logic present"
					@showsections << l
				end
			end

			#check the sections array needed to render the survey section
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
		        self << widget("survey/line", child_id, :line_data => t, :surveyid => @survey[0].Survey__c, :inviteid => @inviteid)
			end 
		end
	end

	def displaylogic(conditional, inviteid)
		#display logic should go here
		puts "///////////////// display logic /////////////////////"
		puts "///////////////// display logic /////////////////////"
		puts "///////////////// display logic /////////////////////"
		puts "///////////////// display logic /////////////////////"
		puts "///////////////// display logic /////////////////////"
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
			@rdata = session[:client].query("select Id, Name, Invitation__c, Label_Response__c, Line_Item__c, Line_Item_Resource_Name__c, Line_Item_Sort_Order__c, Line_Name__c, Line_Sort_Order__c, Response_Type__c, Survey__c, Text_Long_Response__c, Text_Response__c, Integer_Response__c, Date_Response__c from Response__c where Line_Item_Resource_Name__c in #{@qstring} and Invitation__c = '#{inviteid}' ")

			@h_rq = {}
			if !@rdata.empty?
	            @rdata.each { |r| @h_rq[r.Line_Item_Resource_Name__c] ? @h_rq[r.Line_Item_Resource_Name__c] << r : @h_rq[r.Line_Item_Resource_Name__c] = [r] }
	        end

	        #adding response values to conditional formula
	        @expressions.each do |e|
	        	if e.include? '@' 
	        		question = e.match(/@[a-zA-Z0-9_\-]+/)
	        		#add no response validation
	        		qv = '0'

	        		if @h_rq.has_key?("#{question}")
		        		if @h_rq["#{question}"][0].Response_Type__c == 'Integer' || @h_rq["#{question}"][0].Response_Type__c == 'Calculation'
		        			puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Integer Response = '#{@h_rq["#{question}"][0].Integer_Response__c }' "
		        			qv =  (@h_rq["#{question}"][0].Integer_Response__c == '' || @h_rq["#{question}"][0].Integer_Response__c == nil ) ? '0' : @h_rq["#{question}"][0].Integer_Response__c.to_s 
		        		elsif @h_rq["#{question}"][0].Response_Type__c == 'Date' 
		        			puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Date Response = '#{@h_rq["#{question}"][0].Date_Response__c }' "
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

			puts "--------- evalstring = '#{@evalstring}' "
			
			@m_log = @evalstring.index(/\;/)
			if @m_log != nil
				puts "+++++++++ m_log = '#{@m_log}' "
			
				#multiple select evaluations for conditional formula
				orig_multicondition = @evalstring.scan(/[\'\#\;0-9a-zA-Z\_\-]+[\<\>\=]+[\'\#0-9a-zA-Z\_\-]+/)
				puts "-----------orig_multicondition.scan = '#{orig_multicondition}' "

				if !orig_multicondition.empty?
					orig_multicondition.each do |omc|
						#this is the multiselect string that we need to reposition on conditional formula
						#@logic_p1 = omc.scan(/[\#\;0-9a-zA-Z\_\-]+\;/)
						#this is the last part of the multiselect formula we need to copy
						@logic_p2 = omc.scan(/[\<\>\=]+[\'\#0-9a-zA-Z\_\-]+/)
						
						#this breaks logic p1 into pieces
						@logic_p1 = omc.scan(/\#\w+\;/)

						@nlogic = ''
						@logic_p1.each_with_index do |el, i|
							el = el.gsub(';','')
							@nlogic = (@nlogic == '' || @nlogic == nil ) ? "('#{el}'#{@logic_p2[0]})" : @nlogic + " || ('#{el}'#{@logic_p2[0]})"
						end

						#substitute the omc for the new conditional formula
						@evalstring = @evalstring.gsub(omc,@nlogic)
					end
				end
			end
			
			#date evaluations for conditional formula
			orig_datecondition = @evalstring.scan(/[0][\<\>\=\!]+\d{2}\/\d{2}\/\d{4}|\d{2}\/\d{2}\/\d{4}[\<\>\=\!]+\d{2}\/\d{2}\/\d{4}/)
			puts "-----------orig_datecondition.scan = '#{orig_datecondition}' "

			if !orig_datecondition.empty?
				orig_datecondition.each do |g|
					ee = g.split(/[\<\>\=\!]+/)
					sign = g.scan(/[\<\>\=\!]+/)
					
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
						elsif sign[0] == '!='
							evalv = (fval != lval) ? 'true' : 'false'
							@evalstring = @evalstring.gsub(g,evalv)
						end
					end
				end
			end

			#remove #int for calculation to take place
			@calc = @evalstring.scan(/\'\#int[0-9]+\'/)
			if !@calc.empty?
				@calc.each do |k|
					@num = k.scan(/[0-9]+/)
					@evalstring = @evalstring.gsub(k,@num[0])
				end
			end

			puts "@evalstring = '#{@evalstring}'" 
			#all evaluations for conditional formula
			@evaluation = eval(@evalstring)
			puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for evalstring = '#{@evalstring}' , @evaluation = '#{@evaluation}' "
			return @evaluation
			
		end
	end

	def display
		render 
	end

end
