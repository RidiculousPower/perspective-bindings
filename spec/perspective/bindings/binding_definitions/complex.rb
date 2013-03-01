
require_relative 'binding_definition_test_setup.rb'

shared_examples_for :complex_container_binding do
  
  ##############################
  #  binding_value_valid?  #
  ##############################
  
  context '#binding_value_valid?' do
    it( 'will match :complex' ) { should match_types( :complex ) }
  end
  
end
