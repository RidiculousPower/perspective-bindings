# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'rational.rb'

describe ::Perspective::Bindings::BindingDefinitions::Rational do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::Rational }
  
  it_behaves_like :rational_container_binding

end
