class Survey::SurveyWidget < Apotomo::Widget
include Databasedotcom::Rails::Controller
include SurveysHelper

helper_method :update_multiple
helper_method :redirect_to
responds_to_event :submit, :with => :update_multiple


	has_widgets do
		#@lines = Line__c.query( "Survey__c = '#{params[:id]}' order by Sort_Order__c asc").page(1).per(1)
		@lines_query = Line__c.query( "Survey__c = '#{params[:id]}' order by Sort_Order__c asc")
		@lines = Kaminari.paginate_array(@lines_query).page(params[:page]).per(1) # Paginates the array

		@lines.each_with_index do |t, i|
			child_id = "line_'#{i}'"
	       	next if self[child_id]  # we already added it.
	        puts "#{child_id}"
	        self << widget("survey/line", child_id, :line_data => t, :surveyid => params[:id])
		end 
		
	end

	def display
		render 
	end

end
