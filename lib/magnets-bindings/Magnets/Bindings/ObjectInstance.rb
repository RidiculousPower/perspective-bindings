
module ::Magnets::Bindings::ObjectInstance
	
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array
  include ::CascadingConfiguration::Hash
    
  ################
  #  initialize  #
  ################

  def initialize

	  __initialize_bindings__
	  
  end
  
  #############################
  #  __initialize_bindings__  #
  #############################
  
  def __initialize_bindings__

		self.class.__binding_configurations__.each do |this_binding_name, this_binding_instance|

      __initialize_binding__( this_binding_name, this_binding_instance )
      
	  end

  end
  
  ############################
  #  __initialize_binding__  #
  ############################
  
  def __initialize_binding__( binding_name, binding_instance )

	  bound_instance = nil
	  
		# instantiate specified view
	  if view_class = binding_instance.__view_class__
	    bound_instance = view_class.new
	    instance_variable_set( binding_name.variable_name, bound_instance )
    end
    
    # run configuration proc for each binding instance
		binding_instance.__configuration_procs__.each do |configuration_proc|
      instance_exec( bound_instance, & configuration_proc )
	  end
    
    return bound_instance
    
  end
    
  #################
  #  __binding__  #
  #################

  def __binding__( binding_name )
    
    if aliased_name = __binding_aliases__[ binding_name ]
      binding_name = aliased_name
    end
    
    return instance_variable_get( binding_name.variable_name )
    
  end

  #####################
  #  __set_binding__  #
  #####################

  def __set_binding__( binding_name, object )
        
    binding_instance = self.class.__binding_configuration__( binding_name )
        
    binding_instance.__ensure_binding_value_valid__( object )
    
    if this_corresponding_name = binding_instance.__corresponding_view_binding__
      corresponding_view_binding_instance = __binding__( this_corresponding_name )
      corresponding_view_binding_instance.content = object
    end

    return instance_variable_set( binding_name.variable_name, object )
    
  end

  #######################################
  #  __binding_order_declared_empty__?  #
  #######################################
  
  attr_configuration              :__binding_order_declared_empty__?
  
  ################################
  #  __binding_configurations__  #
  ################################
  
	attr_module_configuration_hash  :__binding_configurations__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( key, binding_instance )

      # Create a new binding without any settings - 
      # causes automatic lookup to superclass.

      child_binding_instance = nil

      configuration_instance.instance_eval do
        child_binding_instance = binding_instance.__duplicate_as_inheriting_sub_binding__
      end
      
      return child_binding_instance
      
    end
    
  end

  #######################################
  #  __shared_binding_configurations__  #
  #######################################

	attr_module_configuration_hash  :__shared_binding_configurations__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( key, binding_instance )

      # Create a new binding without any settings - 
      # causes automatic lookup to superclass.

      child_shared_binding_instance = nil

      configuration_instance.instance_eval do
        child_shared_binding_instance = binding_instance.__duplicate_as_inheriting_sub_binding__
      end
      
      return child_shared_binding_instance
      
    end
    
  end

  #########################
  #  __binding_aliases__  #
  #########################

	attr_configuration_hash   :__binding_aliases__

  #######################
  #  __binding_order__  #
  #######################

  attr_configuration_array  :__binding_order__

  ############################################
  #  __ensure_binding_render_values_valid__  #
  ############################################
  
  def __ensure_binding_render_values_valid__
  
    # if we are rendering an empty view we don't want to raise an error for empty required values
    unless @__view_rendering_empty__
      
      __binding_order__.each do |this_binding_name|

        __ensure_binding_render_value_valid__( this_binding_name )
        
      end

    else

      @__view_rendering_empty__ = false

	  end
    
  end
  
  ###########################################
  #  __ensure_binding_render_value_valid__  #
  ###########################################
  
  def __ensure_binding_render_value_valid__( binding_name )

    this_binding_instance = self.class.__binding_configuration__( binding_name )
		this_binding_value = __binding__( binding_name )
    this_binding_instance.ensure_binding_render_value_valid( this_binding_value )
  
  end
  
end
