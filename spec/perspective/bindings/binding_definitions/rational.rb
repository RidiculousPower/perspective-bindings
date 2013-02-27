
require_relative 'binding_definition_test_setup.rb'

shared_examples_for :rational_container_binding do

  ##############################
  #  __binding_value_valid__?  #
  ##############################

  context '#__binding_value_valid__?' do
    it( 'will match :rational' ) { should match_types( :rational ) }
  end
  
end
