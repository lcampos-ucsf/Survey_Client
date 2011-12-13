class Survey::LineItemWidget < Apotomo::Widget

include Databasedotcom::Rails::Controller

  def display
    @line_item = options[:li_data]
    @surveyid = options[:surveyid]
    @responserecord = options[:li_resp]
    @answerlabels = options[:ans]
    @respId = ''
    @respVal = ''
    @resphash = {}

    if @line_item.Line_Item_Type__c == 'Question'
        ## Text Question
        if @line_item.Question_Type__c == 'Text'
            if @responserecord != nil
                @respVal = @responserecord[0].Text_Long_Response__c
                @respId = @responserecord[0].Id
            end

        ## SelectOneQuestion Question
        elsif @line_item.Question_Type__c == 'SelectOneQuestion'
            if @responserecord != nil
                @respVal = @responserecord[0].Text_Long_Response__c
                @respId = @responserecord[0].Id
            end

        ## SelectMultipleQuestions Question
        elsif @line_item.Question_Type__c == 'SelectMultipleQuestions'
            @array = []

            if @responserecord != nil 
                @array = @responserecord[0].Text_Long_Response__c.split(';')
                @respId = @responserecord[0].Id
                @respLabels = @responserecord[0].Label_Long_Response__c;
            end

            if !@array.empty?
                @array.each { |k,v| @resphash[k]=v }
            end
        
        end
    elsif @line_item.Line_Item_Type__c == 'Content'
        replace :state => :comment
    end

    render
  end

  def comment
    render
  end

end
