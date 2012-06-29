
module ::Magnets::Bindings::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique
  include ::CascadingConfiguration::Hash

  ########################
  #  parent_binding      #
  #  __parent_binding__  #
  ########################

  attr_reader  :__parent_binding__

  alias_method  :parent_binding, :__parent_binding__

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

          raise ::RuntimeError, 'Unexpected binding container type (' + instance.to_s + ')!'
          
      end
      
      return child_instance

    end
    
  end

  Controller.alias_module_and_instance_methods( :bindings, :__bindings__ )

  #########################
  #  binding_aliases      #
  #  __binding_aliases__  #
  #########################

	attr_configuration_hash  :__binding_aliases__
	
  Controller.alias_module_method( :binding_aliases, :__binding_aliases__ )

  ###################################
  #  local_aliases_to_bindings      #
  #  __local_aliases_to_bindings__  #
  ###################################

	attr_configuration_hash  :__local_aliases_to_bindings__ do

	  #=========================#
	  #  initialize_for_parent  #
	  #=========================#

    def initialize_for_parent( parent )
      
      # make sure that :__bindings__ and :__binding_aliases__ are initialized first
      # ensure_configurations_initialize_first :__bindings__, :__binding_aliases__
      
      super

      if configuration_instance.respond_to?( :__configure_bindings__ )
        configuration_instance.__configure_bindings__
      end
      
    end

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

  Controller.alias_instance_method( :configuration_procs, :__configuration_procs__ )

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  def __configure__( & configuration_proc )
        
    __configuration_procs__.push( configuration_proc )
    
  end

  alias_method( :configure, :__configure__ )
  
end
