class Survey::SurveyWidget < Apotomo::Widget
include Databasedotcom::Rails::Controller

	has_widgets do
		#@lines = Line__c.query( "Survey__c = '#{params[:id]}' order by Sort_Order__c asc").page(1).per(1)
		@lines_query = Line__c.query( "Survey__c = '#{params[:id]}' order by Sort_Order__c asc")
		@lines = Kaminari.paginate_array(@lines_query).page(params[:page]).per(1) # Paginates the array

		@lines.each_with_index do |t, i|
			child_id = "line_'#{i}'"
	       	next if self[child_id]  # we already added it.
	        puts "#{child_id}"
	        self << widget("survey/line", child_id, :line_data => t)
		end 

	end

	def display
=begin
		@lines_query = Line__c.query( "Survey__c = '#{params[:id]}' order by Sort_Order__c asc")
		@lines = Kaminari.paginate_array(@lines_query).page(params[:page]).per(1) # Paginates the array

		
		@lines.each_with_index do |t, i|
			child_id = "line_'#{i}'"
	       	next if self[child_id]  # we already added it.
	        puts "#{child_id}"
	        self << widget("survey/line", child_id, :line_data => t)
		end 
=end
		render 
=begin
		respond_to do |format|
			format.html  
		end
=end
	end




end
