# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'true_or_false.rb'

describe ::Perspective::Bindings::InstanceBindings::TrueFalse do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::InstanceBindings::TrueFalse }
  
  it_behaves_like :true_or_false_container_binding

end
