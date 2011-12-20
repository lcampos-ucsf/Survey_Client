module SurveysHelper
include Databasedotcom::Rails::Controller

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
		@hash_response = {}
		@invite_id = params[:id]
		@survey_id = current_survey[0].Survey__c
		@current_page = params[:page] ? params[:page] : 1

		puts "************************************ update_multiple helper method on survey helper page no. =  '#{params[:page]}' , id = '#{@invite_id }', survey id = '#{@survey_id}', all params = '#{params.inspect}' "
		

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

		a = []

		@hash_response.each_pair do |k,v|
			v.each do |obj|
				if obj.type == 'text'
					a << Response__c.new(:Id => obj.rid, :Survey__c => obj.sid, :Invitation__c => obj.inviteid, :Line_Item__c => obj.qid, :OwnerId => ENV['sf_user'], :Original_Question_Text__c => obj.question, :Text_Long_Response__c => obj.value )
				elsif obj.type == 'radio' || obj.type == 'onedd'
					a << Response__c.new(:Id => obj.rid, :Survey__c => obj.sid, :Invitation__c => obj.inviteid, :Line_Item__c => obj.qid, :OwnerId => ENV['sf_user'], :Original_Question_Text__c => obj.question, :Text_Long_Response__c => obj.value, :Label_Long_Response__c => obj.label)
				
				elsif obj.type == 'multi'
					a << Response__c.new(:Id => obj.rid, :Survey__c => obj.sid, :Invitation__c => obj.inviteid, :Line_Item__c => obj.qid, :OwnerId => ENV['sf_user'], :Original_Question_Text__c => obj.question, :Text_Long_Response__c => obj.value, :Label_Long_Response__c => obj.label)
			
				end
			end

		end

		#this updates invitation
		invite_update = Invitation__c.find(@invite_id)
		invite_update.Progress_Save__c = @current_page
		a << invite_update

		#this line saves every record submitted
		if a.each(&:save)
			puts "********************************* update_multiple helper method, records got saved"
		end
		@hash_response.clear

	end

	def submitsurvey
		puts "********************************* submitsurvey helper method, survey got saved , invitation id = '#{params[:id]}' "

		a = Invitation__c.find(params[:id])
		a.Status__c = 'Completed'
		a.save

		redirect_to "/invite/index", :notice => "Your survey was submitted successfully."
	end

	def current_survey
	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& current_survey"
	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& current_survey"
	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& current_survey"
	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& current_survey = "
	    
	    @@current_survey ||=  Invitation__c.query("Id = '#{params[:id]}' and User__c = '#{ENV['sf_user']}' ")
	    return @@current_survey

	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& current_survey"
	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& current_survey"
	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& current_survey"
	    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& current_survey"
	    #@@exchange_rage ||= (execute your SQL query and get the result here)

	  end

end
