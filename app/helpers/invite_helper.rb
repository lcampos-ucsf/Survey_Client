module InviteHelper

  def stats_data
	puts "------------------ stats_data, id = #{params[:id]}"
	puts "------------------ stats_data, id = #{params[:id]}"
	puts "------------------ stats_data, id = #{params[:id]}"
	puts "------------------ stats_data, id = #{params[:id]}"

	@res = session[:client].query("select Id, Name, Status__c, Survey__c from Invitation__c where Survey__c = '#{params[:id]}' ")
	@rcomplete = session[:client].query("select Id, Name, Status__c, Survey__c from Invitation__c where Status__c = 'Completed' and Survey__c = '#{params[:id]}' ")
	@rcancelled = session[:client].query("select Id, Name, Status__c, Survey__c from Invitation__c where Status__c = 'Cancelled' and Survey__c = '#{params[:id]}' ")
	@rinprogress = session[:client].query("select Id, Name, Status__c, Survey__c from Invitation__c where Status__c = 'In Progress' and Survey__c = '#{params[:id]}' ")
	@rnew = session[:client].query("select Id, Name, Status__c, Survey__c from Invitation__c where Status__c = 'New' and Survey__c = '#{params[:id]}' ")

	# @resArray << { :msg => , :id =>  }

	results = session[:client].http_get('/services/apexrest/v1/Survey/Statistics/'+params[:id])
	puts "---------- results = '#{results.body}' "


	@r = Array.new
	@r << { :complete_i => @rcomplete.count, :inprogress => @rinprogress.count, :new_i => @rnew.count, :cancelled_i => @rcancelled.count, :total => @res.count }

	puts "------------------ stats_data, @r = #{@r}"

	respond_to do |format|
	  format.json { render :json => @r.to_json }
	end
  end

  def survey_search
	puts "&&&&&&&&&&&&&&&&&&&&&&&&& stats_survey_search, params = #{params[:vsearch]}"

	s = session[:client].query("select Id, Name, Status__c from Survey__c where Name like '%#{params[:vsearch]}%' ")
	puts "////////////// surveys = #{s}"
	@json = Array.new

	s.each do |n|
		  @json<< {:display_name => n.Name, :Id => n.Id}
	end

	puts "------ json response = '#{@json}' "

	respond_to do |format|
		  #format.json { render :json => p.to_json }            
		  format.json { render :json => {:items => @json} }
	end
  end


end
