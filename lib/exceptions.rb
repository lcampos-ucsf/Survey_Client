module Exceptions

	class SurveyNotAvailable < StandardError
	end

	class SurveyBuildError < StandardError
	end

	class InsufficientPriviledges < StandardError
	end

	#rescue Exceptions::SurveyNotAvailable => exception
	#	redirect_to "/invite/index" #, :alert => exception.message

end
