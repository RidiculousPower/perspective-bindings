
module ::Magnets::Bindings::InstanceBinding::Initialization

  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding )
    
    __initialize_for_parent_binding__( parent_class_binding )
    
    __initialize_container__
    
  end
  
  #######################################
  #  __initialize_for_parent_binding__  #
  #######################################
  
  def __initialize_for_parent_binding__( parent_class_binding )
    
    @__parent_binding__ = parent_class_binding
    
    # register parent class binding as ancestor for configurations
    ::CascadingConfiguration::Variable.register_child_for_parent( self, parent_class_binding )
    
  end

  ##############################
  #  __initialize_container__  #
  ##############################
  
  def __initialize_container__
    
    if container_class = @__parent_binding__.__container_class__
      
      self.__container__ = container_class.new
      extend( container_class::InstanceBindingMethods )
      
      __configure_container__
      
    end
    
  end

  #############################
  #  __configure_container__  #
  #############################
  
  def __configure_container__
    
    container_instance = __container__
    
    # run configuration proc for each binding instance
		__configuration_procs__.each do |this_configuration_proc|
      instance_exec( container_instance, & this_configuration_proc )
	  end
    
  end
  
end
