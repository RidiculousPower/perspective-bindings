
module ::Magnets::Bindings::ClassBinding::NestedClassBinding

  ################
  #  initialize  #
  ################

  def initialize( bound_container, 
                  binding_name,
                  container_class = nil, 
                  ancestor_binding = nil,
                  & configuration_proc )
        
    @__parent_binding__ = bound_container
    @__bound_container__ = bound_container
    @__bound_container_class__ = bound_container.__container_class__

    super
        
  end
                
  ##########################
  #  __initialize_route__  #
  ##########################
  
  def __initialize_route__
    
    # We need to track the route where this binding is nested - 
    # this is simply the binding path from the root container to this nested binding.
    
    base_route = nil
    route_with_name = nil

    if container_route_with_name = @__parent_binding__.__route_with_name__
      base_route = container_route_with_name.dup
      route_with_name = base_route.dup
    else
      route_with_name = [ ]
    end

    route_with_name.push( __name__ )

    self.__route__ = base_route
    self.__route_with_name__ = route_with_name

    self.__route_string__ = route_string = ::Magnets::Bindings.context_string( route_with_name )
    self.__route_print_string__ = ::Magnets::Bindings.context_print_string( route_string )
    
  end
  
  ######################
  #  nested_route      #
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

    nested_route_from_self = nested_route_from_root.slice( nested_depth_of_start, 
                                                           remaining_route_length )
    
    return nested_route_from_self
    
  end
  
  alias_method  :nested_route, :__nested_route__

end
