# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'number.rb'

describe ::Perspective::Bindings::BindingDefinitions::Number do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::Number }
  
  it_behaves_like :number_container_binding

end
