
module ::Magnets::Bindings::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique
  include ::CascadingConfiguration::Hash

  ccm = ::CascadingConfiguration::Methods
    
  ########################
  #  parent_binding      #
  #  __parent_binding__  #
  ########################

  attr_reader  :__parent_binding__

  alias_method  :parent_binding, :__parent_binding__

  ######################
  #  nested_route      #
  #  __nested_route__  #
  ######################

  def __nested_route__( nested_binding )

    # our route: <root>-route-to-binding
    # nested route: <root>-route-to-binding-nested-in-self
    # result desired: nested-in-self
    
    nested_route_from_self = nil
    
    if route = __route__
      
      # our own route plus our name, which is part of the nested route but not part of our route
      nested_depth_of_self = route.count + 1
      
      # route from root to nested binding
      nested_route_from_root = nested_binding.__route__
      nested_route_length = nested_route_from_root.count

      # slice from the end of our own route to the end of nested route
      remaining_route_length = nested_route_length - nested_depth_of_self
      nested_route_from_self = nested_route_from_root.slice( nested_depth_of_self, 
                                                             remaining_route_length )
      
    elsif respond_to?( :__name__ )
      
      nested_binding_route = nested_binding.__route__
      nested_route_from_self = nested_binding_route.slice( 1, nested_binding_route.count - 1 )
      
    else
      
      nested_route_from_self = nested_binding.__route__
      
    end
    

    return nested_route_from_self
    
  end
  
  alias_method  :nested_route, :__nested_route__
  
  ##################
  #  bindings      #
  #  __bindings__  #
  ##################

	attr_configuration_hash  :__bindings__ do

	  #=========================#
	  #  initialize_for_parent  #
	  #=========================#

    def initialize_for_parent( parent )
      
      super
      
      if configuration_instance.respond_to?( :__configure_bindings__ )
        configuration_instance.__configure_bindings__
      end
      
    end

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
          child_instance = binding_instance.class.new( instance, nil, nil, binding_instance)

        # We are attaching to a nested container class binding.
        when ::Magnets::Bindings::ClassBinding
          
          # Create a new binding without any settings - causes automatic lookup to parent.
          child_instance = binding_instance.class::NestedClassBinding.new( instance, 
                                                                           nil, 
                                                                           nil, 
                                                                           binding_instance)

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
              child_instance = binding_instance.class::InstanceBinding.new( binding_instance, 
                                                                            instance )

          end
            
        # We are attaching to a nested instance binding
        when ::Magnets::Bindings::InstanceBinding
          
          binding_class = binding_instance.class::NestedInstanceBinding
          child_instance = binding_class.new( binding_instance, instance.__container__ )
        
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

  ###################################
  #  local_aliases_to_bindings      #
  #  __local_aliases_to_bindings__  #
  ###################################

	attr_configuration_hash  :__local_aliases_to_bindings__ do

	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( local_alias_to_binding, binding_instance )

      # get the shared instance from the same route in self
      nested_binding_route = configuration_instance.__nested_route__( binding_instance )

      puts 'self: ' + configuration_instance.to_s
      puts 'self route: ' + configuration_instance.__route__.to_s
      puts 'self name: ' + configuration_instance.__name__.to_s if configuration_instance.respond_to?( :__name__ )

      puts 'nested binding name: ' + binding_instance.__name__.to_s
      puts 'nested binding route: ' + binding_instance.__route__.to_s

      puts 'nested route: ' + nested_binding_route.to_s

      child_instance = ::Magnets::Bindings.aliased_binding_in_context( configuration_instance, 
                                                                       nested_binding_route,
                                                                       binding_instance.__name__,
                                                                       local_alias_to_binding,
                                                                       binding_instance )
      
      return child_instance

    end
  
  end

  ccm.alias_module_and_instance_methods( self, :local_aliases_to_bindings, 
                                               :__local_aliases_to_bindings__ )
  
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

        binding_instance = __local_aliases_to_bindings__[ binding_name ]

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
		    __local_aliases_to_bindings__.has_key?( binding_name )
		
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
