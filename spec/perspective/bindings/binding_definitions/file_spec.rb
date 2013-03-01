# -*- encoding : utf-8 -*-

require_relative '../../../../lib/perspective/bindings.rb'
require_relative 'file.rb'

describe ::Perspective::Bindings::BindingDefinitions::File do

  setup_binding_definition_tests
  let( :binding_definition_module ) { ::Perspective::Bindings::BindingDefinitions::File }
  
  it_behaves_like :file_container_binding
  
end
