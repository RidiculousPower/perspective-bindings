# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'text.rb'

describe ::Perspective::Bindings::InstanceBindings::Text do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::InstanceBindings::Text }
  
  it_behaves_like :text_container_binding
  
end
