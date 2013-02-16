
module ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding

  include ::CascadingConfiguration::Setting
  include ::Perspective::Bindings::Container::Configuration
  include ::Perspective::Bindings::Container::ObjectAndBindingInstance
  
  ################
  #  initialize  #
  ################
  
  ###
  # 
  # @overload new( bound_container, binding_name, container_class = nil, & configuration_proc )
  # @overload new( bound_container, ancestor_binding )
  #
  def initialize( bound_container, *args, & configuration_proc )
    
    super( bound_container, *args, & configuration_proc )

    __initialize_for_container_class__( container_class = args[ 1 ] )
    
  end
  
  ########################################
  #  __initialize_for_container_class__  #
  ########################################
  
  def __initialize_for_container_class__( container_class )
  
    if container_class or container_class = __container_class__
      extend( container_class::Controller::ClassBindingMethods )
      unless @__parent_binding__
        __validate_container_class__( self.__container_class__ = container_class )
        # if we have a parent binding then it has already registered the container class as a parent
        # and we have already registered it as our parent, so we don't want to replace it
        ::CascadingConfiguration.register_parent( self, container_class )
      end
    end
  
  end

  ##################################
  #  __validate_container_class__  #
  ##################################

  def __validate_container_class__( container_class )
    	  
		unless container_class.respond_to?( :__bindings__ )
  		raise ::Perspective::Bindings::Exception::ContainerClassLacksBindings,
  		        'Class ' + container_class.to_s + ' was declared as a container class, ' +
  		        'but does not respond to :' + :__bindings__.to_s + '.'
	  end
    
  end

  #########################
  #  __container_class__  #
  #########################

  attr_configuration  :__container_class__

  #####################
  #  container_class  #
  #####################

  Controller.alias_module_and_instance_methods( :container_class, :__container_class__ )
  
  ######################
  #  __nested_route__  #
  ######################
  
  ###
  # Get route to binding (self) from parent container where self is nested.
  #   Assumes that both bindings share a common root.
  #
  def __nested_route__( nested_in_container )
    
    nested_route = nil
    
    # our route: <root>-route-to-binding
    # nested route: <root>-route-to-binding-nested-in-self
    # result desired: nested-in-self
    
    if nested_in_container.__is_root__?
      nested_route = __route__
    else
      slice_off_start_route = nested_in_container.__route_with_name__
      slice_size = slice_off_start_route.size
      route_from_root = __route__
      route_from_root_size = route_from_root.size
      remaining_route_size = route_from_root_size - slice_size
      if remaining_route_size > 0
        nested_route = __route__.slice( slice_size, remaining_route_size )
      end
    end
    
    return nested_route
    
  end
  
end
