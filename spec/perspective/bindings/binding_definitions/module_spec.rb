
require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'module.rb'

describe ::Perspective::Bindings::BindingDefinitions::Module do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::Module }
  
  it_behaves_like :module_container_binding
  
end
