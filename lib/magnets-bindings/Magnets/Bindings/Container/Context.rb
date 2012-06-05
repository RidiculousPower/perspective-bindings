
module ::Magnets::Bindings::Container::Context
  
  #############
  #  context  #
  #############

  def context( shared_alias_name, starting_context, binding_route, binding_name )

    binding_context = starting_context
    
    route_successfully_mapped = [ ]

    binding_route.each_with_index do |this_binding_route_part, index|

      unless binding_context.has_binding?( this_binding_route_part )
    		raise ::Magnets::Bindings::Exception::NoBindingError,
      		      starting_context.inspect + ' does not have route :' + 
      		      binding_route.slice( index, binding_route.count ).join( '.' ) + '.' + "\n\n" +
      		      'Shared binding route :' + this_binding_route_part.to_s + 
      		      ' was inaccessible in context ' + route_successfully_mapped.join( '.' ) +
        	      ' (' + binding_context.inspect + '). '
      end
      
      binding_context = binding_context.__binding__( this_binding_route_part )

      route_successfully_mapped.push( this_binding_route_part )

    end

    unless binding_context.has_binding?( binding_name )
  		raise ::Magnets::Bindings::Exception::NoBindingError,
      	      'No binding :' + binding_name.to_s + ' defined ' + 'in ' + 
      	      ( [ binding_context.inspect ] + binding_route ).join( '.' ) + '.' + "\n\n" + 
      	      'Shared binding :' + shared_alias_name.to_s + ' was inaccessible in ' + 
      	      starting_context.to_s + '.'
    end
    
    return binding_context
    
  end
  
end
