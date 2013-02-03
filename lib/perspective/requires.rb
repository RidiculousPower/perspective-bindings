
require 'uri'
require 'forwardable'
require 'accessor_utilities'
require 'reraise'
require 'singleton_attr'

basepath = 'bindings'

files = [
  
  'include_extend',
  'include_extend/initialize_instances',
  
  'container/context',

  'constants',

  'configuration/object_and_binding_instance',
  'configuration',

  'binding_base',
  'binding_base/class_binding',
  'binding_base/instance_binding',
  
  'binding_type_container/binding_base/class_binding_base',
  'binding_type_container/binding_base/instance_binding_base',
  'binding_type_container/binding_base',
  'binding_type_container/binding_type/binding_class',
  'binding_type_container/binding_type/class_binding_class',
  'binding_type_container/binding_type/instance_binding_class',
  'binding_type_container/binding_type',
  'binding_type_container/types_controller',
  'binding_type_container',

  'binding_types',

  'binding_definitions/class',
  'binding_definitions/complex',
  'binding_definitions/file',
  'binding_definitions/float',
  'binding_definitions/integer',
  'binding_definitions/module',
  'binding_definitions/rational',
  'binding_definitions/regexp',
  'binding_definitions/text',
  'binding_definitions/true_false',
  'binding_definitions/uri',
  'binding_definitions/number',
  'binding_definitions/binding',

  'binding_types/property_bindings',
  'binding_types/property_bindings/binding/instance_binding',
  'binding_types/property_bindings/class/instance_binding',
  'binding_types/property_bindings/complex/instance_binding',
  'binding_types/property_bindings/file/instance_binding',
  'binding_types/property_bindings/float/instance_binding',
  'binding_types/property_bindings/integer/instance_binding',
  'binding_types/property_bindings/module/instance_binding',
  'binding_types/property_bindings/number/instance_binding',
  'binding_types/property_bindings/rational/instance_binding',
  'binding_types/property_bindings/regexp/instance_binding',
  'binding_types/property_bindings/text/instance_binding',
  'binding_types/property_bindings/text_or_number/instance_binding',
  'binding_types/property_bindings/true_false/instance_binding',
  'binding_types/property_bindings/uri/instance_binding',
  
  'container/multi_container_proxy/multi_container_proxy_interface',
  'container/multi_container_proxy',
  'container/binding_methods',
  'container/binding_methods/instance_binding_methods',
  'container/class_and_object_instance',
  'container/class_instance',
  'container/object_instance',
  'container',
  
  'exception/binding_already_defined',
  'exception/binding_name_expected',
  'exception/no_binding_context',
  'exception/binding_instance_invalid_type',
  'exception/binding_required',
  'exception/binding_order_empty',
  'exception/no_binding_error',
  'exception/container_class_lacks_bindings',
  'exception/autobind_failed',

  'reference_binding'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end
