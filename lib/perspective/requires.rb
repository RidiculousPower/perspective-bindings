
require 'uri'
require 'accessor_utilities'

basepath = 'bindings'

files = [
  
  'container/context',

  'constants',

  'configuration/object_and_binding_instance',
  'configuration/binding_instance',
  'configuration',
  
  'class_binding/class_instance',
  'class_binding/object_instance',
  'class_binding/nested_class_binding',
  'class_binding',

  'instance_binding/instance_binding_interface',
  'instance_binding/nested_instance_binding',
  'instance_binding',
  
  'attribute_definition_module',
  
  'attribute_container',

  'attributes/class',
  'attributes/complex',
  'attributes/file',
  'attributes/float',
  'attributes/integer',
  'attributes/module',
  'attributes/rational',
  'attributes/regexp',
  'attributes/text',
  'attributes/true_false',
  'attributes/uri',
  'attributes/number',
  'attributes/binding',

  'attributes',
  
  'container/multi_container_proxy/multi_container_proxy_interface',
  'container/multi_container_proxy',
  'container/binding_methods',
  'container/binding_methods/instance_binding_methods',
  'container/class_and_object_instance',
  'container/class_instance',
  'container/object_instance',
  'container',
  
  'parse_binding_declaration_args',

  'exception/binding_already_defined',
  'exception/binding_name_expected',

  'exception/no_binding_context',
  'exception/binding_instance_invalid_type',
  'exception/binding_required',
  'exception/binding_order_empty',
  'exception/no_binding_error',
  'exception/container_class_lacks_bindings',
  'exception/autobind_failed'
  
]

files.each do |this_file|
  require_relative( File.join( basepath, this_file ) + '.rb' )
end
