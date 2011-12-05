class Survey::SurveylistWidget < Apotomo::Widget
include Databasedotcom::Rails::Controller

  def display
  	@surveys = Survey__c.all
=begin
  	@s_query = Survey__c.all
    @surveys = Kaminari.paginate_array(@s_query).page(params[:page]).per(1) # Paginates the array
=end
    render
  end

end
