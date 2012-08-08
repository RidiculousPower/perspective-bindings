
module ::Perspective::Bindings::Container::ClassAndObjectInstance
  
  ###############
  #  route      #
  #  __route__  #
  ###############

  def __route__
    
    route = nil
    
    if @__parent_binding__
      route = @__parent_binding__.__route__
    end
    
    return route
    
  end

  alias_method( :route, :__route__ )
  
  #########################
  #  route_with_name      #
  #  __route_with_name__  #
  #########################

  def __route_with_name__
    
    route = nil
    
    if @__parent_binding__
      route = @__parent_binding__.__route_with_name__
    end
    
    return route
    
  end

  alias_method( :route_with_name, :__route_with_name__ )

  ######################
  #  route_string      #
  #  __route_string__  #
  ######################

  def __route_string__
    
    route = nil
    
    if @__parent_binding__
      route = @__parent_binding__.__route_string__
    end
    
    return route
    
  end

  alias_method( :route_string, :__route_string__ )

  ############################
  #  route_print_string      #
  #  __route_print_string__  #
  ############################

  def __route_print_string__
    
    route = nil
    
    if @__parent_binding__
      route = @__parent_binding__.__route_print_string__
    else
      route = ::Perspective::Bindings::RootString
    end
    
    return route
    
  end

  alias_method( :route_print_string, :__route_print_string__ )
  
end

