# -*- encoding : utf-8 -*-

require_relative 'binding_definition_test_setup.rb'

shared_examples_for :float_container_binding do

  ##############################
  #  binding_value_valid?  #
  ##############################

  context '#binding_value_valid?' do
    it( 'will match :float' ) { should match_types( :float ) }
  end
  
end
