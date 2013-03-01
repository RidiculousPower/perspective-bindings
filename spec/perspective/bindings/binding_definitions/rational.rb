
require_relative 'binding_definition_test_setup.rb'

shared_examples_for :rational_container_binding do

  ##############################
  #  binding_value_valid?  #
  ##############################

  context '#binding_value_valid?' do
    it( 'will match :rational' ) { should match_types( :rational ) }
  end
  
end

