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
							'Text_Long_Response__c' => (value != nil || value != '') ? value : nil,
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
				@resp_value = @resp_value.to_a
				if @resp_value[0] != '' || @resp_value[0] != nil 
					@resp_value.each do |rv|
						if rv != ''
							@rval = @rval + rv + ';'
						end
					end
				end
				Sanitize.clean(@rval)
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
		puts "^^^^^^^^^^^^^^^^^^^^ params = '#{params.inspect}' "
		@hash_response = {}
		@invite_id = params[:id]
		@survey_id = current_survey[0].Survey__c
		@current_page = params[:page] ? params[:page] : 1
		@autosave = params[:as] ? params[:as] : false

		params.each do |key, value|
			@var = key.index('qq') 	
			if key.index('qq') != nil
				if key.index('qq') >= 0
					@array = key.split('_')
					@qid = @array[1]

					if @array[2] == 'multi'
						@v = ''
						puts "(((((((((((((( multi string = '#{value}', array = '#{value.index('[')}', key = '#{key}' "
						if value != ''|| value != nil
							value.each do |id|
								if params[id] != nil
									@v += params[id] + ';'
								end
							end
						end

						puts "---------------------- @v = '#{@v}' "

						@robj = Response.new(@survey_id, @invite_id, @array[1], params[@qid], value, @array[2], @array[3], @v, key, session[:user_id])
					else
						@robj = Response.new(@survey_id, @invite_id, @array[1], params[@qid], value, @array[2], @array[3], params[value], key, session[:user_id])
					end

					@hash_response[@array[1]] ? @hash_response[@array[1]] << @robj : @hash_response[@array[1]] = [@robj]
				end
			end
		end

		@error = Array.new
		@hash_response.each_pair do |key, val|
			val.each do |o|
				@vr = validate_response(o)
				if @vr != nil
					@error << @vr
				end
			end
		end

		puts "ajax error = '#{@error.to_json}' "

		puts " --------------------------- @autosave = '#{@autosave}' "

		@wt = Array.new
		@hash_response.each_pair do |k,v|
			v.each do |obj|
				puts "******************* obj = '#{obj}' "
				@sr = save_response(obj)
				@wt << @sr
			end
		end

		#this updates invitation
		puts "------------------ update_multiple, update invitation status ------------------"
		session[:client].upsert('Invitation__c','Id', @invite_id, { 'Progress_Save__c' => Sanitize.clean(@current_page), 'Status__c' => 'In Progress' })

		
		respond_to do |format|
			if @error.empty? || @autosave
				format.json { render :json => @wt.to_json }		
			else
				format.json { render :json => @error.to_json, :status => :unprocessable_entity }
			end
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
		
		if @@current_survey.to_s == '[]'
			raise Exceptions::SurveyNotAvailable.new("The survey you are looking for is currently not available.")
		else
			return @@current_survey
		end
	end

	def save_response(respObj)
		puts "---------------- save_response -------------------"
		
		@id = false
		if respObj.rid == '' || respObj.rid == nil
			@id = false
		else
			@id = true
		end

		if @id
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

	def validate_response(rObj)
		puts "validate response = '#{rObj.type}', value = '#{rObj.value}' "
		if rObj.value == nil || rObj.value == ''
			if rObj.type == 'onedd'
				return { :msg => 'Please select an option', :id => rObj.key }
			
			elsif rObj.type == 'multi'
				puts "multi = '#{rObj.value}', rObj.key = '#{rObj.key}' "
				return { :msg => 'Please select at least one option', :id => rObj.key }
			else
				return { :msg => 'Please enter a value', :id => rObj.key }
			end

		elsif rObj.type == 'integer'
			val = rObj.value.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
			if val == false
				return { :msg => 'Number contains invalid characters', :id => rObj.key }
			end
			return
		elsif rObj.type == 'date'
			val = rObj.value.match(/\A(?:0?[1-9]|1[0-2])\/(?:0?[1-9]|[1-2]\d|3[01])\/\d{4}\Z/) == nil ? false : true
			if val == false
				return { :msg => 'Not a valid date format', :id => rObj.key }
			end
		elsif rObj.type == 'radio'
			puts "$$$$$$$$$$$$$ rObj.value = '#{rObj.value}' "

		#else
		#	return { :msg => 'The error was here', :id => rObj.key }
		end

		
	end

	def autocompletequery
		puts "&&&&&&&&&&&&&&&&&&&&&&&&& autocompletequery"
		puts "&&&&&&&&&&&&&&&&&&&&&&&&& autocompletequery"
		puts "&&&&&&&&&&&&&&&&&&&&&&&&& autocompletequery"
		puts "&&&&&&&&&&&&&&&&&&&&&&&&& autocompletequery"
		
		p = session[:client].query("select Id, Name from Master_Patient__c ")

		puts "&&&&&&&&&&&&&&&&&&&&&&&&& p = '#{p.to_json}' "

		respond_to do |format|
			format.json { render :json => p.to_json }		
		end
			
	end

end
