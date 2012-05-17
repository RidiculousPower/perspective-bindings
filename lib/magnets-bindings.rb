
require 'uri'

require 'accessor-utilities'
require 'cascading-configuration-array'
require 'cascading-configuration-array-unique'
require 'cascading-configuration-hash'
require 'cascading-configuration-setting'

module ::Magnets
	module Binding
	  class ClassBinding
    end
	  class InstanceBinding
    end
	  module Container
  		module ClassInstance
        module Methods
        end
  		end
  		module ObjectInstance
  		end
		end
		module Definition
	  end
		module Exception
	  end
	end
end

basepath = 'magnets-binding/Magnets/Binding'

files = [
    
  'Configuration',
  
  'ClassBinding/Bindings',
  'ClassBinding/Configuration',
  'ClassBinding/Initialization',
  'ClassBinding',

  'InstanceBinding/BoundInstance',
  'InstanceBinding/Configuration',
  'InstanceBinding/Initialization',
  'InstanceBinding/Validation',
  'InstanceBinding/Rendering',
  'InstanceBinding/Value',
  'InstanceBinding',

  'Definition/Multiple',
  'Definition/Class',
  'Definition/Complex',
  'Definition/File',
  'Definition/Float',
  'Definition/Integer',
  'Definition/Module',
  'Definition/Rational',
  'Definition/Regexp',
  'Definition/Text',
  'Definition/TrueFalse',
  'Definition/URI',
  'Definition/Number',
  'Definition/Binding',
  'Definition',

  'Container/ClassInstance/Methods/Binding',
  'Container/ClassInstance/Methods/Alias',
  'Container/ClassInstance/Methods/SharedBinding',
  'Container/ClassInstance/Methods/Remove',
  'Container/ClassInstance/Methods',
  'Container/ClassInstance/Bindings',
  'Container/ClassInstance/Alias',
  'Container/ClassInstance/Creation',
  'Container/ClassInstance/Order',
  'Container/ClassInstance/Unbind',  
  'Container/ClassInstance',

  'Container/ObjectInstance/Binding',
  'Container/ObjectInstance/Validation',
  'Container/ObjectInstance',
  
  'Container/Context',

  'Container',
  
  'Exception/BindingAlreadyDefinedError',
  'Exception/BindingInstanceInvalidTypeError',
  'Exception/BindingNameExpected',
  'Exception/BindingRequired',
  'Exception/BindingOrderAlreadyIncludesBinding',
  'Exception/BindingOrderEmpty',
  'Exception/NoBindingError',
  'Exception/NumberBindingExpectsNumber',
  'Exception/ViewClassLacksBindings',
  
  'Types'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
