# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'integer.rb'

describe ::Perspective::Bindings::BindingDefinitions::Integer do
  
  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::Integer }
  
  it_behaves_like :integer_container_binding
  
end
