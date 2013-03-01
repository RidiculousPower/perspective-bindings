# -*- encoding : utf-8 -*-

require_relative 'binding_definition_test_setup.rb'

shared_examples_for :text_container_binding do

  ##############################
  #  binding_value_valid?  #
  ##############################

  context '#binding_value_valid?' do
    it( 'will match :text' ) { should match_types( :text ) }
  end
  
end
