
require 'uri'

require 'accessor-utilities'

require 'cascading-configuration'

require_relative '../../configuration/lib/magnets-configuration.rb'

module ::Magnets
	module Bindings
	  module Configuration
    end
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
		module Attributes
	  end
		module Exception
	  end
	end
end

basepath = 'magnets-bindings/Magnets/Bindings'

files = [

  'Attributes/Multiple',
  'Attributes/Class',
  'Attributes/Complex',
  'Attributes/File',
  'Attributes/Float',
  'Attributes/Integer',
  'Attributes/Module',
  'Attributes/Rational',
  'Attributes/Regexp',
  'Attributes/Text',
  'Attributes/TrueFalse',
  'Attributes/URI',
  'Attributes/Number',
  'Attributes/Binding',

  'Attributes',
      
  'Configuration/BindingInstance',
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
  
  'Exception/BindingAlreadyDefinedError',
  'Exception/BindingNameExpected',

  'Exception/BindingInstanceInvalidTypeError',
  'Exception/BindingRequired',
  'Exception/BindingOrderEmpty',
  'Exception/NoBindingError',
  'Exception/ContainerClassLacksBindings',
  'Exception/AutobindFailed',  
  
  'Container/Attributes',
  'Container/MultipleContainerProxy',
  'Container/Context',
  'Container/BindingMethods',
  'Container/BindingMethods/InstanceBindingMethods',
  'Container/ClassInstance',
  'Container/ObjectInstance',
  'Container',
  
  'ParseBindingDeclarationArgs',
  
  'Types'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
