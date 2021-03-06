module SurveysHelper

	class Response
		attr_reader :sid, :qid, :value, :type, :update_val

		def initialize(sid, inviteId, qid, qtxt, value, type, rid, label, htmlid, uid, vlength, decimals, maxval, minval, isrequired, sclient)
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
			@vlength = vlength
			@maxval = maxval
			@minval = minval
			@decimals = decimals
			@isrequired = isrequired
			@sclient = sclient
		end

		def resp_json

			return { :Id => rid,
					:Survey__c => sid, 
					:Invitation__c => inviteid,
					:Line_Item__c => qid,
					:OwnerId => @uid,
					:Original_Question_Text__c => question,
					:Text_Long_Response__c => (value != nil || value != '') ? value : nil,
					:Label_Long_Response__c => (@resp_type == 'text') ? nil : label} 

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

			q = @sclient.query("select Id, Name, Invitation__c, Line_Item__c from Response__c where Invitation__c = '#{inviteid}' and Line_Item__c = '#{qid}' ")
			if q.empty?
				#o = session[:client].create('Response__c',respObj.resp_a)
				#return { :key => respObj.key, :id => o.Id }
				return @resp_id
			else
				#session[:client].upsert('Response__c', 'Id', q[0].Id, respObj.resp_a)
				return q[0].Id
			end

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

		def vlength
			@vlength
		end

		def maxval
			@maxval
		end

		def minval
			@minval
		end

		def decimals
			@decimals
		end

		def isrequired
			@isrequired
		end

	end

	def update_multiple
		puts "^^^^^^^^^^^^^^^^^^^^ survey_helper.rb update_multiple ^^^^^^^^^^^^^^^^^^^^"
		@hash_response = {}
		@invite_id = Sanitize.clean(params[:id] || params[:survey_id])
		@survey_id = current_survey[0].Survey__c

		#security enhancement
		@current_page = (params[:page]!= nil) ? ( params[:page].match(/^[0-9]*$/) == nil ? '1' : Sanitize.clean(params[:page]).to_i ) : '1'
		@autosave = params[:as] ? params[:as] : false

		#get line item external ids for query
		@li_eid_list = ''
		params.each do |key, value|
			@matchqs = (key.match(/^(qq)/) ) ? true : false

			if @matchqs
			#if key.index('qq') != nil
			#	if key.index('qq') >= 0
					@aeid = key.split('_')
					#line item external ids
					@li_eid_list = (@li_eid_list == '') ? ( @li_eid_list + "\'#{@aeid[1]}\'" ) : ( @li_eid_list + ", \'#{@aeid[1]}\'" )
			#	end
			#end
			end
		end
		@li_eid_list = "("+@li_eid_list+")"

		if @li_eid_list != '()'
			#query values for response and validations
			@li_details = session[:client].query("select Id, Name, Decimals__c, External_ID__c, Length__c, Max_Value__c, Min_Value__c, Required__c, Sort_Order__c, Question_Description__c from Line_Item__c where Id in #{@li_eid_list} order by Sort_Order__c asc  ")
		end
		@h_li = {}
		#if !@li_details.empty?
		if not @li_details.to_s == '[]'
            @li_details.each { |r| @h_li[r.Id] ? @h_li[r.Id] << r : @h_li[r.Id] = [r] }
        end

		params.each do |key, value|
			#@var = key.index('qq') 	
			@matchqqs = (key.match(/^(qq)/) ) ? true : false

			if @matchqqs
			#if key.index('qq') != nil
			#	if key.index('qq') >= 0
					@array = key.split('_')
					@qid = @array[1]

					if @array[2] == 'multi'
						@v = ''
						value.delete_at(0)
						if value != ''|| value != nil
							value.each do |id|
								puts "multi validations, params[id] = '#{params[id]}', @v = '#{@v}' "
								if params[id] != nil && @v.index(params[id]) == nil
									@v += params[id] + ';'
								end
							end
						end

						@robj = Response.new(@survey_id, @invite_id, @array[1], params[@qid], value, @array[2], @array[3], @v, key, session[:user_id], @h_li[@qid][0].Length__c, @h_li[@qid][0].Decimals__c, @h_li[@qid][0].Max_Value__c, @h_li[@qid][0].Min_Value__c, @h_li[@qid][0].Required__c, session[:client] )
					elsif @array[2] == 'grid'
						@robj = Response.new(@survey_id, @invite_id, @array[1], @h_li[@qid][0].Question_Description__c, value, @array[2], @array[3], params[value], key, session[:user_id], @h_li[@qid][0].Length__c, @h_li[@qid][0].Decimals__c, @h_li[@qid][0].Max_Value__c, @h_li[@qid][0].Min_Value__c, @h_li[@qid][0].Required__c, session[:client] )
					
					else
						@robj = Response.new(@survey_id, @invite_id, @array[1], params[@qid], value, @array[2], @array[3], params[value], key, session[:user_id], @h_li[@qid][0].Length__c, @h_li[@qid][0].Decimals__c, @h_li[@qid][0].Max_Value__c, @h_li[@qid][0].Min_Value__c, @h_li[@qid][0].Required__c, session[:client] )
					end

					@hash_response[@array[1]] ? @hash_response[@array[1]] << @robj : @hash_response[@array[1]] = [@robj]
			#	end
			#end
			end
		end

		@error = Array.new
		@wt = Array.new
		@responsearray = Array.new

		@hash_response.each_pair do |key, val|
			val.each do |o|
				@vr = validate_response(o)
				if @vr != nil
					@error << @vr
				else
					@responsearray << o.resp_json
					#@sr = save_response(o)
					#@wt << @sr
				end
			end
		end

		#puts "----------- responsearray = #{@responsearray.to_json}"
		@save_error = false
		@e_msg = nil
		@sfdc_error = Array.new
		begin
			results = session[:client].http_post('/services/apexrest/v1/Response/',@responsearray.to_json)
			#puts "---------- results = '#{results}' "
		rescue Exception => e
			#this catches any salesforce error
  			logger.error e.message
  			@e_msg = e.message
		ensure
			#turn error flags and save error message
			if(@e_msg != nil)
				puts "^^^^^^^^&&&&&&&&&&%%%%%%%%%%%%%%% ERROR in SFDC, '#{e}' "
				@save_error = true
				@sfdc_error << { :msg => e.message, :id => 'wuu', :sf_error => true}
			end

			#this updates invitation
			puts "------------------ update_multiple, update invitation status ------------------"
			session[:client].upsert('Invitation__c','Id', @invite_id, { 'Progress_Save__c' => @current_page, 'Status__c' => 'In Progress' })

			respond_to do |format|
				if @save_error && !@sfdc_error.empty? #this catches any salesforce error
					format.json { render :json => @sfdc_error.to_json, :status => :unprocessable_entity }
				elsif @error.empty? || @autosave
					format.json { render :json => @wt.to_json }		
				else
					format.json { render :json => @error.to_json, :status => :unprocessable_entity }
				end
			end
		end
		


	end

	def submitsurvey
		puts "^^^^^^^^^^^^^^^^^^^^ survey_helper.rb submitsurvey ^^^^^^^^^^^^^^^^^^^^"
		session[:client].upsert('Invitation__c','Id', Sanitize.clean(params[:id] || params[:survey_id]), { 'Status__c' => 'Completed'})
		redirect_to invite_index_path, :notice => "Your survey was submitted successfully."
	end

	def surveyerrors
		puts "^^^^^^^^^^^^^^^^^^^^ survey_helper.rb surveyerrors ^^^^^^^^^^^^^^^^^^^^"
	    raise Exceptions::SurveyBuildError.new("Build Error. There has been an unexpected error on the survey.")
	end

	def current_survey
	    puts "^^^^^^^^^^^^^^^^^^^^ surveys_helper.rb current_survey , survey_id = #{params[:survey_id]}, id = #{params[:id]} ^^^^^^^^^^^^^^^^^^^^"
	    @inviteid = Sanitize.clean(params[:id] || params[:survey_id])
	    if session[:user_profile] == 'Admin'
	    	@@current_survey =  session[:client].query("select Id, Name, User__c, Survey__c, Survey_Name__c, Start_Date__c, End_Date__c, Survey_Subject__c, Survey__r.Description__c from Invitation__c where Id = '#{@inviteid}' ")
		else
			@@current_survey =  session[:client].query("select Id, Name, User__c, Survey__c, Survey_Name__c, Start_Date__c, End_Date__c, Survey_Subject__c, Survey__r.Description__c from Invitation__c where Id = '#{@inviteid}' and User__c = '#{session[:user_id]}' ")
		end

		if @@current_survey.to_s == '[]'
			raise Exceptions::SurveyNotAvailable.new("The survey you are looking for is currently not available.")
		else
			return @@current_survey
		end
	end

	def validate_response(rObj)
		puts "validate response = '#{rObj.type}', value = '#{rObj.value}' "

		if (rObj.value == nil || rObj.value == '') && rObj.isrequired
			if rObj.type == 'onedd'
				return { :msg => 'Please select an option', :id => rObj.key }
			
			elsif rObj.type == 'multi'
				puts "multi = '#{rObj.value}', rObj.key = '#{rObj.key}' "
				return { :msg => 'Please select at least one option', :id => rObj.key }
			else
				return { :msg => 'Please enter a value', :id => rObj.key }
			end
		elsif (rObj.value == nil || rObj.value == '') && rObj.isrequired == false
			return
		elsif rObj.type == 'integer' || rObj.type == 'calculation'
			val = rObj.value.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true 
			l = rObj.value.length
			#custom validations
			if val == true
				num = rObj.value.split('.')
				n = num[0]
				d = num[1] != nil ? num[1] : ''
			end

			if val == false
				return { :msg => 'Number contains invalid characters', :id => rObj.key }
			elsif val == false && l > 17
				return { :msg => 'Number contains invalid characters and contains more than 17 characters', :id => rObj.key }
			elsif l > 17
				return { :msg => 'Number contains more than 17 characters', :id => rObj.key }

			else 
				if rObj.vlength.blank? == false
					if n.length.to_f > rObj.vlength.to_f
						return { :msg => 'Number value is to big', :id => rObj.key }
					end
				end

				if rObj.decimals.blank? == false
					if d.length > rObj.decimals
						return { :msg => 'You exceeded the allowed decimal values '+rObj.decimals.to_i.to_s , :id => rObj.key }
					end
				end

				if rObj.maxval.blank? == false
					if rObj.value.to_f > rObj.maxval.to_f
						return { :msg => 'Value exceeds maximum allowed, '+rObj.maxval, :id => rObj.key }
					end
				end

				if rObj.minval.blank? == false
					if rObj.value.to_f < rObj.minval.to_f
						return { :msg => 'Value is lower than the minimum expected, '+rObj.minval, :id => rObj.key }
					end
				end

			
			end
			return

		elsif rObj.type == 'date'
			val = rObj.value.match(/\A(?:0?[1-9]|1[0-2])\/(?:0?[1-9]|[1-2]\d|3[01])\/\d{4}\Z/) == nil ? false : true
			arr = rObj.value.split('/')
			if val == false
				return { :msg => 'Not a valid date format', :id => rObj.key }
			elsif arr[0].to_i > 12 || arr[0].to_i < 1
				return { :msg => 'Not a valid month', :id => rObj.key }
			elsif arr[1].to_i > 31 || arr[1].to_i < 0
				return { :msg => 'Not a valid day', :id => rObj.key }
			elsif arr[2].to_i > 4000 || arr[2].to_i < 0
				return { :msg => 'Not a valid year', :id => rObj.key }
			else

				if rObj.maxval.blank? == false
					myval = Date.strptime(rObj.value, '%m/%d/%Y')
					sysval = Date.strptime(rObj.maxval, '%m/%d/%Y')
					if myval > sysval
						return { :msg => 'Date value exceeds maximum allowed, '+rObj.maxval, :id => rObj.key }
					end
				end

				if rObj.minval.blank? == false
					myval = Date.strptime(rObj.value, '%m/%d/%Y')
					sysval = Date.strptime(rObj.minval, '%m/%d/%Y')
					if myval < sysval
						return { :msg => 'Date value is lower than the minimum expected, '+rObj.minval, :id => rObj.key }
					end
				end

			end
		elsif rObj.type == 'radio'

		elsif rObj.type == 'text'
			l = rObj.value.length
			#val = rObj.value.match(/^\s*([0-9a-zA-Z]*)\s*$/) == nil ? false : true
			puts "----------- text length = '#{l}' "
			if l > 1000
				return { :msg => 'The text entered contains more than 1000 characters', :id => rObj.key }
			else
				if rObj.vlength.blank? == false
					if l > rObj.vlength.to_f
						return { :msg => 'The text entered contains more than '+rObj.vlength.to_i.to_s+' characters', :id => rObj.key }
					end
				end
			end
			return
		end

		
	end

	def autocompletequery
		puts "&&&&&&&&&&&&&&&&&&&&&&&&& autocompletequery"
		p = session[:client].query("select Id, Name from Master_Patient__c ")
		@json = Array.new
		p.each do |n|
			@json<< {:display_name => n.Name, :Id => n.Id}
		end

		respond_to do |format|	
			format.json { render :json => {:items => @json} }
		end
			
	end

end
