# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'float.rb'

describe ::Perspective::Bindings::InstanceBindings::Float do
  
  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::InstanceBindings::Float }
  
  it_behaves_like :float_container_binding
  
end
