
require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'regexp.rb'

describe ::Perspective::Bindings::BindingDefinitions::Regexp do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::Regexp }
  
  it_behaves_like :regexp_container_binding

end
