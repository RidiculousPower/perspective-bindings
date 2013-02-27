
require_relative 'binding_definition_test_setup.rb'

shared_examples_for :regexp_container_binding do

  ##############################
  #  __binding_value_valid__?  #
  ##############################

  context '#__binding_value_valid__?' do
    it( 'will match :regexp' ) { should match_types( :regexp ) }
  end
  
end
