
module ::Magnets::Binding::Container::ObjectInstance::Bindings
	
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

      new_instance_binding = self.class::InstanceBinding.new( binding_instance )

      new_instance_binding.extend( self.class::BindingMethods )

      return new_instance_binding
      
    end
    
  end
  alias_method  :bindings, :__bindings__

end
