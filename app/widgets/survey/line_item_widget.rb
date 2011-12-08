class Survey::LineItemWidget < Apotomo::Widget

include Databasedotcom::Rails::Controller

  def display
    @line_item = options[:li_data]
    @surveyid = options[:surveyid]
    puts "options = #{options[:li_data]}"
    @respId = ''
    @respVal = ''
    @resphash = {}

    ## Text Question
    if @line_item.Question_Type__c == 'Text'
        @responserecord = Response__c.query("Survey__c = '#{@surveyid}' and Line_Item__c = '#{@line_item.Id}' order by LastModifiedDate desc limit 1 ")
        
        if !@responserecord.empty?
            @respVal = @responserecord[0].Text_Long_Response__c
            @respId = @responserecord[0].Id
        end

    ## SelectOneQuestion Question
    elsif @line_item.Question_Type__c == 'SelectOneQuestion'
    	@answerlabels = Answer_Label__c.query("Answer_Sequence__c = '#{@line_item.Answer_Sequence__c}' order by Sort_Order__c asc")
        @responserecord = Response__c.query("Survey__c = '#{@surveyid}' and Line_Item__c = '#{@line_item.Id}' order by LastModifiedDate desc limit 1 ")

        if !@responserecord.empty?
            @respVal = @responserecord[0].Text_Long_Response__c
            @respId = @responserecord[0].Id
        end

    ## SelectMultipleQuestions Question
    elsif @line_item.Question_Type__c == 'SelectMultipleQuestions'
    	@answerlabels = Answer_Label__c.query("Answer_Sequence__c = '#{@line_item.Answer_Sequence__c}' order by Sort_Order__c asc")
        @responserecord = Response__c.query("Survey__c = '#{@surveyid}' and Line_Item__c = '#{@line_item.Id}' order by LastModifiedDate desc limit 1 ")
        @array = []

        if !@responserecord.empty?
            @array = @responserecord[0].Text_Long_Response__c.split(';')
            @respId = @responserecord[0].Id
            @respLabels = @responserecord[0].Label_Long_Response__c;
        end

        if !@array.empty?
            @array.each { |k,v| @resphash[k]=v }
        end
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! respVal = '#{@respVal}' "
    
    end

    render
  end

end
