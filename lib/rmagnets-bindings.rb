
require 'module-cluster'
require 'accessor-utilities'
require 'cascading-configuration-array'
require 'cascading-configuration-hash'

class Rmagnets
	module Bindings
		module ClassInstance
		end
		module ObjectInstance
		end
		module Exception
		  class BindingAlreadyDefinedError < ::Exception
	    end
		  class NoBindingError < ::Exception
	    end
	  end
	end
end

require_relative 'rmagnets-bindings/Rmagnets/Bindings.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ObjectInstance.rb'

require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/BindingAlreadyDefinedError.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/NoBindingError.rb'
