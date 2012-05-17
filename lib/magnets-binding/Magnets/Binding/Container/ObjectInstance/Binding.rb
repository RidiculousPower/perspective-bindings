
module ::Magnets::Binding::Container::ObjectInstance::Binding
	
  include ::CascadingConfiguration::Hash

  #######################################
  #  __initialize_for_parent_binding__  #
  #######################################
  
  def __initialize_for_parent_binding__( parent_binding )

    @__parent_binding__ = parent_binding
        
  end
  
  ########################
  #  parent_binding      #
  #  __parent_binding__  #
  ########################
    
  attr_reader  :__parent_binding__
  alias_method  :parent_binding, :__parent_binding__
  
  ##################
  #  bindings      #
  #  __bindings__  #
  ##################
  
	attr_instance_configuration_hash  :__bindings__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( binding_name, binding_instance )

      return self.class::InstanceBinding.new( binding_instance )
      
    end
    
  end
  alias_method  :bindings, :__bindings__

  #########################
  #  shared_bindings      #
  #  __shared_bindings__  #
  #########################

	attr_instance_configuration_hash  :__shared_bindings__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( binding_name, binding_instance )

      return self.class::InstanceBinding.new( binding_instance )
      
    end
    
  end
  alias_method  :shared_bindings, :__shared_bindings__

end
