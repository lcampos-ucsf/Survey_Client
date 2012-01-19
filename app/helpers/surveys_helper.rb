module SurveysHelper

	class Response
		attr_reader :sid, :qid, :value, :type, :update_val

		def initialize(sid, inviteId, qid, qtxt, value, type, rid, label, htmlid, uid)
			@resp_sid = sid
			@resp_qid = qid
			@resp_value = value
			@resp_type = type
			@resp_id = rid
			@resp_label = label
			@resp_q = qtxt
			@resp_iid = inviteId
			@key = htmlid
			@uid = uid

		end

		def resp_a
			@respArray = {'Survey__c' => sid, 
							'Invitation__c' => inviteid, 
							'Line_Item__c' => qid, 
							'OwnerId' => @uid,
							'Original_Question_Text__c' => question, 
							'Text_Long_Response__c' => value,
							'Label_Long_Response__c' => (@resp_type == 'text') ? nil : label, 
							'Date_Response__c' => (@resp_type == 'date') ? (Date.strptime(value, "%m/%d/%Y").to_datetime() unless value == '') : nil,
							'DateTime_Response__c' => (@resp_type == 'datetime') ? (Date.strptime(value, "%m/%d/%Y").to_datetime() unless value == '') : nil,
							'Integer_Response__c' => (@resp_type == 'integer') ? value.to_i : nil }
		end

		def sid
			Sanitize.clean(@resp_sid)
		end

		def qid
			Sanitize.clean(@resp_qid)
		end

		def value
			if @resp_type == 'multi'
				@rval = ''
				@resp_value.each do |rv|
					@rval = @rval + rv + ';'
				end
				@rval
			else
				Sanitize.clean(@resp_value)
			end
		end

		def type
			Sanitize.clean(@resp_type)
		end

		def question
			Sanitize.clean(@resp_q)
		end

		def rid
			Sanitize.clean(@resp_id)
		end

		def label
			Sanitize.clean(@resp_label)
		end

		def inviteid
			Sanitize.clean(@resp_iid)
		end

		def key
			Sanitize.clean(@key)
		end

	end

	def update_multiple
		puts "^^^^^^^^^^^^^^^^^^^^ survey_helper.rb update_multiple ^^^^^^^^^^^^^^^^^^^^"
		@hash_response = {}
		@invite_id = params[:id]
		@survey_id = current_survey[0].Survey__c
		@current_page = params[:page] ? params[:page] : 1

		params.each do |key, value|
			@var = key.index('qq') 	
			if key.index('qq') != nil
				if key.index('qq') >= 0
					@array = key.split('_')
					@qid = @array[1]

					if @array[2] == 'multi'
						@v = ''
						value.each do |id|
							@v += params[id] + ';'
						end

						@robj = Response.new(@survey_id, @invite_id, @array[1], params[@qid], value, @array[2], @array[3], @v, key, session[:user_id])
					else
						@robj = Response.new(@survey_id, @invite_id, @array[1], params[@qid], value, @array[2], @array[3], params[value], key, session[:user_id])
					end

					@hash_response[@array[1]] ? @hash_response[@array[1]] << @robj : @hash_response[@array[1]] = [@robj]
				end
			end
		end

		@wt = Array.new
		@hash_response.each_pair do |k,v|
			v.each do |obj|
				@sr = save_response(obj)
				@wt << @sr
			end

		end

		#this updates invitation
		puts "------------------ update_multiple, update invitation status ------------------"
		session[:client].upsert('Invitation__c','Id', @invite_id, { 'Progress_Save__c' => Sanitize.clean(@current_page), 'Status__c' => 'In Progress' })

		respond_to do |format|
			format.json { render :json => @wt.to_json }		
		end

	end

	def submitsurvey
		puts "^^^^^^^^^^^^^^^^^^^^ survey_helper.rb submitsurvey ^^^^^^^^^^^^^^^^^^^^"
		session[:client].upsert('Invitation__c','Id', params[:id], { 'Status__c' => 'Completed'})
		redirect_to "/invite/index", :notice => "Your survey was submitted successfully."
	end

	def surveyerrors
		puts "^^^^^^^^^^^^^^^^^^^^ survey_helper.rb surveyerrors ^^^^^^^^^^^^^^^^^^^^"
	    raise Exceptions::SurveyBuildError.new("Build Error. There has been an unexpected error on the survey.")
	end

	def current_survey
	    puts "^^^^^^^^^^^^^^^^^^^^ surveys_helper.rb current_survey ^^^^^^^^^^^^^^^^^^^^"
	    @@current_survey =  session[:client].query("select Id, Name, User__c, Survey__c, Survey_Name__c, Start_Date__c, End_Date__c, Survey_Subject__c, Survey__r.Description__c from Invitation__c where Id = '#{params[:id]}' and User__c = '#{session[:user_id]}' ")
		puts "^^^^^^^^^^^^^^^^^^^^ surveys_helper.rb current_survey = '#{@@current_survey}' ^^^^^^^^^^^^^^^^^^^^"

		if @@current_survey.to_s == '[]'
			raise Exceptions::SurveyNotAvailable.new("The survey you are looking for is currently not available.")
		else
			return @@current_survey
		end
	end

	def save_response(respObj)
		puts "---------------- save_response -------------------"
		if respObj.rid != nil
			session[:client].upsert('Response__c','Id', respObj.rid, respObj.resp_a)
		else
			q = session[:client].query("select Id, Name, Invitation__c, Line_Item__c from Response__c where Invitation__c = '#{respObj.inviteid}' and Line_Item__c = '#{respObj.qid}' ")
			if q.empty?
				o = session[:client].create('Response__c',respObj.resp_a)
				return { :key => respObj.key, :id => o.Id }
				
			else
				session[:client].upsert('Response__c', 'Id', q[0].Id, respObj.resp_a)
				return { :key => respObj.key, :id => q[0].Id }
			end
		end

		return
	end

end
