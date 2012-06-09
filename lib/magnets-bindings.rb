
require 'uri'

require 'accessor-utilities'

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
		end
	end
	module Attributes
  end
	module Exception
  end
end

basepath = 'magnets-bindings/Magnets/Bindings'

files = [
  
  'Container/Context',

  'Constants',

  'Configuration/BindingInstance',
  'Configuration',
  
  'ClassBinding/Interface',
  'ClassBinding/NestedClassBinding',
  'ClassBinding',

  'InstanceBinding/Interface',
  'InstanceBinding/NestedInstanceBinding',
  'InstanceBinding',
  
  'AttributeDefinitionModule',
  
  'AttributeContainer',

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
  'Container/BindingMethods',
  'Container/BindingMethods/InstanceBindingMethods',
  'Container/ClassAndObjectInstance',
  'Container/ClassInstance',
  'Container/ObjectInstance',
  'Container',
  
  'ParseBindingDeclarationArgs',

  'Exception/BindingAlreadyDefined',
  'Exception/BindingNameExpected',

  'Exception/NoBindingContext',
  'Exception/BindingInstanceInvalidType',
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
