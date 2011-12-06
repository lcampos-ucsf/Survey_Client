module SurveysHelper
include Databasedotcom::Rails::Controller

	class Response
		#attr_reader :sid, :qid, :value, :type

		def initialize(sid,qid,value, type, rid, label)
			@resp_sid = sid
			@resp_qid = qid
			@resp_value = value
			@resp_type = type
			@resp_id = rid
			@resp_label = label
			@lineitem = Line_Item__c.find( @resp_qid )
			#@resp_q = @lineitem.Question_Description__c
			@resp_q = 'qtxt'
			@resp_qresource = @lineitem.Resource__c
		end

		def sid
			@resp_sid
		end

		def qid
			@resp_qid
		end

		def value
			@resp_value
		end

		def type
			@resp_type
		end

		def question
			@resp_q
		end

		def liresource
			@resp_qresource
		end

		def rid
			@resp_id
		end

		def label
			@resp_label
		end

	end

	def update_multiple
		@fid = 'AL-00001'
		puts "************************************ update_multiple helper method on survey helper page no. =  '#{params[:page]}' , id = '#{params[:id]}', radio value = '#{params[@fid]}' all params = '#{params.inspect}' "
		@hash_response = {}
		@survey_id = params[:id]
		#@page = params[:page].to_i + 1

		params.each do |key, value|
			@var = key.index('q#') 	
			if key.index('q#') != nil
				if key.index('q#') >= 0
					@array = key.split('_')
					@qid = @array[1]
					@robj = Response.new(@survey_id, @array[1], value, @array[2], @array[3], params[value])
					
					puts "response object = '#{@robj.sid}', '#{@robj.qid}' "
					@hash_response[@array[1]] ? @hash_response[@array[1]] << @robj : @hash_response[@array[1]] = [@robj]
				end
			end
		end

		a = []

		@hash_response.each_pair do |k,v|
			v.each do |obj|
				if obj.type == 'text'
					
					if obj.rid != nil
						a << Response__c.new(:Id => obj.rid, :Survey__c => obj.sid, :Line_Item__c => obj.qid, :OwnerId => '005U0000000ErAJ', :Original_Question_Text__c => obj.question, :Text_Long_Response__c => obj.value, :Line_Item_Resource__c => obj.liresource)
					else
						a << Response__c.new(:Survey__c => obj.sid, :Line_Item__c => obj.qid, :OwnerId => '005U0000000ErAJ', :Original_Question_Text__c => obj.question, :Text_Long_Response__c => obj.value, :Line_Item_Resource__c => obj.liresource)
					end

				elsif obj.type == 'radio'
					
					
						a << Response__c.new(:Id => obj.rid, :Survey__c => obj.sid, :Line_Item__c => obj.qid, :OwnerId => '005U0000000ErAJ', :Original_Question_Text__c => obj.question, :Text_Long_Response__c => obj.value, :Line_Item_Resource__c => obj.liresource, :Label_Long_Response__c => obj.label)
					
				end


			end

		end
		#this line saves every record submitted
		if a.each(&:save)
			puts "********************************* update_multiple helper method, records got saved"
			#redirect_to("/surveys/#{params[:id]}/show?page=#{params[:page]}")
		end
	end


end
