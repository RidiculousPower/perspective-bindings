
require 'uri'

require 'accessor-utilities'
require 'cascading-configuration-array'
require 'cascading-configuration-array-unique'
require 'cascading-configuration-hash'
require 'cascading-configuration-setting'

module ::Magnets
	module Bindings
    class Binding
      module Definition
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
        module TextOrNumber
        end
        module TrueFalse
        end
      end
		end
		module ObjectInstance
		end
		module Exception
	  end
	end
end

basepath = 'magnets-bindings/Magnets/Bindings'

files = [
  
  'BindingContext',
  
  'Binding/SubBindings',
  'Binding/Configuration',
  'Binding/Initialization',
  'Binding/Validation',
  'Binding/Rendering',
  'Binding',

  'ClassInstance/Methods/Binding',
  'ClassInstance/Methods/Alias',
  'ClassInstance/Methods/SharedBinding',
  'ClassInstance/Methods/Remove',
  'ClassInstance/Methods',

  'ClassInstance/Bindings',

  'Binding/Definition/Multiple',
  'Binding/Definition/Class',
  'Binding/Definition/Complex',
  'Binding/Definition/File',
  'Binding/Definition/Float',
  'Binding/Definition/Integer',
  'Binding/Definition/Module',
  'Binding/Definition/Rational',
  'Binding/Definition/Regexp',
  'Binding/Definition/Text',
  'Binding/Definition/TrueFalse',
  'Binding/Definition/URI',
  'Binding/Definition/Number',
  'Binding/Definition/Binding',
  'Binding/Definition',

  'ClassInstance/Alias',
  'ClassInstance/Order',
  
  'ClassInstance',
  'ObjectInstance',
  
  'Exception/BindingAlreadyDefinedError',
  'Exception/BindingInstanceInvalidTypeError',
  'Exception/BindingNameExpected',
  'Exception/BindingRequired',
  'Exception/BindingOrderAlreadyIncludesBinding',
  'Exception/BindingOrderEmpty',
  'Exception/NoBindingError',
  'Exception/NumberBindingExpectsNumber',
  'Exception/ViewClassLacksBindings'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )

# And finally define types  
require_relative( File.join( basepath, 'Types' ) )
