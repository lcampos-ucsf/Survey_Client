module SurveysHelper

	class Response
		attr_reader :sid, :qid, :value, :type, :update_val

		def initialize(sid, inviteId, qid, qtxt, value, type, rid, label)
			@resp_sid = sid
			@resp_qid = qid
			@resp_value = value
			@resp_type = type
			@resp_id = rid
			@resp_label = label
			@resp_q = qtxt
			@resp_iid = inviteId

		end

		def sid
			@resp_sid
		end

		def qid
			@resp_qid
		end

		def value
			if @resp_type == 'multi'
				@rval = ''
				@resp_value.each do |rv|
					@rval = @rval + rv + ';'
				end
				@rval
			else
				@resp_value
			end
		end

		def type
			@resp_type
		end

		def question
			@resp_q
		end

		def rid
			@resp_id
		end

		def label
			@resp_label
		end

		def inviteid
			@resp_iid
		end

	end

	def update_multiple
		puts "^^^^^^^^^^^^^^^^^^^^ survey_helper.rb update_multiple ^^^^^^^^^^^^^^^^^^^^"
		@hash_response = {}
		@invite_id = params[:id]
		@survey_id = current_survey[0].Survey__c
		@current_page = params[:page] ? params[:page] : 1

		params.each do |key, value|
			@var = key.index('q#') 	
			if key.index('q#') != nil
				if key.index('q#') >= 0
					@array = key.split('_')
					@qid = @array[1]

					if @array[2] == 'multi'
						@v = ''
						value.each do |id|
							@v += params[id] + ';'
						end

						@robj = Response.new(@survey_id, @invite_id, @array[1], params[@qid], value, @array[2], @array[3], @v)
					else
						@robj = Response.new(@survey_id, @invite_id, @array[1], params[@qid], value, @array[2], @array[3], params[value])
					end

					@hash_response[@array[1]] ? @hash_response[@array[1]] << @robj : @hash_response[@array[1]] = [@robj]
				end
			end
		end

		@hash_response.each_pair do |k,v|
			v.each do |obj|
				
				if obj.type == 'text'
					if obj.rid != nil
						session[:client].upsert('Response__c','Id', obj.rid, {
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value })
					else
						session[:client].create('Response__c',{
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value })
					end
				
				elsif obj.type == 'radio' || obj.type == 'onedd'
					if obj.rid != nil
						session[:client].upsert('Response__c','Id', obj.rid, {
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label })
					else
						session[:client].create('Response__c',{
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label })
					end
				
				elsif obj.type == 'multi'
					if obj.rid != nil
						session[:client].upsert('Response__c','Id', obj.rid, { 
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid,  
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label })
					else
						session[:client].create('Response__c',{ 
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label })
					end
				
				elsif obj.type == 'date'
					if obj.rid != nil
						session[:client].upsert('Response__c','Id', obj.rid, {
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label,
							'Date_Response__c' => Date.strptime(obj.value, "%m/%d/%Y").to_datetime() })
					else
						session[:client].create('Response__c',{
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label,
							'Date_Response__c' => Date.strptime(obj.value, "%m/%d/%Y").to_datetime() })
					end

				elsif obj.type == 'datetime'
					if obj.rid != nil
						session[:client].upsert('Response__c','Id', obj.rid, { 
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label,
							'DateTime_Response__c' => Date.strptime(obj.value, "%m/%d/%Y").to_datetime() })
					else
						session[:client].create('Response__c', { 
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label,
							'DateTime_Response__c' => Date.strptime(obj.value, "%m/%d/%Y").to_datetime() })
					end
			
				end
			end

		end

		#this updates invitation
		puts "------------------ update_multiple, update invitation status ------------------"
		session[:client].upsert('Invitation__c','Id', @invite_id, { 'Progress_Save__c' => @current_page, 'Status__c' => 'In Progress' })

		@hash_response.clear

	end

	def submitsurvey
		puts "^^^^^^^^^^^^^^^^^^^^ survey_helper.rb submitsurvey ^^^^^^^^^^^^^^^^^^^^"
		session[:client].upsert('Invitation__c','Id', params[:id], { 'Status__c' => 'Completed'})
		redirect_to "/invite/index", :notice => "Your survey was submitted successfully."
	end

	def surveyerrors
		puts "^^^^^^^^^^^^^^^^^^^^ survey_helper.rb surveyerrors ^^^^^^^^^^^^^^^^^^^^"
	    raise SurveysController.new('el error')
	end

	def current_survey
	    puts "^^^^^^^^^^^^^^^^^^^^ surveys_helper.rb current_survey ^^^^^^^^^^^^^^^^^^^^"
	    @@current_survey =  session[:client].query("select Id, Name, User__c, Survey__c, Survey_Name__c, Start_Date__c, End_Date__c, Survey_Subject__c from Invitation__c where Id = '#{params[:id]}' and User__c = '#{session[:user_id]}' ")
		return @@current_survey
	end

end
