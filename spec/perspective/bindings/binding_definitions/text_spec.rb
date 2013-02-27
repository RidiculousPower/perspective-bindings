
require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'text.rb'

describe ::Perspective::Bindings::BindingDefinitions::Text do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::Text }
  
  it_behaves_like :text_container_binding
  
end
