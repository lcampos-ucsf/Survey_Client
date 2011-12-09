class Survey::SurveylistWidget < Apotomo::Widget
include Databasedotcom::Rails::Controller

  def display
  	#@surveys = Survey__c.all
  	@invites = Invitation__c.query("User__c = '#{ENV['sf_user']}' and Status__c = 'In Progress' order by LastModifiedDate desc ")

  	puts "invites = '#{@invites}' "
=begin
  	@s_query = Survey__c.all
    @surveys = Kaminari.paginate_array(@s_query).page(params[:page]).per(1) # Paginates the array
=end
    render
  end

end
