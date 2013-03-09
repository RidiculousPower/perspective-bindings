# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'module.rb'

describe ::Perspective::Bindings::InstanceBindings::Module do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::InstanceBindings::Module }
  
  it_behaves_like :module_container_binding
  
end
