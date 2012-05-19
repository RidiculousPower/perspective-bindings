
module ::Magnets::Binding::Container::ClassInstance::Bindings

  include ::Magnets::Binding::Container::ClassInstance::Methods

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array
  include ::CascadingConfiguration::Hash
  
  ccm = ::CascadingConfiguration::Methods
    
  ##################
  #  bindings      #
  #  __bindings__  #
  ##################
  
	attr_module_configuration_hash  :__bindings__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( binding_name, binding_instance )

      child_instance = nil

      configuration_instance.instance_eval do
        # Create a new binding without any settings - causes automatic lookup to superclass.
        base_route = configuration_instance.__route__
        child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__( base_route )
      end
      
      return child_instance
      
    end
    
  end
  
  ccm.alias_module_method( self, :bindings, :__bindings__ )
  
  #########################
  #  shared_bindings      #
  #  __shared_bindings__  #
  #########################

	attr_module_configuration_hash  :__shared_bindings__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( binding_name, binding_instance )

      child_instance = nil

      configuration_instance.instance_eval do
        # Create a new binding without any settings - causes automatic lookup to superclass.
        base_route = configuration_instance.__route__
        child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__( base_route )
      end
      
      return child_instance
      
    end
    
  end
  
  ccm.alias_module_method( self, :shared_bindings, :__shared_bindings__ )

  #########################
  #  binding_aliases      #
  #  __binding_aliases__  #
  #########################

	attr_module_configuration_hash  :__binding_aliases__
	
  ccm.alias_module_method( self, :binding_aliases, :__binding_aliases__ )

  #######################
  #  binding_order      #
  #  __binding_order__  #
  #######################

  attr_module_configuration_array  :__binding_order__
  
  ccm.alias_module_method( self, :binding_order, :__binding_order__ )
  
  #######################################
  #  binding_order_declared_empty?      #
  #  __binding_order_declared_empty__?  #
  #######################################
  
  attr_module_configuration  :__binding_order_declared_empty__?
  
  ccm.alias_module_method( self, :binding_order_declared_empty?, :__binding_order_declared_empty__ )
  
  #########################################  Status  ###############################################
	
  ##################
  #  has_binding?  #
  ##################

  # has_binding? :name, ...
  # 
	def has_binding?( binding_name )
		
		has_binding = false
		
		# if we have binding, alias, or re-binding
		if 	__bindings__.has_key?( binding_name )        or 
		    __shared_bindings__.has_key?( binding_name ) or
		    __binding_aliases__.has_key?( binding_name )
		
			has_binding = true
		
		end
		
		return has_binding
		
	end

	########################################  Bindings  ##############################################

  ###############################
  #  __binding_configuration__  #
  ###############################

	def __binding_configuration__( binding_name )
		
		if __binding_aliases__.has_key?( binding_name )

		  binding_name = __binding_aliases__[ binding_name ]

	  end
	  
	  unless binding_instance = __bindings__[ binding_name ]
      
      binding_instance = __shared_bindings__[ binding_name ]
      
    end
    
		return binding_instance
		
	end

end
