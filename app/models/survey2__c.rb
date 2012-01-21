
class Survey__c
	has_one :Invitation__c
		
	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	attr_accessor :Description__c, :Name, :Id

	validates_presence_of :Description__c, :message => "Survey must be provided"
	#validates_presence_of :User__c, :message => "User must be provided"
	#validates_presence_of :Start_Date__c, :message => "Start Date must be provided"
	#validates_presence_of :End_Date__c, :message => "End Date must be provided"
	#validates_length_of :Text_Survey_Subject__c, :maximum => 200, :too_long => "Concept has a limit of 200 chars"

	def initialize(attributes = {})
		if attributes
			attributes.each do |name, value|
				puts "each name = '#{name}', value = '#{value}'  " 
				send("#{name}=",value)
			end
		end
	end

	def persisted?
		false
	end
end
