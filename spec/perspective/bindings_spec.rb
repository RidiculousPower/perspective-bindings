
require_relative 'bindings/container_and_bindings_spec/container_and_bindings_test_setup.rb'
require_relative 'bindings/container_and_bindings_spec/container_and_bindings.rb'

describe ::Perspective::Bindings do
    
  setup_container_and_bindings_tests  

  let( :bindings_module ) { ::Perspective::Bindings }
  
  it_behaves_like :container_and_bindings

end
