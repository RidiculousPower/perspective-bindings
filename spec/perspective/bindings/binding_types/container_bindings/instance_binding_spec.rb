
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBindingClass do
  
  #########################################
  #  __initialize_container_from_class__  #
  #########################################
  
  context '' do
  end
  
  #############################
  #  __initialize_bindings__  #
  #############################

  context '' do
  end
  
  #############################
  #  __configure_container__  #
  #############################

  context '' do
  end
  
  ###################
  #  __container__  #
  ###################

  context '' do
  end
  
  ##############################################
  #  __store_initialized_container_instance__  #
  ##############################################

  context '' do
  end
  
  ####################
  #  __container__=  #
  ####################

  context '' do
  end
  
  ###############
  #  container  #
  ###############

  context '' do
  end
  
  ################
  #  container=  #
  ################

  context '' do
  end
  
  ##################
  #  __autobind__  #
  ##################

  context '' do
  end
  
  ################
  #  __value__=  #
  ################

  context '' do
  end
  
  ############
  #  value=  #
  ############

  context '' do
  end
  
  ######################
  #  __nested_route__  #
  ######################
  
  context '#__nested_route__' do
    context 'binding is nested in queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_class_binding_A_B.__nested_route__( topclass_class_binding_A ).should == nil
      end
    end
    context 'binding is nested in binding under queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_class_binding_A_B_C.__nested_route__( topclass_class_binding_A ).should == [ topclass_class_binding_A_B_name ]
      end
    end
  end

end
