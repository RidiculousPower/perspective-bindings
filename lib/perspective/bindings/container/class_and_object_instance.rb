
module ::Perspective::Bindings::Container::ClassAndObjectInstance
  
  #####################
  #  __root_string__  #
  #####################

  def __root_string__
    
    # [root:<instance>]    
    
    root_string = nil
    
    if __root__ == self
      root_string = @__root_string__ ||= '[' << __root__.to_s << ']'
    else
      root_string = __root__.__root_string__
    end

    return root_string
    
  end

  ######################
  #  route_string      #
  #  __route_string__  #
  ######################

  def __route_string__
    
    route_string = nil
    
    if @__parent_binding__
      route_string = @__parent_binding__.__route_string__
    end
    
    return route_string
    
  end

  alias_method( :route_string, :__route_string__ )

  ############################
  #  route_print_string      #
  #  __route_print_string__  #
  ############################

  def __route_print_string__

    route_print_string = nil
    
    if @__parent_binding__
      route_print_string = @__parent_binding__.__route_print_string__
    else
      if __route_string__
        @__route_print_string__ ||= ::Perspective::Bindings.context_print_string( __root__, __route_string__ )
        route_print_string = @__route_print_string__
      else
        route_print_string = __root_string__
      end
    end
    
    return route_print_string
    
  end

  alias_method( :route_print_string, :__route_print_string__ )
  
  
end

