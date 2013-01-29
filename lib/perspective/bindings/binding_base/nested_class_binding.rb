
module ::Perspective::Bindings::BindingBase::NestedClassBinding

  include ::Perspective::Bindings::BindingBase::ClassBinding
                
  ##########################
  #  __initialize_route__  #
  ##########################
  
  def __initialize_route__
    
    @__root__ = @__bound_container__.__root__
    
    # We need to track the route where this binding is nested - 
    # this is simply the binding path from the root container to this nested binding.
    
    base_route = nil
    route_with_name = nil

    self.__route__ = base_route = @__bound_container__.__route_with_name__.dup
    self.__route_with_name__ = route_with_name = base_route.dup

    route_with_name.push( __name__ )

    self.__route_string__ = route_string = ::Perspective::Bindings.context_string( route_with_name )
    self.__route_print_string__ = ::Perspective::Bindings.context_print_string( __root__, route_string )
    
  end
  
  ######################
  #  __nested_route__  #
  ######################

  def __nested_route__( nested_in_binding )
    
    # our route: <root>-route-to-binding
    # nested route: <root>-route-to-binding-nested-in-self
    # result desired: nested-in-self

    nested_route_from_self = nil

    # our own route plus our name, which is part of the nested route but not part of our route
    nested_depth_of_start = 0
    if route_of_start_depth = nested_in_binding.__route_with_name__
      nested_depth_of_start = route_of_start_depth.count
    end
    
    # route from root to nested binding
    nested_route_from_root = __route_with_name__
    nested_route_length = nested_route_from_root.count

    # slice from the end of our own route to the end of nested route
    # also slice off the name at the end of our route
    remaining_route_length = nested_route_length - nested_depth_of_start - 1

    nested_route_from_self = nested_route_from_root.slice( nested_depth_of_start, remaining_route_length )
    
    return nested_route_from_self
    
  end
  
end
