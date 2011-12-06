class Survey::LineItemWidget < Apotomo::Widget

include Databasedotcom::Rails::Controller

  def display
    @line_item = options[:li_data]
    @surveyid = options[:surveyid]
    puts "options = #{options[:li_data]}"
    @responserecord = ''

    if @line_item.Question_Type__c == 'SelectOneQuestion'
    	@answerlabels = Answer_Label__c.query("Answer_Sequence__c = '#{@line_item.Answer_Sequence__c}' order by Sort_Order__c asc")
        @responserecord = Response__c.query("Survey__c = '#{@surveyid}' and Line_Item__c = '#{@line_item.Id}' order by LastModifiedDate desc limit 1 ")
        
        @responserecordId = @responserecord[0] ? @responserecord[0].Id : ''
        

    elsif @line_item.Question_Type__c == 'SelectMultipleQuestions'
    	@answerlabels = Answer_Label__c.query("Answer_Sequence__c = '#{@line_item.Answer_Sequence__c}' order by Sort_Order__c asc")
    
    elsif @line_item.Question_Type__c == 'Text'
        @responserecord = Response__c.query("Survey__c = '#{@surveyid}' and Line_Item__c = '#{@line_item.Id}' order by LastModifiedDate desc limit 1 ")
        @rrTextLongResponse = @responserecord[0] ? @responserecord[0].Text_Long_Response__c : ''
        @responserecordId = @responserecord[0] ? @responserecord[0].Id : ''
    end

    render
  end

end
