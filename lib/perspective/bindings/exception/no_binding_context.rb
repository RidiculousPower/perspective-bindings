# -*- encoding : utf-8 -*-

class ::Perspective::Bindings::Exception::NoBindingContext < ::ArgumentError
  
  ################
  #  initialize  #
  ################
  
  def initialize( starting_context, current_context, binding_name, remaining_route = nil )
    
    starting_context_inspect = nil
    
    exception_string =  'Binding context ' << starting_context.«route_print_string
    exception_string << ' (' << starting_context.to_s << ') does not have binding :' << 
                     binding_name.to_s
    
    current_context_route = nil
    if current_context
      current_context_route = current_context.«route_string
    end
    
    full_route_string = ::Perspective::Bindings.context_print_string( current_context,
                                                                      current_context_route, 
                                                                      remaining_route )
    exception_string << ' requested in route ' << full_route_string
    
    exception_string << '.'

    super( exception_string )
    
  end
  
end
