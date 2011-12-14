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
				@string = "((#q_park == #wua) OR (#q_gender == #male) AND (#q_genre == #mariachi))"

				#@string = @string.split(/{|}/)
				@string = @string.split(/\(|\)/) #this regex splits contents inside and out of ()

				puts " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! regex = '#{@string}' "

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
