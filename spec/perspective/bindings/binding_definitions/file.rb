
require_relative 'binding_definition_test_setup.rb'

shared_examples_for :file_container_binding do

  ##############################
  #  binding_value_valid?  #
  ##############################

  context '#binding_value_valid?' do
    it( 'will match :file' ) { should match_types( :file ) }
  end
  
end
