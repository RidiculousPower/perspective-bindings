# -*- encoding : utf-8 -*-

require_relative 'binding_definition_test_setup.rb'

shared_examples_for :true_or_false_container_binding do

  ##############################
  #  binding_value_valid?  #
  ##############################

  context '#binding_value_valid?' do
    it( 'will match :true_or_false' ) { should match_types( :true_or_false ) }
  end
  
end
