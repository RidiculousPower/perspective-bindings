
class ::Magnets::Bindings::Exception::NoBindingContext < ::ArgumentError
  
  ################
  #  initialize  #
  ################
  
  def initialize( starting_context, current_context, remaining_route = nil )
    
    exception_string =  'Binding context ' << starting_context.__route_print_string__
    exception_string << ' (' << starting_context.inspect << ') does not have route ' << 
                        current_context.__route_print_string__
    
    if remaining_route
      context_route_string = current_context.__route_string__
      full_route_string = ::Magnets::Bindings.context_print_string( context_route_string, 
                                                                    remaining_route )
      exception_string << ' requested in route ' << full_route_string
    end
    
    exception_string << '.'

    super( exception_string )
    
  end
  
end
