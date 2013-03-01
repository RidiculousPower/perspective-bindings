# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::ObjectAndBindingInstance

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique
  include ::CascadingConfiguration::Hash

  ################
  #  «bindings»  #
  ################

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
  #   * Instance Binding to Instance (class binding specified container class).
  #
  #   * nested Instance Binding to Instance (class binding specified container 
  #     class).
  #
  #   * Instance to Instance Binding (instance assigned to instance binding).
  #
  #     Note: this inverts typical inheritance relations such that the
  #     binding will inherit from the instance rather than the instance
  #     inheriting from the binding. 
  #
	attr_hash  :«bindings» do
	  
	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( binding_name, binding_instance, parent_hash )

      child_instance = nil

      case instance = configuration_instance

        # Inheriting from a module included in a root container class/module or as a subclass.
        when ::Perspective::Bindings::Container::SingletonInstance

          child_instance = binding_instance.class.new( instance, binding_instance )

        # Inheriting from a class or a class binding (nested or not).
        when ::Perspective::Bindings::BindingBase::ClassBinding
          
          # If we're attaching to a class binding we're at least 2 levels deep, 
          # which means new class bindings are nested.
          child_instance = binding_instance.class::ClassBinding.new( instance, binding_instance )
          
        # Inheriting from a class or an instance binding (nested or not)
        when ::Perspective::Bindings::Container::ObjectInstance
          
          # What matters in this case is that we need instance bindings.
          
          case parent_instance = parent_hash.configuration_instance
            
            when ::Perspective::Bindings::Container::SingletonInstance

              # We are inheriting as a root container instance.
              # We need instance bindings corresponding to the declared class bindings
              child_instance = binding_instance.class::InstanceBinding.new( binding_instance, instance )
            
            when ::Perspective::Bindings::BindingBase::InstanceBinding
              
              if parent_instance.permits_multiple? and parent_instance.«container»( false ) != instance
                # We were created by an instance binding as a multiple container (> index 0).
                #
                # We need new instance bindings or we end up with the same binding instances as the
                # first container for this instance binding.
                child_instance = binding_instance.class::InstanceBinding.new( binding_instance.«parent_binding», 
                                                                              instance )
              else
                # We were created by an instance binding.
                #
                # We want the same instance bindings we attached to the instance binding that
                # this container is attached to.
                child_instance = binding_instance
              end

          end
            
        # Inheriting from class binding (nested or not) or instance (assigned to instance binding)
        when ::Perspective::Bindings::BindingBase::InstanceBinding
          
          # What matters in this case is that we need instance bindings.

          case parent_instance = parent_hash.configuration_instance
            
            when ::Perspective::Bindings::BindingBase::ClassBinding

              # it's looping b/c we are an instance binding iheriting from a class binding
              # and when we create a new instance binding, it is also inheriting from a class binding
              # so we never stop creating new nested bindings b/c each attempt to finish inheritance creates a new one
              # We are inheriting as a nested instance binding
              child_instance = binding_instance.class::InstanceBinding.new( binding_instance, instance )
            
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

  #######################
  #  «binding_aliases»  #
  #######################

	attr_hash  :«binding_aliases»

end
