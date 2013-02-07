
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBindingClass do

  #########################
  #  __container_class__  #
  #########################

  #####################
  #  container_class  #
  #####################

  ########################################
  #  __initialize_for_container_class__  #
  ########################################

  ##################################
  #  __validate_container_class__  #
  ##################################

  ######################
  #  __nested_route__  #
  ######################

  context '#__nested_route__' do
    it 'bound to base container' do
      class_binding_to_base.__nested_route__( class_binding_to_base ).should == nil
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__nested_route__( class_binding_to_base ).should == nil
      class_binding_to_first_nested.__nested_route__( class_binding_to_first_nested ).should == nil
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__nested_route__( class_binding_to_base ).should == [ binding_to_first_nested_name ]
      class_binding_to_nth_nested.__nested_route__( class_binding_to_first_nested ).should == nil
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__nested_route__( subclass_class_binding_to_base ).should == nil
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__nested_route__( subclass_class_binding_to_base ).should == nil
      subclass_class_binding_to_first_nested.__nested_route__( subclass_class_binding_to_first_nested ).should == nil
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__nested_route__( class_binding_to_base ).should == [ binding_to_first_nested_name ]
      subclass_class_binding_to_nth_nested.__nested_route__( class_binding_to_first_nested ).should == nil
    end
  end
  
end
