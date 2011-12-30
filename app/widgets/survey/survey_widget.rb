class Survey::SurveyWidget < Apotomo::Widget

include SurveysHelper

helper_method :update_multiple, :surveyerrors
responds_to_event :submit, :with => :update_multiple


	has_widgets do
		@survey = options[:survey]
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution, params[:page] = '#{params[:page]}', params[:dir] = '#{params[:dir]}' "
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"

		#materialization
		line = session[:client].materialize("Line__c") 

		@pageno = params[:page].to_i
		@lines_query = line.query( "Survey__c = '#{@survey[0].Survey__c}' order by Sort_Order__c asc")
		
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
			puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ @currentpg = '#{@currentpg}', @totalpg = '#{@totalpg}', @progressbar = '#{@progressbar}', @it_stop = '#{@it_stop}' "


			@lines.each do |l|
				if l.Display_Logic__c != nil
					puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
					puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ has Display Logic"
					puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
					eval_dl = displaylogic(l, params[:id])
					
					if eval_dl #display logic is true
						puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ eval_dl = '#{eval_dl}' "
						@showsections << l
					end
				else
					puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ HAD NO DISPLAY LOGIC "
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

		#catch survey sections with errors
		#if @showsections.empty?
			#surveyerrors
			#redirect_to root_path, :notice => "Survey '#{@survey[0].Survey_Name__c}' has errors, please notify it to your manager."
		#end

		@showsections.each_with_index do |t, i|
			child_id = "line_'#{i}'"
	       	next if self[child_id]  # we already added it.
	        self << widget("survey/line", child_id, :line_data => t, :surveyid => @survey[0].Survey__c, :inviteid => params[:id])
		end 
		
	end

	def displaylogic(conditional, inviteid)
		#display logic should go here
		puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! displaylogic, conditional = '#{conditional}'  "
		#materialization
		response = session[:client].materialize("Response__c")

		#conditional.each do |l|
			if conditional.Display_Logic__c != nil
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Display Logic = '#{conditional.Display_Logic__c}' "
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				@string = conditional.Display_Logic__c #"((@q_gender == #male ) or (@q_patient_admit_service == #surgical))" 
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! string = '#{@string}' "

				#@expressions = @string.split(/\(|\)/).reject(&:blank?) #this regex splits contents inside and out of (), reject eliminates blank and nil strings on array
				@expressions = @string.split(/\s/)

				@qstring = ''
				@string.split.each do |s|
					puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! string split s = '#{s}' "

					if s.include? '@'
						#ternary operator that I should remember to use on survey_helper.rb
						@qstring == '' ? (@qstring = "\'#{s.gsub(/\(|\)/,"")}\'") : (@qstring += ", \'#{s.gsub(/\(|\)/,"")}\'")
					end
				end

				@qstring = "("+@qstring+")"

				@rdata = response.query("Line_Item_Resource__c in #{@qstring} and Invitation__c = '#{inviteid}' ")

				@h_rq = {}
				if !@rdata.empty?
		            @rdata.each { |r| @h_rq[r.Line_Item_Resource__c] ? @h_rq[r.Line_Item_Resource__c] << r : @h_rq[r.Line_Item_Resource__c] = [r] }
		        end

		        @expressions.each do |e|
		        	if e.include? '@' 
		        		question = e.match(/@[a-zA-Z0-9_\-]+/)
		        		qv = "'" + @h_rq["#{question}"][0].Text_Long_Response__c + "'"
		        		e["#{question}"] = qv

		        	elsif e.include? '#' 
		        		answer = e.match(/#[a-zA-Z0-9_\-]+/)
		        		m_ans = "'" + answer.to_s + "'"
		        		e["#{answer}"] = m_ans
		        	end
		        end


				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for expressions = '#{@expressions}' "
				@evalstring = @expressions * ""
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for evalstring = '#{@evalstring}' , eval = '#{eval(@evalstring)}' "

				return eval(@evalstring)
				
			end
		#end
	end

	def display
		render 
	end

end
