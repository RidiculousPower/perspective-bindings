
module ::Rmagnets::Bindings::ObjectInstance
	
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array
  include ::CascadingConfiguration::Hash
  
  extend ModuleCluster::Define::Block::CascadingClassOrModule
  
  # We rely on inheritance structure provided by CascadingConfiguration for Binding configuration.
  # Binding instance uses configuration instance (instance including this module) for 
  # defining parallel hierarchy.
  
  attr_configuration        :__binding_order_declared_empty__?
  
	attr_configuration_hash   :binding_configurations, :binding_aliases, :renamed_bindings,
	                          :binding_routers, :shared_binding_routers
	                          
  attr_configuration_array  :binding_order

  # Ensure that each inheritance level has its own binding copy.
  # This way settings cascade and any level can have its own setting.
  cascading_class_or_module_include do |class_or_module|
    
    binding_configurations.each do |this_binding_name, this_binding_instance|
      
      class_or_module.instance_eval do
        
        # Create a new binding without any settings - 
        # causes automatic lookup to superclass.
        create_binding( this_binding_name, nil, false )
        
      end
      
    end
    
  end

  ################
  #  initialize  #
  ################

  def initialize

		# instantiate specified views
		binding_configurations.each do |this_binding_name, this_binding_instance|
		  
		  bound_instance = nil
		  
		  if view_class = this_binding_instance.view_class
		    bound_instance = view_class.new
		    instance_variable_set( this_binding_name.variable_name, bound_instance )
      end
      
      # run configuration proc for each binding instance
  		this_binding_instance.configuration_procs.each do |this_configuration_proc, this_binding_map|
  		  @__binding_redirection_map_for_proc = this_binding_map
        instance_exec( bound_instance, & this_configuration_proc )
  	  end
		  @__binding_redirection_map_for_proc = nil
      
	  end

  end

  ####################
  #  method_missing  #
  ####################
  
  def method_missing( method_name, *args )
    
    return_value = nil
    
    if @__binding_redirection_map_for_proc
      
      binding_name = method_name.accessor_name

      # if our method names a binding, route to the binding
      if binding_instance = @__binding_redirection_map_for_proc[ binding_name ]
    
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
      super
      
    end
    
    return return_value
    
  end
  
  ########################################
  #  ensure_binding_render_values_valid  #
  ########################################
  
  def ensure_binding_render_values_valid
  
    # iterate bindings to fill in any corresponding values
    binding_configurations.each do |this_binding_name, this_binding_instance|
      
      if this_corresponding_name = this_binding_instance.corresponding_view_binding

        # if we have a corresponding view instance, fill in its content with our binding value
        if this_corresponding_instance = __send__( this_corresponding_name )
        
          this_binding_value = __send__( this_binding_name )
          this_corresponding_instance.content = this_binding_value
        
        end
        
      end
      
    end
  
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
