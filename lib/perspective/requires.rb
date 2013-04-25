# -*- encoding : utf-8 -*-

require 'uri'
require 'forwardable'
require 'accessor_utilities'
require 'reraise'
require 'singleton_attr'

[
  
  '../../lib_ext/module',
  '../../lib_ext/class',
  '../../lib_ext/object',
  
  'bindings/include_extend',
  'bindings/include_extend/initialize_instances',
  
  'bindings/container/context',

  'bindings/constants',

  'bindings/configuration/object_and_binding_instance',
  'bindings/configuration/singleton_and_class_binding_instance',
  'bindings/configuration',

  'bindings/binding',
  'bindings/class_binding',
  'bindings/instance_binding',
  
  'bindings/binding_type_container/binding_base/class_binding',
  'bindings/binding_type_container/binding_base/instance_binding',
  'bindings/binding_type_container/binding_base',
  'bindings/binding_type_container/binding_type/binding_class',
  'bindings/binding_type_container/binding_type/class_binding_class',
  'bindings/binding_type_container/binding_type/instance_binding_class',
  'bindings/binding_type_container/binding_type',
  'bindings/binding_type_container/types_controller',
  'bindings/binding_type_container',

  'binding_types',

  'bindings/instance_bindings/class',
  'bindings/instance_bindings/complex',
  'bindings/instance_bindings/file',
  'bindings/instance_bindings/float',
  'bindings/instance_bindings/integer',
  'bindings/instance_bindings/module',
  'bindings/instance_bindings/rational',
  'bindings/instance_bindings/regexp',
  'bindings/instance_bindings/text',
  'bindings/instance_bindings/true_false',
  'bindings/instance_bindings/uri',
  'bindings/instance_bindings/number',
  'bindings/instance_bindings/binding',
  
  'binding_types/property',
  'binding_types/property_bindings',
  'binding_types/property_bindings/class_binding',
  'binding_types/property_bindings/instance_binding',
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

  'bindings/container/configuration',
  'bindings/container/object_and_binding_instance',

  'binding_types/container',
  'binding_types/container_bindings',
  'binding_types/container_bindings/types_controller',
  'binding_types/container_bindings/class_binding',
  'binding_types/container_bindings/instance_binding',
  
  'bindings/container/binding_methods',
  'bindings/container/binding_methods/class_binding_methods',
  'bindings/container/binding_methods/instance_binding_methods',
  'bindings/container/singleton_and_object_instance',
  'bindings/container/singleton_instance',
  'bindings/container/class_instance',
  'bindings/container/object_instance',
  'bindings/container',
  
  'bindings/exception/binding_already_defined',
  'bindings/exception/binding_name_expected',
  'bindings/exception/no_binding_context',
  'bindings/exception/binding_instance_invalid_type',
  'bindings/exception/binding_required',
  'bindings/exception/binding_order_empty',
  'bindings/exception/no_binding_error',
  'bindings/exception/container_class_lacks_bindings',
  'bindings/exception/autobind_failed',

  'bindings/reference_binding'
  
].each { |this_file| require_relative( this_file << '.rb' ) }
