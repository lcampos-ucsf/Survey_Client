class Survey::LineItemWidget < Apotomo::Widget

include Databasedotcom::Rails::Controller

  def display
    @line_item = options[:li_data]
    puts "options = #{options[:li_data]}"

    if @line_item.Question_Type__c == 'SelectOneQuestion'
    	@answerlabels = Answer_Label__c.query("Answer_Sequence__c = '#{@line_item.Answer_Sequence__c}' order by Sort_Order__c asc")
    elsif @line_item.Question_Type__c == 'SelectMultipleQuestions'
    	@answerlabels = Answer_Label__c.query("Answer_Sequence__c = '#{@line_item.Answer_Sequence__c}' order by Sort_Order__c asc")
    end

    render
  end

end
