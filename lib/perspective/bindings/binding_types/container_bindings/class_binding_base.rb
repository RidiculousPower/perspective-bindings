
module ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBindingBase
  
  include ::CascadingConfiguration::Setting
  
  ################
  #  initialize  #
  ################

  def initialize( bound_container, binding_name, container_class = nil, ancestor_binding = nil, & configuration_proc )
    
    super( bound_container, binding_name, ancestor_binding, & configuration_proc )

    __initialize_for_container_class__( container_class )
    
  end
  
  ########################################
  #  __initialize_for_container_class__  #
  ########################################
  
  def __initialize_for_container_class__( container_class )
  
    if container_class or container_class = __container_class__
      __validate_container_class__( self.__container_class__ = container_class )
      extend( container_class::Controller::ClassBindingMethods )
      unless @__parent_binding__
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

  def __nested_route__( nested_in_binding )
    
    nested_route = nil
    
    # our route: <root>-route-to-binding
    # nested route: <root>-route-to-binding-nested-in-self
    # result desired: nested-in-self

    # our own route plus our name, which is part of the nested route but not part of our route
    nested_depth_from_start = 0
    if route_to_nested_binding = nested_in_binding.__route_with_name__
      nested_depth_from_start = route_to_nested_binding.count
    end
    
    # route from root to nested binding
    nested_route_from_root = __route_with_name__
    nested_route_length = nested_route_from_root.count

    # slice from the end of our own route to the end of nested route
    # also slice off the name at the end of our route
    remaining_route_length = nested_route_length - nested_depth_from_start - 1
    
    if remaining_route_length > 0
      nested_route = nested_route_from_root.slice( nested_depth_from_start, remaining_route_length )
    end
    
    return nested_route
    
  end
  
end
