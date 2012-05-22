
module ::Magnets::Bindings::Configuration

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array
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

      case configuration_instance

        when ::Magnets::Bindings::Container::ClassInstance

          # Create a new binding without any settings - causes automatic lookup to superclass.
          # Container classes are always the base of their route.
          child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__

        when ::Magnets::Bindings::ClassBinding

          # Create a new binding without any settings - causes automatic lookup to superclass.
          # Attaching to a class-binding means we are nested, so we need to nest with our route.
          base_route = nil
          if binding_instance.__route__
            base_route = binding_instance.__route__.dup
          else
            base_route = [ ]
          end
          base_route.push( configuration_instance.__name__ )
          child_instance = binding_instance.__duplicate_as_inheriting_sub_binding__( base_route )

        when ::Magnets::Bindings::Container::ObjectInstance, 
             ::Magnets::Bindings::InstanceBinding

          instance_binding_class = binding_instance.class::InstanceBinding

          case binding_instance
            
            when ::Magnets::Bindings::Attributes::Multiple

              child_instance = instance_binding_class::Multiple.new( binding_instance )

            else

              child_instance = instance_binding_class.new( binding_instance )

          end

      end

      return child_instance

    end

  end

  ccm.alias_module_and_instance_methods( self, :bindings, :__bindings__ )

  #######################
  #  binding_order      #
  #  __binding_order__  #
  #######################

  attr_configuration_array  :__binding_order__
  
  ccm.alias_module_and_instance_methods( self, :binding_order, :__binding_order__ )
  
  #######################################
  #  binding_order_declared_empty?      #
  #  __binding_order_declared_empty__?  #
  #######################################
  
  attr_configuration  :__binding_order_declared_empty__?
  
  ccm.alias_module_and_instance_methods( self, :binding_order_declared_empty?, 
                                               :__binding_order_declared_empty__ )
  
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

	attr_module_configuration_hash  :__shared_bindings__ do

	  #======================#
	  #  child_pre_set_hook  #
	  #======================#

	  def child_pre_set_hook( shared_alias_name, shared_binding_instance )

      # get the shared instance from the same route in self
      binding_route = shared_binding_instance.__route__
      shared_context = ::Magnets::Bindings::Container.context( shared_alias_name,
                                                               self, 
                                                               binding_route,
                                                               shared_alias_name )
      
      return binding_context.__binding__( shared_alias_name )

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

  ccm.alias_instance_method( self, :configuration_procs, :__configuration_procs__ )

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  def __configure__( & configuration_proc )
        
    __configuration_procs__.push( configuration_proc )
    
  end

  alias_method( :configure, :__configure__ )
  
end
