class Survey::LineItemWidget < Apotomo::Widget

#include Databasedotcom::Rails::Controller

  def display
    @line_item = options[:li_data]
    @surveyid = options[:surveyid]
    @responserecord = options[:li_resp]
    @answerlabels = options[:ans]
    @gridsubquestions = options[:gridsq]
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
            #replace :state => :text

        ## SelectOneQuestion Question
        elsif @line_item.Question_Type__c == 'SelectOneQuestion'
            if @responserecord != nil
                @respVal = @responserecord[0].Text_Long_Response__c
                @respId = @responserecord[0].Id
            end
=begin
            if @line_item.Display_Format__c == 'List'
                replace :state => :selectone_list
            elsif @line_item.Display_Format__c == 'Drop Down'
                replace :state => :selectone_dropdown
            end
=end
        ## SelectMultipleQuestions Question
        elsif @line_item.Question_Type__c == 'SelectMultipleQuestions'
            @array = []

            if @responserecord != nil 
                if @responserecord[0].Text_Long_Response__c != nil
                    @array = @responserecord[0].Text_Long_Response__c.split(';')
                end
                @respId = @responserecord[0].Id
                @respLabels = @responserecord[0].Label_Long_Response__c;
                @respVal = @responserecord[0].Text_Long_Response__c
            end

            if !@array.empty?
                @array.each { |k,v| @resphash[k]=v }
            end
           # replace :state => :selectmultiple
           
        ## Date or Datetime Question
        elsif @line_item.Question_Type__c == 'Date' || @line_item.Question_Type__c == 'Datetime'
            if @responserecord != nil
                @respVal = @responserecord[0].Text_Long_Response__c
                @respId = @responserecord[0].Id
            end

        ## Integer Question
        elsif @line_item.Question_Type__c == 'Integer'
            if @responserecord != nil
                @respVal = @responserecord[0].Text_Long_Response__c
                @respId = @responserecord[0].Id
            end

        ## Calculation Question
        elsif @line_item.Question_Type__c == 'Calculation'
            if @responserecord != nil
                @respVal = @responserecord[0].Text_Long_Response__c
                @respId = @responserecord[0].Id
            end

        ## Grid Question
        elsif @line_item.Question_Type__c == 'Grid'
            if @responserecord != nil
                @respVal = @responserecord[0].Text_Long_Response__c
                @respId = @responserecord[0].Id

                @responserecord.each do |r|
                    @resphash[r.Line_Item__c] = r
                end

            end



        end

    elsif @line_item.Line_Item_Type__c == 'Content'
        #replace :state => :comment
    end

    render
  end

  def comment
    render
  end

  def text
    render
  end

  def selectmultiple
    render
  end

  def selectone_list
    render
  end

  def selectone_dropdown
    render
  end

end
