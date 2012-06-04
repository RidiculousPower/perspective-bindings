
require 'uri'

require 'accessor-utilities'

#require 'cascading-configuration'

$__cascading_configuration__spec__development = true
require_relative '../../../ruby/cascading-configuration/lib/cascading-configuration.rb'

require_relative '../../configuration/lib/magnets-configuration.rb'

module ::Magnets::Bindings
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
		class MultiContainerProxy < ::BasicObject
	  end
		module ObjectInstance
		  module Nested
	    end
		end
	end
	module Attributes
  end
	module Exception
  end
end

basepath = 'magnets-bindings/Magnets/Bindings'

files = [

  'Configuration/BindingInstance',
  'Configuration',
  
  'ClassBinding/Bindings',
  'ClassBinding/Configuration',
  'ClassBinding/Initialization',
  'ClassBinding',

  'InstanceBinding/Bindings',
  'InstanceBinding/Configuration',
  'InstanceBinding/Initialization',
  'InstanceBinding/Validation',
  'InstanceBinding/Value',
  'InstanceBinding',
  
  'AttributeDefinitionModule',
  
  'AttributeContainer',

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
  
  'Container/MultiContainerProxy/Interface',
  'Container/MultiContainerProxy',
  'Container/Context',
  'Container/BindingMethods',
  'Container/BindingMethods/InstanceBindingMethods',
  'Container/ClassInstance',
  'Container/ObjectInstance',
  'Container',
  
  'ParseBindingDeclarationArgs',

  'Exception/BindingAlreadyDefinedError',
  'Exception/BindingNameExpected',

  'Exception/BindingInstanceInvalidTypeError',
  'Exception/BindingRequired',
  'Exception/BindingOrderEmpty',
  'Exception/NoBindingError',
  'Exception/ContainerClassLacksBindings',
  'Exception/AutobindFailed'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end

require_relative( basepath + '.rb' )
