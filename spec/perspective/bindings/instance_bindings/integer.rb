# -*- encoding : utf-8 -*-

require_relative 'binding_definition_test_setup.rb'

shared_examples_for :integer_container_binding do

  ##############################
  #  binding_value_valid?  #
  ##############################

  context '#binding_value_valid?' do
    it( 'will match :integer' ) { should match_types( :integer ) }
  end
  
end
