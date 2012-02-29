module InviteHelper

	def stats_data
      puts "------------------ stats_data, id = #{params[:id]}"
      puts "------------------ stats_data, id = #{params[:id]}"
      puts "------------------ stats_data, id = #{params[:id]}"
      puts "------------------ stats_data, id = #{params[:id]}"

      @res = session[:client].query("select Status__c, Survey__c, count(Status__c) from Survey__c group by Status__c")

      puts "------------------ stats_data, @res = #{@res}"

      @r = Array.new
      @r << { :data => 'ok'}
      
      respond_to do |format|
          format.json { render :json => @r.to_json }
      end
  end


end
