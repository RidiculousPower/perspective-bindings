
module ::Magnets::Bindings::ObjectInstance
	
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array
  include ::CascadingConfiguration::Hash
    
  ################
  #  initialize  #
  ################

  def initialize
    
    declared_bindings = self.class.__bindings__

    # initialize all bindings first
		declared_bindings.each do |this_binding_name, this_binding_instance|
      __initialize_binding__( this_binding_name, this_binding_instance )
	  end
    
    # only all bindings are initialized do we have each binding configure itself
		declared_bindings.each do |this_binding_name, this_binding_instance|
      __configure_binding__( this_binding_name, this_binding_instance )
	  end
	  
  end
  
  ############################
  #  __initialize_binding__  #
  ############################
  
  def __initialize_binding__( binding_name, binding_instance )

	  bound_instance = nil
	  
		# instantiate specified view
	  if view_class = binding_instance.__view_class__ and
	     ! binding_instance.__corresponding_view_binding__
	    
	    bound_instance = view_class.new
	    bound_instance.__parent_binding__ = binding_instance

	    instance_variable_set( binding_name.variable_name, bound_instance )

    end
    
    return bound_instance
    
  end
  
  ###########################
  #  __configure_binding__  #
  ###########################
  
  def __configure_binding__( binding_name, binding_instance )

	  bound_instance = instance_variable_get( binding_name.variable_name )

    # run configuration proc for each binding instance
	  # views and configuration procs for bindings with corresponding bindings are associated
	  # with their corresponding view, but also stored for reference
	  unless binding_instance.__corresponding_view_binding__
  		binding_instance.__configuration_procs__.each do |this_configuration_proc|
        instance_exec( bound_instance, & this_configuration_proc )
  	  end
    end
    
    return bound_instance
    
  end

  ########################
  #  __parent_binding__  #
  ########################
    
  attr_accessor                    :__parent_binding__
    
  #######################
  #  __binding_value__  #
  #######################

  def __binding_value__( binding_name )
    
    if aliased_name = __binding_aliases__[ binding_name ]
      binding_name = aliased_name
    end
    
    return instance_variable_get( binding_name.variable_name )
    
  end

  ###########################
  #  __set_binding_value__  #
  ###########################

  def __set_binding_value__( binding_name, object )
        
    binding_instance = self.class.__binding_configuration__( binding_name )
        
    binding_instance.__ensure_binding_value_valid__( object )
      
    instance_variable_set( binding_name.variable_name, object )
    
    if corresponding_binding_instance = binding_instance.__corresponding_view_binding__
      
      corresponding_binding_name = corresponding_binding_instance.__name__
      
      corresponding_view = __binding__( corresponding_binding_name )
      
      # if we have an array we want 1 corresponding view per member
      if object.is_a?( ::Array )

        objects_greater_than_one = object.count - 1
        
        if objects_greater_than_one > 0

          corresponding_views = [ ]

          # we've already initialized one
          corresponding_views.push( corresponding_view.autobind( object[ 0 ] ) )

          # now we need the rest
          corresponding_view_class = corresponding_binding_instance.__view_class__
          object.slice( 1, objects_greater_than_one ).each do |this_object|
            corresponding_views.push( corresponding_view_class.new.autobind( this_object ) )
          end

          instance_variable_set( corresponding_binding_name.variable_name, corresponding_views )
          
        else

          corresponding_view.autobind( object[ 0 ] )
          
        end
        
      else
        
        corresponding_view.autobind( object )
        
      end
      
    end

    return object
    
  end

  #######################################
  #  __binding_order_declared_empty__?  #
  #######################################
  
  attr_configuration               :__binding_order_declared_empty__?
  
  ##################
  #  __bindings__  #
  ##################
  
	attr_module_configuration_hash   :__bindings__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( binding_name, binding_instance )

      # Create a new binding without any settings - 
      # causes automatic lookup to superclass.

      child_binding_instance = nil

      configuration_instance.instance_eval do
        child_binding_instance = binding_instance.__duplicate_as_inheriting_sub_binding__
      end
      
      return child_binding_instance
      
    end
    
  end

  #########################
  #  __shared_bindings__  #
  #########################

	attr_module_configuration_hash   :__shared_bindings__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( binding_name, binding_instance )

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

	attr_module_configuration_hash   :__binding_aliases__

  #######################
  #  __binding_order__  #
  #######################

  attr_module_configuration_array  :__binding_order__

  ############################################
  #  __ensure_binding_render_values_valid__  #
  ############################################
  
  def __ensure_binding_render_values_valid__
  
    # if we are rendering an empty view we don't want to raise an error for empty required values
    unless @__view_rendering_empty__
      
      __binding_configurations__.each do |this_binding_name, this_binding_instance|
        
    		this_binding_value = __binding_value__( this_binding_name )
        this_binding_instance.__ensure_render_value_valid__( this_binding_value )
        
      end

    else

      @__view_rendering_empty__ = false

	  end
    
  end
  
  ###################################
  #  __ensure_render_value_valid__  #
  ###################################

  def __ensure_render_value_valid__( binding_value )
    
    # Binding definition modules override
    return true
    
  end
  
end
