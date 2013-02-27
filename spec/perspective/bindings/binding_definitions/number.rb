
require_relative 'binding_definition_test_setup.rb'

shared_examples_for :number_container_binding do

  ##############################
  #  __binding_value_valid__?  #
  ##############################

  context '#__binding_value_valid__?' do
    it( 'will match :integer, :float, :rational, :complex' ) { should match_types( :integer, :float, :rational, :complex ) }
  end
  
end

