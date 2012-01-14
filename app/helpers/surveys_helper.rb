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

		def key
			@key
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
				
				#if obj.type == 'text'
					@sr = save_response(obj)

					puts "--------- text test, obj = '#{obj}', save_response = '#{@sr}' "
					@wt << @sr
=begin					
					if obj.rid != nil					
						session[:client].upsert('Response__c','Id', obj.rid, {
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value })

					#	save_response(obj)
					else
						q = session[:client].query("select id, Name, Invitation__c, Line_Item__c from Response__c where Invitation__c = '#{obj.inviteid}' and Line_Item__c = '#{obj.qid}' ")
						puts "----------query q = '#{q}' "
						if q.empty?
							o = session[:client].create('Response__c',{
								'Survey__c' => obj.sid, 
								'Invitation__c' => obj.inviteid, 
								'Line_Item__c' => obj.qid, 
								'OwnerId' => session[:user_id], 
								'Original_Question_Text__c' => obj.question, 
								'Text_Long_Response__c' => obj.value })
							
							puts "-----------------create text record and get id back, id = '#{o.Id}' "
							@wt << { :key => obj.key, :id => o.Id }
							
						else
							puts "----------query q[0].id = '#{q[0].id}' "
							o = session[:client].upsert('Response__c', 'Id', q[0].id, {
								'Survey__c' => obj.sid, 
								'Invitation__c' => obj.inviteid, 
								'Line_Item__c' => obj.qid, 
								'Original_Question_Text__c' => obj.question, 
								'Text_Long_Response__c' => obj.value })
							
							puts "-----------------create text record and get id back, id = '#{o.Id}' "
							@wt << { :key => obj.key, :id => o.Id }
						end
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
						o = session[:client].create('Response__c',{
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label })

						puts "-----------------create radio record and get id back, id = '#{o.Id}' "
						@wt << { :key => obj.key, :id => o.Id }
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
						o = session[:client].create('Response__c',{ 
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label })

						puts "-----------------create multi record and get id back, id = '#{o.Id}' "
						@wt << { :key => obj.key, :id => o.Id }
					end
				
				elsif obj.type == 'date'
					puts "------------------ date value = '#{obj.value}' "
					if obj.rid != nil
						session[:client].upsert('Response__c','Id', obj.rid, {
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label,
							'Date_Response__c' => (Date.strptime(obj.value, "%m/%d/%Y").to_datetime() unless obj.value == '')})
					else
						o = session[:client].create('Response__c',{
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label,
							'Date_Response__c' => (Date.strptime(obj.value, "%m/%d/%Y").to_datetime() unless obj.value == '')})

						puts "-----------------create date record and get id back, id = '#{o.Id}' "
						@wt << { :key => obj.key, :id => o.Id }
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
						o = session[:client].create('Response__c', { 
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label,
							'DateTime_Response__c' => Date.strptime(obj.value, "%m/%d/%Y").to_datetime() })

						puts "-----------------create radio record and get id back, id = '#{o.Id}' "
						@wt << { :key => obj.key, :id => o.Id }
					end

				elsif obj.type == 'integer'
					if obj.rid != nil
						session[:client].upsert('Response__c','Id', obj.rid, { 
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label,
							'Integer_Response__c' => obj.value.to_i })
					else
						o = session[:client].create('Response__c', { 
							'Survey__c' => obj.sid, 
							'Invitation__c' => obj.inviteid, 
							'Line_Item__c' => obj.qid, 
							'OwnerId' => session[:user_id], 
							'Original_Question_Text__c' => obj.question, 
							'Text_Long_Response__c' => obj.value, 
							'Label_Long_Response__c' => obj.label,
							'Integer_Response__c' => obj.value.to_i })

						puts "-----------------create radio record and get id back, id = '#{o.Id}' "
						@wt << { :key => obj.key, :id => o.Id }
					end
			
				end
=end
			end

		end

		#this updates invitation
		puts "------------------ update_multiple, update invitation status ------------------"
		session[:client].upsert('Invitation__c','Id', @invite_id, { 'Progress_Save__c' => @current_page, 'Status__c' => 'In Progress' })

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
	    raise SurveysController.new('el error')
	end

	def current_survey
	    puts "^^^^^^^^^^^^^^^^^^^^ surveys_helper.rb current_survey ^^^^^^^^^^^^^^^^^^^^"
	    @@current_survey =  session[:client].query("select Id, Name, User__c, Survey__c, Survey_Name__c, Start_Date__c, End_Date__c, Survey_Subject__c from Invitation__c where Id = '#{params[:id]}' and User__c = '#{session[:user_id]}' ")
		return @@current_survey
	end

	def save_response(respObj)
		puts "---------------- save_response -------------------"
		if respObj.rid != nil
			puts "---------------- save_response , respObj.rid != nil -------------------"
			puts "---------------- save_response , respObj.resp_a = '#{respObj.resp_a}' -------------------"

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
