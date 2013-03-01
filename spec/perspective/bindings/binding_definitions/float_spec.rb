# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'float.rb'

describe ::Perspective::Bindings::BindingDefinitions::Float do
  
  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::Float }
  
  it_behaves_like :float_container_binding
  
end
