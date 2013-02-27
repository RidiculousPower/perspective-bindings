
require_relative 'binding_definition_test_setup.rb'

shared_examples_for :text_container_binding do

  ##############################
  #  __binding_value_valid__?  #
  ##############################

  context '#__binding_value_valid__?' do
    it( 'will match :text' ) { should match_types( :text ) }
  end
  
end
