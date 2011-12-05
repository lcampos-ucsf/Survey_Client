module SurveysHelper
include Databasedotcom::Rails::Controller

	class Response
		attr_reader :sid, :qid, :value, :type

		def initialize(sid,qid, value, type)
			@resp_sid=sid
			@resp_qid=qid
			@resp_name=value
			@resp_type=type
		end

		def sid
			@resp_sid
		end

		def qid
			@resp_qid
		end

		def value
			@resp_name
		end

		def type
			@resp_type
		end

	end

	def update_multiple
		puts "************************************ update_multiple helper method on survey helper '#{params[:page]}' , page = '#{params[:id]}', all params = '#{params.inspect}' "
		@hash_response = {}
		@survey_id = params[:id]

		params.each do |key, value|
			@var = key.index('q#') 	
			if key.index('q#') != nil
				if key.index('q#') >= 0
					@array = key.split('_')
					@robj = Response.new(@survey_id, @array[1], value, @array[2])
					
					puts "response object = '#{@robj.sid}', '#{@robj.qid}' "

					@hash_response[@array[1]] ? @hash_response[@array[1]] << @robj : @hash_response[@array[1]] = [@robj]
				end
			end
		end

		a = []

		@hash_response.each_pair do |k,v|
			puts "hash key = '#{k}', value = '#{v}' , value class = '#{v.class}' "
			v.each do |obj|
				puts "object on hash, survey id = '#{obj.sid}', q id = '#{obj.qid}', value = '#{obj.value}' "
				a << Response__c.new(:Survey__c => obj.sid, :Line_Item__c => obj.qid, :OwnerId => '005U0000000ErAJ', :Boolean_Response__c => false)
			end

		end
		#this line saves every record submitted
		if a.each(&:save)
			redirect_to("/surveys/#{params[:id]}/show?page=#{params[:page]}")
		end
	end


end
