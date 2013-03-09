# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'complex.rb'

describe ::Perspective::Bindings::InstanceBindings::Complex do
  
  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::InstanceBindings::Complex }
  
  it_behaves_like :complex_container_binding
  
end
