require 'active_model'

class Invitation__c
	
	belongs_to :Survey__c
	accepts_nested_attributes_for :Survey
		
	include ActiveModel::Validations
	include ActiveModel::Conversion
	extend ActiveModel::Naming

	attr_accessor :Start_Date__c, :End_Date__c, :Text_Survey_Subject__c, :User__c, :Survey_Subject__c,:Survey__c 

	validates_presence_of :Survey__c, :message => "Survey must be provided"
	validates_presence_of :User__c, :message => "User must be provided"
	validates_presence_of :Start_Date__c, :message => "Start Date must be provided"
	validates_presence_of :End_Date__c, :message => "End Date must be provided"
	validates_length_of :Text_Survey_Subject__c, :maximum => 200, :too_long => "Concept has a limit of 200 chars"


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


=begin
	def initialize(attributes = {})
	@attributes = attributes
	end

	def read_attribute_for_validation(key)
	@attributes[key]
	end	
=end

end
