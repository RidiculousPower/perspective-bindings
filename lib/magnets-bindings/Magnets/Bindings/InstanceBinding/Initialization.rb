
module ::Magnets::Bindings::InstanceBinding::Initialization

  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding, bound_container_instance )
        
    @__parent_binding__ = parent_class_binding

    # register parent class binding as ancestor for configurations
    ::CascadingConfiguration::Variable.register_child_for_parent( self, @__parent_binding__ )

    @__bound_container__ = bound_container_instance

  end

  ##############################
  #  __initialize_container__  #
  ##############################
  
  def __initialize_container__
    
    container_class = @__parent_binding__.__container_class__
    
    container_instance = container_class.new

    self.__container__ = container_instance
    
    extend( container_class::InstanceBindingMethods )
    
    ::CascadingConfiguration::Variable.register_child_for_parent( container_instance, self )

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
