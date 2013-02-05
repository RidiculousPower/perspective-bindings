
module ::Perspective::Bindings::Container::ClassAndObjectInstance
  
  #####################
  #  __root_string__  #
  #####################

  def __root_string__
    
    # [root:<instance>]    

    return @__root_string__ ||= '<root:' << to_s << '>'
    
  end

  ######################
  #  __route_string__  #
  ######################

  def __route_string__
    
    route_string = nil
    
    if @__parent_binding__
      route_string = @__parent_binding__.__route_string__
    end
    
    return route_string
    
  end

  ##################
  #  route_string  #
  ##################

  alias_method( :route_string, :__route_string__ )

  ############################
  #  __route_print_string__  #
  ############################

  def __route_print_string__

    route_print_string = nil
    
    if @__parent_binding__
      route_print_string = @__parent_binding__.__route_print_string__
    else
      unless route_print_string = __route_string__
        @__route_print_string__ ||= ::Perspective::Bindings.context_print_string( __root__, __route_string__ )
        route_print_string = @__route_print_string__
      end
    end
    
    return route_print_string
    
  end

  ########################
  #  route_print_string  #
  ########################

  alias_method( :route_print_string, :__route_print_string__ )
  
  
end

