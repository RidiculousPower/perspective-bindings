
#-----------------------------------------------------------------------------------------------------------#
#-------------------------------------------  Rmagnets Bindings  -------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::Bindings
	
	###################
	#  self.included  #
	###################

	def self.included( class_or_module )

		class_or_module.instance_eval do
			include Rmagnets::Bindings::ObjectInstance
			extend 	Rmagnets::Bindings::ClassInstance
		end
		
	end

end
