class Survey::SurveyWidget < Apotomo::Widget
include Databasedotcom::Rails::Controller
include SurveysHelper

helper_method :update_multiple
helper_method :redirect_to
responds_to_event :submit, :with => :update_multiple


	has_widgets do

		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Kaminari execution"
		@pageno = params[:page].to_i
		@lines_query = Line__c.query( "Survey__c = '#{params[:sid]}' order by Sort_Order__c asc")
		@lines = Kaminari.paginate_array(@lines_query).page(@pageno).per(1) # Paginates the array
		@conditional = @lines

		#display logic should go here
		@conditional.each do |l|
			if l.Display_Logic__c != nil
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! Display Logic = '#{l.Display_Logic__c}' "
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
				@string = "((@q_gender == #male ) or (@q_patient_admit_service == #surgical))" # = l.Display_Logic__c
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! string = '#{@string}' "

				#@string = @string.split(/{|}/)
				#@expressions = @string.split(/\(|\)/).reject(&:blank?) #this regex splits contents inside and out of (), reject eliminates blank and nil strings on array
				@expressions = @string.split(/\s/)
				#@vsplit = @string.split(/\s|\(|\)/)
				#@vsplit = @string.split(/\b\w*[A-Za-z0-9_@.]\b/)
				@vsplit = @string.split(/@[a-zA-Z0-9_\-\.]+/)
				@test = @string.match(/#[a-zA-Z0-9_\-\.]+/)

				@qstring = ''
				@string.split.each do |s|
					if s.include? '@'
						#@qs << s.gsub(/\(|\)/,"")
						#ternary operator that I should remember to use on survey_helper.rb
						@qstring == '' ? (@qstring = "\'#{s.gsub(/\(|\)/,"")}\'") : (@qstring += ", \'#{s.gsub(/\(|\)/,"")}\'")
			
					end
				end

				@qstring = "("+@qstring+")"

				@rdata = Response__c.query("Line_Item_Resource__c in #{@qstring}")

				@h_rq = {}
				if !@rdata.empty?
		            @rdata.each { |r| @h_rq[r.Line_Item_Resource__c] ? @h_rq[r.Line_Item_Resource__c] << r : @h_rq[r.Line_Item_Resource__c] = [r] }
		        end

		        puts "**************************************** @expressions values = '#{@expressions}'  " 
		        puts "**************************************** @vsplit values =  '#{@vsplit}' "
		        puts "**************************************** @test values =  '#{@test}' "

		        @expressions.each do |e|
		        	if e.include? '@' 
		        		#tt = "'#male' == '#male'"
		        		#@wua = eval(tt)
		        		#puts "+++++++++++++++++++++++++++++++++++ eval = '#{@wua}' "
		        		#t = e.split(/\s/)
		        		question = e.match(/@[a-zA-Z0-9_\-]+/)
		        		#answer = e.match(/#[a-zA-Z0-9_\-\.]+/)
		        		qv = "'" + @h_rq["#{question}"][0].Text_Long_Response__c + "'"
		        		e["#{question}"] = qv
		        		puts "****************************************  @test = '#{question}', hash = '#{qv}' "

		        		puts "****************************************  e = '#{e}' "

		        	puts "**************************************** @expressions values after loop = '#{@expressions}'  " 

		        	elsif e.include? '#' 
		        		
		        		answer = e.match(/#[a-zA-Z0-9_\-]+/)
		        		puts "****************************************  #answers,  answer = '#{answer}' "
		        		m_ans = "'" + answer.to_s + "'"
		        		puts "****************************************  answer = '#{m_ans}' "
		        		e["#{answer}"] = m_ans
		        		puts "****************************************  e = '#{e}' "

		        	
		        	end
		        	puts "**************************************** @expressions values after loop = '#{@expressions}'  " 

		        end


				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for expressions = '#{@expressions}' "

				@evalstring = @expressions * ""

				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for evalstring = '#{@evalstring}' , eval = '#{eval(@evalstring)}' "

				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for questions = '#{@qs}' "
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex for question string = '#{@qstring}' "
				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! hash map = '#{@h_rq}' "

				@pageno += 1
				params[:page] = @pageno
				@lines = Kaminari.paginate_array(@lines_query).page(@pageno).per(1)
				#redirect_to "surveys/'#{params[:id]}'/show?page='#{params[:page]}'&sid='#{params[:sid]}' "
				#conditionalbranch

			end
		end

		@lines.each_with_index do |t, i|
			child_id = "line_'#{i}'"
	       	next if self[child_id]  # we already added it.
	        self << widget("survey/line", child_id, :line_data => t, :surveyid => params[:sid], :inviteid => params[:id])
		end 
		
	end

	def display
		render 
	end

end
