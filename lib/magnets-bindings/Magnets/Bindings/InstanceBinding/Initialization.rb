
module ::Magnets::Bindings::InstanceBinding::Initialization

  ################
  #  initialize  #
  ################

  def initialize( parent_class_or_instance_binding )
    
    __initialize_for_parent_binding__( parent_class_or_instance_binding )
    
    __initialize_container__
        
  end
  
  #######################################
  #  __initialize_for_parent_binding__  #
  #######################################
  
  def __initialize_for_parent_binding__( parent_class_or_instance_binding )
    
    @__parent_binding__ = parent_class_or_instance_binding
    
    # register parent class binding as ancestor for configurations
    ::CascadingConfiguration::Variable.register_child_for_parent( self, 
                                                                  parent_class_or_instance_binding )
    
  end

  ##############################
  #  __initialize_container__  #
  ##############################
  
  def __initialize_container__
    
    container_instance = nil

    container_class = nil
    
    case @__parent_binding__
    
      when ::Magnets::Bindings::InstanceBinding
        
        if container = @__parent_binding__.__container__
          container_class = container.class
        end
    
      when ::Magnets::Bindings::ClassBinding

        container_class = @__parent_binding__.__container_class__
      
    end
    
    if container_class
      
      container_instance = container_class.new
      ::CascadingConfiguration::Variable.register_child_for_parent( container_instance, self )
      self.__container__ = container_instance
      extend( container_class::InstanceBindingMethods )
            
    end
        
    return container_instance
    
  end

  #############################
  #  __configure_container__  #
  #############################
  
  def __configure_container__

    container_instance = __container__
    bound_container = __bound_container__

    # run configuration proc for each binding instance
		__configuration_procs__.each do |this_configuration_proc|
      bound_container.instance_exec( container_instance, & this_configuration_proc )
	  end
    
  end
  
end
