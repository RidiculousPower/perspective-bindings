
module ::Magnets::Binding::Container::Context
  
  #############
  #  context  #
  #############

  def context( shared_alias_name, starting_context, binding_route, accessor )

    binding_context = starting_context
    
    route_successfully_mapped = [ ]
    
    binding_route.each_with_index do |this_binding_route_part, index|

      unless binding_context.respond_to?( this_binding_route_part )
    		raise ::Magnets::Binding::Exception::NoBindingError,
      		      starting_context.to_s + ' does not have route :' + 
      		      binding_route.slice( 0, index ).join( '.' ) + '.' + "\n\n" +
      		      'Shared binding route :' + this_binding_route_part.to_s + 
      		      ' was inaccessible in context :' + route_successfully_mapped.join( '.' ) +
        	      ' (' + binding_context.inspect + '). '
      end
      
      if binding_context.respond_to?( :__binding__ )
        binding_context = binding_context.__binding__( this_binding_route_part )
      else
        binding_context = binding_context.__value__( this_binding_route_part )
      end

      route_successfully_mapped.push( this_binding_route_part )

    end

    unless binding_context.respond_to?( accessor )
  		raise ::Magnets::Binding::Exception::NoBindingError,
      	      'No accessor :' + accessor.to_s + ' defined ' + 'in ' + 
      	      ( [ binding_context.inspect ] + binding_route ).join( '.' ) + '.' + "\n\n" + 
      	      'Shared binding :' + shared_alias_name.to_s + ' was inaccessible in ' + 
      	      self.to_s + '.'
    end
    
    return binding_context
    
  end
  
end
