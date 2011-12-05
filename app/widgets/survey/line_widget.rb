class Survey::LineWidget < Apotomo::Widget

include Databasedotcom::Rails::Controller

	has_widgets do
		@line = options[:line_data]
		@line_items = Line_Item__c.query( "Line__c = '#{@line.Id}' order by Sort_Order__c asc")

		@line_items.each_with_index do |t, i|
			child_id = "line_item_'#{i}'"
	       	next if self[child_id]  # we already added it.
	        puts "#{child_id}"
	        self << widget("survey/line_item", child_id, :li_data => t)
		end 
		self << widget("survey/surveycontrol", :surveycontrol)

	end



  def display
    render
  end


end
