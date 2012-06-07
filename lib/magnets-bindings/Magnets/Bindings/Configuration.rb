
module ::Magnets::Bindings::Configuration

  extend ::Magnets::Bindings::Container::Context

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

  ############################
  #  route_print_string      #
  #  __route_print_string__  #
  ############################

  attr_configuration  :__route_print_string__

  ccm.alias_module_and_instance_methods( self, :route_print_string, :__route_print_string__ )

  self.__route_print_string__ = context_print_string

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
          child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__

        # We are attaching to a nested container class binding.
        when ::Magnets::Bindings::ClassBinding

          base_route = nil

          # We need to track the route where this binding is nested - 
          # this is simply the binding path from the root container to this nested binding.
          if route = instance.__route__
            base_route = route.dup
          else
            base_route = [ ]
          end
          base_route.push( instance.__name__ )
          
          # Create a new binding without any settings - causes automatic lookup to parent.
          child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__( base_route )

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

          child_instance = binding_instance.class::InstanceBinding.new( binding_instance,
                                                                        instance.__container__ )
        
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
      binding_route = binding_instance.__route__

      child_instance = ::Magnets::Bindings.aliased_binding_in_context( configuration_instance, 
                                                                       binding_route,
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
