
module ::Magnets::Bindings::ClassBinding::NestedClassBinding

  ##########################
  #  __initialize_route__  #
  ##########################
  
  def __initialize_route__( bound_container )
    
    # We need to track the route where this binding is nested - 
    # this is simply the binding path from the root container to this nested binding.
    
    base_route = nil
    route_with_name = nil

    if container_route_with_name = bound_container.__route_with_name__
      base_route = container_route_with_name.dup
      route_with_name = base_route.dup
    else
      route_with_name = [ ]
    end

    route_with_name.push( __name__ )

    self.__route__ = base_route
    self.__route_with_name__ = route_with_name

    self.__route_with_name__ = route_with_name
    self.__route_string__ = route_string = ::Magnets::Bindings.context_string( route_with_name )
    self.__route_print_string__ = ::Magnets::Bindings.context_print_string( route_string )
    
  end
  

end
