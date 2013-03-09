# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'uri.rb'

describe ::Perspective::Bindings::InstanceBindings::URI do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::InstanceBindings::URI }
  
  it_behaves_like :uri_container_binding

end
