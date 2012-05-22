
module ::Magnets::Bindings::InstanceBinding::BoundInstance

  ####################################
  #  __instantiate_bound_instance__  #
  ####################################

  def __instantiate_bound_instance__
    
    bound_instance = nil
	  
		# instantiate specified container
	  if bound_instance_class = __container_class__
	    
	    bound_instance = bound_instance_class.new
	    bound_instance.__initialize_for_parent_binding__( self )

    end
    
    return bound_instance
	  
  end

  ##################################
  #  __configure_bound_instance__  #
  ##################################

  def __configure_bound_instance__( binding_object, bound_instance )

    __configuration_procs__.each do |this_configuration_proc|
      binding_object.instance_exec( bound_instance, & this_configuration_proc )
	  end
	  
  end
  
end
