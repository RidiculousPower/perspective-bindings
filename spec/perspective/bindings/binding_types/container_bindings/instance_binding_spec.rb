
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBindingClass do
  
  #########################################
  #  __initialize_container_from_class__  #
  #########################################
  
  #############################
  #  __initialize_bindings__  #
  #############################
  
  #############################
  #  __configure_container__  #
  #############################
  
  ###################
  #  __container__  #
  ###################
  
  ##############################################
  #  __store_initialized_container_instance__  #
  ##############################################
  
  ####################
  #  __container__=  #
  ####################
  
  ###############
  #  container  #
  ###############
  
  ################
  #  container=  #
  ################
  
  ##################
  #  __autobind__  #
  ##################
  
  ################
  #  __value__=  #
  ################
  
  ############
  #  value=  #
  ############
  
  ######################
  #  __nested_route__  #
  ######################
  
  context '#__nested_route__' do
    it 'bound to base container' do
      instance_binding_to_base.__nested_route__( instance_binding_to_base ).should == nil
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__nested_route__( instance_binding_to_base ).should == nil
      instance_binding_to_first_nested.__nested_route__( instance_binding_to_first_nested ).should == nil
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__nested_route__( instance_binding_to_base ).should == [ binding_to_first_nested_name ]
      instance_binding_to_nth_nested.__nested_route__( instance_binding_to_first_nested ).should == nil
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__nested_route__( subclass_instance_binding_to_base ).should == nil
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__nested_route__( subclass_instance_binding_to_base ).should == nil
      subclass_instance_binding_to_first_nested.__nested_route__( subclass_instance_binding_to_first_nested ).should == nil
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__nested_route__( instance_binding_to_base ).should == [ binding_to_first_nested_name ]
      subclass_instance_binding_to_nth_nested.__nested_route__( instance_binding_to_first_nested ).should == nil
    end
  end

end
