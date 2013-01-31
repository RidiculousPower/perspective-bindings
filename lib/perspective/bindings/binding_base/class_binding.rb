
module ::Perspective::Bindings::BindingBase::ClassBinding

  include ::Perspective::Bindings::BindingBase
    
  include ::CascadingConfiguration::Setting
  include ::CascadingConfiguration::Array::Unique

  ################
  #  initialize  #
  ################

  def initialize( bound_container, binding_name, ancestor_binding = nil, & configuration_proc )

    @__bound_container__ = bound_container

    @__root__ = @__bound_container__.__root__

    if ancestor_binding
      @__parent_binding__ = ancestor_binding
      ::CascadingConfiguration.register_parent( self, ancestor_binding )
      __initialize_route__
    else
      __initialize_defaults__( binding_name )
    end
    
    __configure__( & configuration_proc ) if block_given?
    
  end

  #############################
  #  __initialize_defaults__  #
  #############################

  def __initialize_defaults__( binding_name )

    __validate_binding_name__( binding_name )

    self.__name__ = binding_name

    __initialize_route__    
    
  end
  
  ##########################
  #  __initialize_route__  #
  ##########################
  
  def __initialize_route__
    
    if @__bound_container__.equal?( @__root__ )
      route_with_name = self.__route_with_name__ = [ __name__ ]
    else
      base_route = self.__route__ = @__bound_container__.__route_with_name__.dup
      route_with_name = self.__route_with_name__ = base_route.dup
      route_with_name.push( __name__ )
    end

    self.__route_string__ = route_string = ::Perspective::Bindings.context_string( route_with_name )
    self.__route_print_string__ = ::Perspective::Bindings.context_print_string( @__root__, route_string )
    
  end

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
  
  ###############################
  #  __validate_binding_name__  #
  ###############################

  def __validate_binding_name__( binding_name )
  
    if ::Perspective::Bindings::ProhibitedNames.has_key?( binding_name.to_sym )
      raise ::ArgumentError, 'Cannot declare :' + binding_name.to_s + ' as a binding - ' +
                             'prohibited for verbosity, since resulting errors are often not ' + 
                             'self-explanatory and therefore very difficult to debug.'
    end
  
  end
  
end
