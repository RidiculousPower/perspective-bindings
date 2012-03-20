
module ::Rmagnets::Bindings::ObjectInstance
	
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array
  include ::CascadingConfiguration::Hash
    
  ################
  #  initialize  #
  ################

  def initialize

		# instantiate specified views
		self.class.binding_configurations.each do |this_binding_name, this_binding_instance|

		  bound_instance = nil
		  
		  if view_class = this_binding_instance.view_class
		    bound_instance = view_class.new
		    instance_variable_set( this_binding_name.variable_name, bound_instance )
      end
      
      # run configuration proc for each binding instance
  		this_binding_instance.configuration_procs.each do |this_configuration_proc, this_binding_map|
  		  @__binding_redirection_map_for_proc__ = this_binding_map
        instance_exec( bound_instance, & this_configuration_proc )
  	  end
		  @__binding_redirection_map_for_proc__ = nil
      
	  end

  end

  #######################################
  #  __binding_order_declared_empty__?  #
  #######################################
  
  attr_configuration       :__binding_order_declared_empty__?
  
  ############################
  #  binding_configurations  #
  ############################
  
	attr_module_configuration_hash  :binding_configurations do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( key, binding_instance )

      # Create a new binding without any settings - 
      # causes automatic lookup to superclass.

      child_binding_instance = nil

      configuration_instance.instance_eval do
        child_binding_instance = create_binding( binding_instance.__binding_name__, nil, false )
      end
      
      return child_binding_instance
      
    end
    
  end

  ############################
  #  binding_routers         #
  #  shared_binding_routers  #
  ############################

	attr_configuration_hash  :binding_routers
	attr_configuration_hash  :shared_binding_routers do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( key, binding_router )

      # Create a new binding router without any settings except the new configuration instance- 
      # causes automatic lookup to superclass.
      return ::Rmagnets::Bindings::Binding::Router.new( binding_router.__binding_instance__ )
	    
    end
	  
  end

  #####################
  #  binding_aliases  #
  #####################

	attr_configuration_hash   :binding_aliases

  ###################
  #  binding_order  #
  ###################

  attr_configuration_array  :binding_order

  ####################
  #  method_missing  #
  ####################
  
  def method_missing( method_name, *args )
    
    return_value = nil
    
    if @__binding_redirection_map_for_proc__
      
      binding_name = method_name.accessor_name

      # if our method names a binding, route to the binding
      if binding_instance = @__binding_redirection_map_for_proc__[ binding_name ]
    
        # for a given name we need to know the current path to its equivalent instance
    
        case method_name

          when binding_name

            binding_accessor_name = binding_instance.__binding_name__.accessor_name
            return_value = __send__( binding_accessor_name, *args )

          when binding_name.write_accessor_name

            binding_write_accessor_name = binding_instance.__binding_name__.write_accessor_name
            return_value = __send__( binding_write_accessor_name, *args )

        end
      
      end
    
    else
      
      # we didn't capture method - handle as normal
      begin
        super
      rescue Exception => exception
        backtrace_array = exception.backtrace
        missing_method_call_index = 1
        missing_method_call = exception.backtrace[ missing_method_call_index ]
        backtrace_array.unshift( missing_method_call )
        raise exception
      end
      
    end
    
    return return_value
    
  end
  
  ########################################
  #  ensure_binding_render_values_valid  #
  ########################################
  
  def ensure_binding_render_values_valid
  
    # if we are rendering an empty view we don't want to raise an error for empty required values
    unless @__view_rendering_empty__
      
      binding_order.each do |this_binding_name|

        this_binding_router = self.class.binding_router( this_binding_name )
  			this_binding_instance = this_binding_router.__binding_instance__
  			this_binding_value = __send__( this_binding_name )
        
        # the binding validates base configuration
        this_binding_instance.ensure_binding_render_value_valid( this_binding_value )
        
        # we also keep view-defined validation procs in the router
        this_binding_router.ensure_binding_render_value_validates
        
      end

    else

      @__view_rendering_empty__ = false

	  end
    
  end
  
end
