# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'class.rb'

describe ::Perspective::Bindings::InstanceBindings::Class do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::InstanceBindings::Class }
  
  it_behaves_like :class_container_binding

end
