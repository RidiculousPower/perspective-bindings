
require 'accessor-utilities'
require 'cascading-configuration-array'
require 'cascading-configuration-hash'
require 'cascading-configuration-setting'

class ::Rmagnets
	module Bindings
    class Binding
      class Router
      end
    end
		module ClassInstance
		end
		module ObjectInstance
		end
		module Exception
		  class BindingAlreadyDefinedError < ::ArgumentError
	    end
		  class NoBindingError < ::ArgumentError
	    end
	  end
	end
end

require_relative 'rmagnets-bindings/Rmagnets/Bindings/Binding/Router/Instance.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Binding/Router.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Binding.rb'

require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ObjectInstance.rb'

require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/BindingAlreadyDefinedError.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/NoBindingError.rb'
