
require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'uri.rb'

describe ::Perspective::Bindings::BindingDefinitions::URI do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::URI }
  
  it_behaves_like :uri_container_binding

end
