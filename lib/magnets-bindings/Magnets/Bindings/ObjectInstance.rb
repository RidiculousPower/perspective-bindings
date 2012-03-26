
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

		  this_bound_instance = nil
		  
		  if view_class = this_binding_instance.__view_class__
		    this_bound_instance = view_class.new
		    instance_variable_set( this_binding_name.variable_name, this_bound_instance )
      end
      
      # run configuration proc for each binding instance
  		this_binding_instance.__configuration_procs__.each do |this_configuration_proc|
        instance_exec( this_bound_instance, & this_configuration_proc )
  	  end
      
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
        child_binding_instance = binding_instance.duplicate_as_inheriting_sub_binding
      end
      
      return child_binding_instance
      
    end
    
  end

  ###################################
  #  shared_binding_configurations  #
  ###################################

	attr_module_configuration_hash  :shared_binding_configurations do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#
	  
	  def child_pre_set_hook( key, binding_instance )

      # Create a new binding without any settings - 
      # causes automatic lookup to superclass.

      child_shared_binding_instance = nil

      configuration_instance.instance_eval do
        child_shared_binding_instance = binding_instance.duplicate_as_inheriting_sub_binding
      end
      
      return child_shared_binding_instance
      
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

            binding_accessor_name = binding_instance.__name__.accessor_name
            return_value = __send__( binding_accessor_name, *args )

          when binding_name.write_accessor_name

            binding_write_accessor_name = binding_instance.__name__.write_accessor_name
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

  			this_binding_instance = self.class.binding_configuration( this_binding_name )
  			this_binding_value = __send__( this_binding_name )
        
        this_binding_instance.ensure_binding_render_value_valid( this_binding_value )
                
      end

    else

      @__view_rendering_empty__ = false

	  end
    
  end
  
end
