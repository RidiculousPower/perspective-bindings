
module ::Perspective::Bindings::InstanceBinding::Interface

  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Hash

  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding, bound_container_instance )
        
    @__parent_binding__ = parent_class_binding
    @__bound_container__ = bound_container_instance
        
    @__root__ = @__bound_container__.__root__
    
    # register parent class binding as ancestor for configurations
    ::CascadingConfiguration.register_parent( self, @__parent_binding__ )

    self.__route_print_string__ = ::Perspective::Bindings.context_print_string( @__root__, __route_string__ )
    
    if container_class = @__parent_binding__.__container_class__
    
      extend( container_class::Controller::InstanceBindingMethods )

      __bindings__.each do |this_binding_name, this_binding_instance|
        this_binding_instance.__configure_container__
      end
    end
    
  end
  
  #########################################
  #  __initialize_container_from_class__  #
  #########################################
  
  def __initialize_container_from_class__( container_class = nil )

    if container_class || container_class = @__parent_binding__.__container_class__

      container_instance = container_class.new
      
      container_instance.__initialize_for_parent_binding__( self )

      __store_initialized_container_instance__( container_instance )

      ::CascadingConfiguration.register_parent( container_instance, self )
      
    end
    
    return container_instance
    
  end
  
  #############################
  #  __configure_container__  #
  #############################
  
  def __configure_container__

    container_instance = __container__
    bound_container = __bound_container__

    # run configuration proc for each binding instance
		__configuration_procs__.each do |this_configuration_proc|
      bound_container.instance_exec( self, & this_configuration_proc )
	  end
	  
	  return self
    
  end
  
  ########################################
  #  __initialize_for_bound_container__  #
  ########################################
  
  def __initialize_for_bound_container__( bound_container )
    
    @__bound_container__ = bound_container
        
  end
  
  ###################
  #  container      #
  #  __container__  #
  ###################

  attr_instance_configuration  :__container__

  Controller.alias_instance_method( :container, :__container__ )

  def __container__
    
    container_instance = nil

    unless container_instance = super

      if container_class = @__parent_binding__.__container_class__

        container_instance = __initialize_container_from_class__
      
      end
    
    end
    
    return container_instance
    
  end

  alias_method( :container, :__container__ )

  ##############################################
  #  container=                                #
  #  __container__=                            #
  #  __store_initialized_container_instance__  #
  ##############################################
  
  alias_method :__store_initialized_container_instance__, :__container__=
  
  def __container__=( container_instance )
    
    super

    container_instance.__initialize_for_parent_binding__( self )

    instance_binding_methods_class = nil
    case container_instance
      when ::Perspective::Bindings::Container::MultiContainerProxy
        if container_instance.count > 0
          instance_binding_methods_class = container_instance[0].class
        end
      else
        instance_binding_methods_class = container_instance.class
    end
    
    extend( instance_binding_methods_class::Controller::InstanceBindingMethods )
    
    # Normal inheritance when container class is defined on class binding is
    # Class Instance => Class Binding => Instance Binding => Container Instance.
    # When container instance is instead provided to instance binding then inheritance is
    # Class Instance => Container Instance => Instance Binding
    ::CascadingConfiguration.replace_parent( self, @__parent_binding__, container_instance )
        
  end

  alias_method( :container=, :__container__= )

  ###############
  #  value      #
  #  __value__  #
  ###############

  attr_reader  :__value__

  alias_method  :value, :__value__

  ################
  #  value=      #
  #  __value__=  #
  ################

  def __value__=( object )
    
    case object
      
      when ::Perspective::Bindings::InstanceBinding

        @__value__ = object.__value__
      
      else

        unless binding_value_valid?( object )
          raise ::Perspective::Bindings::Exception::BindingInstanceInvalidType, 
                  'Invalid value ' <<  object.inspect + ' assigned to binding :' << 
                  __name__.to_s + '.'
        end

        @__value__ = object
        
    end    
    
    __autobind__( @__value__ )

    return object
    
  end

  alias_method  :value=, :__value__=

	########################
	#  autobind_value      #
	#  __autobind_value__  #
	########################
	
	def __autobind_value__( current_value = __value__ )
	  
    return current_value
    
  end
  
  alias_method  :autobind_value, :__autobind_value__

  ##################
  #  autobind      #
  #  __autobind__  #
  ##################
  
  def __autobind__( data_object, method_map_hash = nil )

    # We can't autobind to a container that isn't there yet.
    if container = __container__

      case data_object

        when ::Array
                    
          if permits_multiple?

            if data_object.count - 1 > 0

              binding_value_array = data_object.collect do |this_data_object|
                __autobind_value__( this_data_object )
              end
            
              case container

                when ::Perspective::Bindings::Container::MultiContainerProxy

                  container.__autobind__( *binding_value_array, method_map_hash )

                else

                  new_multi_container = ::Perspective::Bindings::Container::
                                          MultiContainerProxy.new( self, *data_object )
                  self.__store_initialized_container_instance__( new_multi_container )

              end

            else

              container.__autobind__( __autobind_value__( data_object[ 0 ] ), method_map_hash )

            end
          
          end
          
        else
          
          container.__autobind__( __autobind_value__( data_object ), method_map_hash )
          
      end
    
    end
    
  end
  
  alias_method  :autobind, :__autobind__

  ##########################
  #  binding_value_valid?  #
  ##########################

  def binding_value_valid?( binding_value )

    binding_value_valid = false
    
    if binding_value.is_a?( ::Array ) and permits_multiple?
    
      # ensure each member value is valid
      binding_value.each do |this_member|
        
        break unless binding_value_valid = binding_value_valid?( this_member )
        
      end
    
    else
      
      # if we got here (the top) then the only valid value is nil
      binding_value_valid = binding_value.nil?
      
    end
    
    return binding_value_valid
    
  end
  
end
