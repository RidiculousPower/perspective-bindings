
module ::Magnets::Bindings::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique
  include ::CascadingConfiguration::Hash

  ccm = ::CascadingConfiguration::Methods

  ###############
  #  route      #
  #  __route__  #
  ###############

  attr_instance_configuration  :__route__

  ccm.alias_instance_method( self, :route, :__route__ )

  ######################
  #  route_string      #
  #  __route_string__  #
  ######################

  attr_instance_configuration  :__route_string__

  ccm.alias_instance_method( self, :route_string, :__route_string__ )

  ##################
  #  bindings      #
  #  __bindings__  #
  ##################

	attr_configuration_hash  :__bindings__ do

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
          child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__

        # We are attaching to a nested container class binding.
        when ::Magnets::Bindings::ClassBinding

          # We need to track the route where this binding is nested - 
          # this is simply the binding path from the root container to this nested binding.
          base_route = nil
          if binding_instance.__route__
            base_route = binding_instance.__route__.dup
          else
            base_route = [ ]
          end
          base_route.push( configuration_instance.__name__ )
          
          # Create a new binding without any settings - causes automatic lookup to parent.
          child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__( base_route )

        # We are attaching to a container instance nested in an instance binding.
        # Nested instances are extended below so that this hook catches first.
        when ::Magnets::Bindings::Container::ObjectInstance::Nested

          # We want the same instance bindings we attached to the instance binding that
          # this container is attached to.
          child_instance = binding_instance

        # We are attaching to a root container instance.
        # We know this because we haven't been extended as a nested instance.
        when ::Magnets::Bindings::Container::ObjectInstance
          
          case binding_instance
            
            when ::Magnets::Bindings::InstanceBinding

              child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__
            
            when ::Magnets::Bindings::ClassBinding
          
              # We need instance bindings corresponding to the declared class bindings
              child_instance = binding_instance.class::InstanceBinding.new( binding_instance )
              child_instance.__initialize_for_bound_container__( instance )

              # whenever a view is set we want it to be set as nested (if appropriate)
              if container = child_instance.__container__
                container.extend( ::Magnets::Bindings::Container::ObjectInstance::Nested )
                ::CascadingConfiguration::Variable.register_child_for_parent( container,
                                                                              child_instance )
              end

          end
          
        # We are attaching to a nested instance binding
        when ::Magnets::Bindings::InstanceBinding

          case binding_instance
            
            when ::Magnets::Bindings::InstanceBinding

              child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__
            
            when ::Magnets::Bindings::ClassBinding

              child_instance = binding_instance.class::InstanceBinding.new( binding_instance )
              child_instance.__initialize_for_bound_container__( instance )
              
              if container = child_instance.__container__
                container.extend( ::Magnets::Bindings::Container::ObjectInstance::Nested )
                ::CascadingConfiguration::Variable.register_child_for_parent( container,
                                                                              binding_instance )
              end

          end
        
        else

          raise ::RuntimeError, 'Unexpected binding type (' + instance.to_s + ')!'
          
      end
      
      return child_instance

    end

  end

  ccm.alias_module_and_instance_methods( self, :bindings, :__bindings__ )

  #########################
  #  binding_aliases      #
  #  __binding_aliases__  #
  #########################

	attr_configuration_hash  :__binding_aliases__
	
  ccm.alias_module_method( self, :binding_aliases, :__binding_aliases__ )

  #########################
  #  shared_bindings      #
  #  __shared_bindings__  #
  #########################

	attr_configuration_hash  :__shared_bindings__ do

	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( shared_alias_name, shared_binding_instance )

      # get the shared instance from the same route in self
      binding_route = shared_binding_instance.__route__

      shared_context = ::Magnets::Bindings::Container.context( shared_alias_name,
                                                               configuration_instance, 
                                                               binding_route,
                                                               shared_alias_name )
      
      return shared_context.__binding__( shared_alias_name )

    end
  
  end

  ccm.alias_module_and_instance_methods( self, :shared_bindings, :__shared_bindings__ )
  
	#################
  #  binding      #
  #  __binding__  #
  #################
    
  def __binding__( binding_name )
    
    binding_instance = nil
    
    unless binding_instance = __bindings__[ binding_name ]
      
      if binding_alias = __binding_aliases__[ binding_name ]
      
        binding_instance = __bindings__[ binding_alias ]

      else

        binding_instance = __shared_bindings__[ binding_name ]

      end      
      
    end
    
    return binding_instance
    
  end
  alias_method  :binding, :__binding__

  ##################
  #  has_binding?  #
  ##################

  # has_binding? :name, ...
  # 
	def has_binding?( binding_name )
		
		has_binding = false
		
		# if we have binding, alias, or re-binding
		if 	__bindings__.has_key?( binding_name )        or 
		    __binding_aliases__.has_key?( binding_name ) or
		    __shared_bindings__.has_key?( binding_name )
		
			has_binding = true
		
		end
		
		return has_binding
		
	end

  #############################
  #  configuration_procs      #
  #  __configuration_procs__  #
  #############################
                              
  attr_instance_configuration_unique_array  :__configuration_procs__

  ccm.alias_module_and_instance_methods( self, :configuration_procs, :__configuration_procs__ )

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  def __configure__( & configuration_proc )
        
    __configuration_procs__.push( configuration_proc )
    
  end

  alias_method( :configure, :__configure__ )
  
end
