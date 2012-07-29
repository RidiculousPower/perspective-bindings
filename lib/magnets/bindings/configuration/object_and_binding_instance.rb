
module ::Magnets::Bindings::Configuration::ObjectAndBindingInstance

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique
  include ::CascadingConfiguration::Hash

  ##################
  #  bindings      #
  #  __bindings__  #
  ##################

	attr_hash  :__bindings__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( binding_name, binding_instance )

      child_instance = nil

      # Pretty much all binding initialization takes place here.

      case instance = configuration_instance

        # We are attaching to a root container class/module.
        when ::Magnets::Bindings::Container::ClassInstance

          # We have either a subclass of a class with class bindings or an included module
          # with class bindings.
          #
          # We create class bindings that are children of the provided bindings.

          # Create a new binding without any settings - causes automatic lookup to superclass.
          # Container classes are always the base of their route.
          child_instance = binding_instance.class.new( instance, nil, nil, binding_instance )

        # We are attaching to a nested container class binding.
        when ::Magnets::Bindings::ClassBinding
          
          # Create a new binding without any settings - causes automatic lookup to parent.
          child_instance = binding_instance.class::NestedClassBinding.new( instance, nil, nil, binding_instance )

        # We are attaching to a root container instance.
        # We know this because we haven't been extended as a nested instance.
        when ::Magnets::Bindings::Container::ObjectInstance

          case binding_instance
            
            when ::Magnets::Bindings::InstanceBinding

              # We want the same instance bindings we attached to the instance binding that
              # this container is attached to.
              child_instance = binding_instance

            when ::Magnets::Bindings::ClassBinding

              # We need instance bindings corresponding to the declared class bindings
              child_instance = binding_instance.class::InstanceBinding.new( binding_instance, instance )

          end
            
        # We are attaching to a nested instance binding
        when ::Magnets::Bindings::InstanceBinding
          
          binding_class = binding_instance.class::NestedInstanceBinding
          child_instance = binding_class.new( binding_instance, instance.__container__ )

        else

          raise ::RuntimeError, ( 'Unexpected binding container type (' << instance.to_s ) << ')!'
          
      end

      return child_instance

    end
    
  end

  Controller.alias_module_and_instance_methods( :bindings, :__bindings__ )

  #########################
  #  binding_aliases      #
  #  __binding_aliases__  #
  #########################

	attr_hash  :__binding_aliases__
	
  Controller.alias_module_method( :binding_aliases, :__binding_aliases__ )

  ###################################
  #  local_aliases_to_bindings      #
  #  __local_aliases_to_bindings__  #
  ###################################

	attr_hash  :__local_aliases_to_bindings__ do

	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( local_alias_to_binding, binding_instance )
      
      binding_route = nil
      
      case instance = configuration_instance
        
        when ::Magnets::Bindings::Container::ClassInstance, ::Magnets::Bindings::ClassBinding

          binding_route = binding_instance.__route__
          
        when ::Magnets::Bindings::Container::ObjectInstance, ::Magnets::Bindings::InstanceBinding
          
          binding_route = binding_instance.__nested_route__( instance )
                  
      end
      
      child_instance = ::Magnets::Bindings.aliased_binding_in_context( configuration_instance, 
                                                                       binding_route,
                                                                       binding_instance.__name__,
                                                                       local_alias_to_binding,
                                                                       binding_instance )
      
      return child_instance

    end
  
  end

  Controller.alias_module_and_instance_methods( :local_aliases_to_bindings, :__local_aliases_to_bindings__ )

  #############################
  #  configuration_procs      #
  #  __configuration_procs__  #
  #############################
                              
  attr_configuration_unique_array  :__configuration_procs__

  Controller.alias_instance_method( :configuration_procs, :__configuration_procs__ )

end
