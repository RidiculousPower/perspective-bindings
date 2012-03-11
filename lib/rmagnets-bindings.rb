
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
      module Bindings
        module Methods
          module Declare
          end
          module Alias
          end
          module Binding
          end
          module Remove
          end
          module SharedBinding
          end
        end
        module Binding
        end
        module Class
        end
        module Complex
        end
        module File
        end
        module Float
        end
        module Integer
        end
        module Module
        end
        module Number
        end
        module Rational
        end
        module Regexp
        end
        module Text
        end
        module TrueFalse
        end
        module View
        end
      end
		end
		module ObjectInstance
		end
		module Exception
		  class BindingAlreadyDefinedError < ::ArgumentError
	    end
	    class BindingOrderAlreadyIncludesBinding < ::ArgumentError
      end
	    class BindingInstanceInvalidTypeError < ::ArgumentError
      end
	    class BindingOrderEmpty < ::ArgumentError
      end
		  class NoBindingError < ::ArgumentError
	    end
		  class NumberBindingExpectsNumber < ::ArgumentError
	    end
      class BindingNameExpected < ::ArgumentError
      end
	  end
	end
end

require_relative 'rmagnets-bindings/Rmagnets/Bindings/Binding/Router.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Binding.rb'

require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Methods/Declare.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Methods/Binding.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Methods/Alias.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Methods/SharedBinding.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Methods/Remove.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Methods.rb'

require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Binding.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Class.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Complex.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/File.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Float.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Integer.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Module.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Number.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Rational.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Regexp.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Text.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/TrueFalse.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/View.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings/Mixed.rb'

require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Alias.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Bindings.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Order.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance/Rename.rb'

require_relative 'rmagnets-bindings/Rmagnets/Bindings/ClassInstance.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/ObjectInstance.rb'

require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/BindingAlreadyDefinedError.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/BindingInstanceInvalidTypeError.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/BindingNameExpected.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/BindingRequired.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/BindingOrderAlreadyIncludesBinding.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/BindingOrderEmpty.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/NoBindingError.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/NumberBindingExpectsNumber.rb'
require_relative 'rmagnets-bindings/Rmagnets/Bindings/Exception/ViewClassLacksBindings.rb'

