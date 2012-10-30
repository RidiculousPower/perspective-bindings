
module ::Perspective::Bindings::Configuration::ObjectAndBindingInstance

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique
  include ::CascadingConfiguration::Hash

  ##################
  #  bindings      #
  #  __bindings__  #
  ##################

  ###
  # Binding initialization takes place in the process of cascading from
  #   parent to child. Binding inheritance can occur in the following patterns:
  #
  #   * Class to Instance (root container)
  #
  #   * Class to Class Binding (nested in another container)
  #
  #   * Class Binding to Instance Binding (attached to root container)
  #
  #   * Class Binding to Nested Class Binding (nested in a container 
  #     that is nested in a container)
  #
  #   * Nested Class Binding to Nested Instance Binding (instance nested 
  #     in a container that is nested in a container)
  #
  #   * Instance Binding to Instance (class binding specified container class).
  #
  #   * Nested Instance Binding to Instance (class binding specified container 
  #     class).
  #
  #   * Instance to Instance Binding (instance assigned to instance binding).
  #
  #     Note: this inverts typical inheritance relations such that the
  #     binding will inherit from the instance rather than the instance
  #     inheriting from the binding. 
  #
  #   * Instance to Nested Instance Binding (instance assigned to instance 
  #     binding nested in a nested container)
  #
  #     Note: this inverts typical inheritance relations such that the
  #     binding will inherit from the instance rather than the instance
  #     inheriting from the binding.
  #
	attr_hash  :__bindings__ do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( binding_name, binding_instance, parent_hash )

      child_instance = nil

      case instance = configuration_instance

        # Inheriting from a module included in a root container class/module or as a subclass.
        when ::Perspective::Bindings::Container::ClassInstance

          # Container classes are always the base of their route, 
          # which means new class bindings are not nested.
          child_instance = binding_instance.class.new( instance, nil, nil, binding_instance )

        # Inheriting from a class or a class binding (nested or not).
        when ::Perspective::Bindings::ClassBinding
          
          # If we're attaching to a class binding we're at least 2 levels deep, 
          # which means new class bindings are nested.
          child_instance = binding_instance.class::NestedClassBinding.new( instance, nil, nil, binding_instance )
          
        # Inheriting from a class or an instance binding (nested or not)
        when ::Perspective::Bindings::Container::ObjectInstance
          
          # What matters in this case is that we need instance bindings.
          
          if $blah and defined?( ::Perspective::HTML::Form::MockB ) and instance.is_a?( ::Perspective::HTML::Form::MockB )
            puts 'FUCK: ' + parent_hash.configuration_instance.to_s
          end
                              
          case parent_instance = parent_hash.configuration_instance
            
            when ::Perspective::Bindings::Container::ClassInstance

              # We are inheriting as a root container instance.
              # We need instance bindings corresponding to the declared class bindings
              child_instance = binding_instance.class::InstanceBinding.new( binding_instance, instance )
            
            when ::Perspective::Bindings::InstanceBinding

              # We were created by an instance binding.
              #
              # We want the same instance bindings we attached to the instance binding that
              # this container is attached to.
              child_instance = binding_instance

          end
            
        # Inheriting from class binding (nested or not) or instance (assigned to instance binding)
        when ::Perspective::Bindings::InstanceBinding
          
          # What matters in this case is that we need instance bindings.

          case parent_instance = parent_hash.configuration_instance
            
            when ::Perspective::Bindings::ClassBinding

              # We are inheriting as a nested instance binding
              child_instance = binding_instance.class::NestedInstanceBinding.new( binding_instance, 
                                                                                  parent_instance )
            
            when ::Perspective::Bindings::Container::ObjectInstance
            
              # We are inheriting from an object instance that was assigned to this instance
              # binding as its container.
              child_instance = binding_instance
              
          end

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

	  def child_pre_set_hook( local_alias_to_binding, binding_instance, parent_hash )
      
      binding_route = nil
      
      # We are instance C inheriting a shared binding, meaning an alias from instance B to binding in instance A.
      # The inherited binding instance we want already exists in __bindings__ for instance C.
      # We need the nested route for A in B, which will allow us to get A in C.
      
      case instance = configuration_instance
        
        when ::Perspective::Bindings::Container::ObjectInstance,
             ::Perspective::Bindings::InstanceBinding
          
          binding_route = instance.__nested_route__( binding_instance )

        when ::Perspective::Bindings::ClassBinding::NestedClassBinding

          binding_route = binding_instance.__nested_route__( instance )
          
          puts 'inst: ' + instance.__route_print_string__.to_s
          puts 'binding: ' + binding_instance.__route_print_string__.to_s
          
          raise 'figure this out - nested class bindings probably need nested route, but not sure'
          
        when ::Perspective::Bindings::Container::ClassInstance, 
             ::Perspective::Bindings::ClassBinding

          binding_route = binding_instance.__route__
          
      end

      child_instance = ::Perspective::Bindings.aliased_binding_in_context( instance, 
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
