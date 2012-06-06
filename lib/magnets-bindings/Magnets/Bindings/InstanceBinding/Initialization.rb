
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
    
    case @__parent_binding__ = parent_class_or_instance_binding
      
      when ::Magnets::Bindings::InstanceBinding
      
        
        if @__bound_container__ = @__parent_binding__.__container__
          @__bound_container_class__ = @__bound_container__.class
          @__container_class__ = @__bound_container__.class
        end
        
      when ::Magnets::Bindings::ClassBinding

        @__bound_container_class__ = @__parent_binding__.__bound_container_class__
        @__container_class__ = @__parent_binding__.__container_class__
      
    end
    
  end

  ##############################
  #  __initialize_container__  #
  ##############################
  
  def __initialize_container__
    
    container_instance = nil

    container_class = nil

    if container_class

      container_instance = container_class.new
      
      if __bound_container__.__route__
        container_instance.extend( ::Magnets::Bindings::Container::ObjectInstance::Nested )
      end
      
      container_instance.__configure_bindings__
      
      ::CascadingConfiguration::Variable.register_child_for_parent( container_instance, self )
      self.__container__ = container_instance
      extend( container_class::InstanceBindingMethods )
            
    end
       
    # register parent class binding as ancestor for configurations
    ::CascadingConfiguration::Variable.register_child_for_parent( self, 
                                                                  @__parent_binding__ )
        
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
