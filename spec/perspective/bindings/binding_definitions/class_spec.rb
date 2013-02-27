
require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'class.rb'

describe ::Perspective::Bindings::BindingDefinitions::Class do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::Class }
  
  it_behaves_like :class_container_binding

end
