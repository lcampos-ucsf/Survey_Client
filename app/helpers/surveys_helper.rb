module SurveysHelper
include Databasedotcom::Rails::Controller

	class Response
		attr_reader :sid, :qid, :value, :type, :update_val

		def initialize(sid, qid, qtxt, value, type, rid, label)
			@resp_sid = sid
			@resp_qid = qid
			@resp_value = value
			@resp_type = type
			@resp_id = rid
			@resp_label = label
			@resp_q = qtxt

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

	end

	def update_multiple
		puts "************************************ update_multiple helper method on survey helper page no. =  '#{params[:page]}' , id = '#{params[:id]}', radio value = '#{params[@fid]}' all params = '#{params.inspect}' "
		@hash_response = {}
		@survey_id = params[:id]

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

						@robj = Response.new(@survey_id, @array[1], params[@qid], value, @array[2], @array[3], @v)
					else
						@robj = Response.new(@survey_id, @array[1], params[@qid], value, @array[2], @array[3], params[value])
					end

					@hash_response[@array[1]] ? @hash_response[@array[1]] << @robj : @hash_response[@array[1]] = [@robj]
				end
			end
		end

		a = []

		@hash_response.each_pair do |k,v|
			v.each do |obj|
				if obj.type == 'text'
					a << Response__c.new(:Id => obj.rid, :Survey__c => obj.sid, :Line_Item__c => obj.qid, :OwnerId => ENV['sf_user'], :Original_Question_Text__c => obj.question, :Text_Long_Response__c => obj.value )
				elsif obj.type == 'radio' || obj.type == 'onedd'
					a << Response__c.new(:Id => obj.rid, :Survey__c => obj.sid, :Line_Item__c => obj.qid, :OwnerId => ENV['sf_user'], :Original_Question_Text__c => obj.question, :Text_Long_Response__c => obj.value, :Label_Long_Response__c => obj.label)
				
				elsif obj.type == 'multi'
					a << Response__c.new(:Id => obj.rid, :Survey__c => obj.sid, :Line_Item__c => obj.qid, :OwnerId => ENV['sf_user'], :Original_Question_Text__c => obj.question, :Text_Long_Response__c => obj.value, :Label_Long_Response__c => obj.label)
			
				end


			end

		end
		#this line saves every record submitted
		if a.each(&:save)
			puts "********************************* update_multiple helper method, records got saved"
		end
		@hash_response.clear
	end

	def submitsurvey
		puts "********************************* submitsurvey helper method, survey got saved, survey id = '#{params[:id]}' , invitation id = '#{current_invitation}' "


		redirect_to("/surveys/index")

		#@invite = Invitation__c.query("Survey__c = '' and User__c = '005U0000000ErAJ'  " )

	end

end
