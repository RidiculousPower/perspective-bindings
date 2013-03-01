# -*- encoding : utf-8 -*-

require_relative 'container_and_bindings_spec/container_and_bindings_test_setup.rb'
require_relative 'container_and_bindings_spec/container_and_bindings.rb'

describe ::Perspective::Bindings::Container do
    
  setup_container_and_bindings_tests  

  let( :bindings_module ) { ::Perspective::Bindings::Container }
  
  it_behaves_like :container_and_bindings

end
