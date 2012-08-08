
module ::Perspective::Bindings::Container::Context
  
  #############
  #  context  #
  #############

  def context( starting_context, binding_route )

    current_context = starting_context

    binding_route.each_with_index do |this_binding_name, index|
      
      if requested_context = current_context.__binding__( this_binding_name )
        
        current_context = requested_context
        
      else
        
        remaining_route = nil
        if remaining_route_parts = binding_route.count - index 
          remaining_route = binding_route.slice( index + 1, remaining_route_parts - 1 )
        end
    		raise ::Perspective::Bindings::Exception::NoBindingContext.new( starting_context, 
    		                                                            current_context, 
    		                                                            this_binding_name,
    		                                                            remaining_route )
      end
            
    end
    
    return current_context
    
  end

  ########################
  #  binding_in_context  #
  ########################
  
  def binding_in_context( starting_context, binding_route, binding_name )
    
    binding_context = context( starting_context, binding_route )
    
    unless binding_instance = binding_context.__binding__( binding_name )
      
      raise ::Perspective::Bindings::Exception::NoBindingError.new( binding_context, 
                                                                binding_name, 
                                                                starting_context )
  		
    end
    
    return binding_instance
    
  end

  ################################
  #  aliased_binding_in_context  #
  ################################
  
  def aliased_binding_in_context( starting_context, 
                                  binding_route, 
                                  binding_name, 
                                  local_alias = nil,
                                  local_alias_binding_instance = nil )

    binding_context = context( starting_context, binding_route )

    unless binding_instance = binding_context.__binding__( binding_name )

  		raise ::Perspective::Bindings::Exception::NoBindingError.new( binding_context, 
  		                                                          binding_name,
  		                                                          starting_context,
  		                                                          local_alias,
  		                                                          local_alias_binding_instance )

    end

    return binding_instance

  end
  
  ####################
  #  context_string  #
  ####################

  def context_string( *contexts )
    
    return_context_string = ''
    
    contexts.each do |this_context|

      unless return_context_string.empty?
        return_context_string << ::Perspective::Bindings::RouteDelimiter
      end

      case this_context

        when ::Array

          return_context_string << this_context.join( ::Perspective::Bindings::RouteDelimiter )

        when ::String

          return_context_string << this_context

        when ::Symbol

          
          return_context_string << this_context.to_s

        when ::Perspective::Bindings::Configuration

          if return_context_string.empty?
            return_context_string << this_context.__name__
          else
            return_context_string << this_context.__route_string__
          end

      end

    end
    
    return return_context_string
    
  end
  
  ##########################
  #  context_print_string  #
  ##########################
  
  def context_print_string( *contexts )
    
    print_string =  ::Perspective::Bindings::ContextPrintPrefix.dup

    print_string << ::Perspective::Bindings::RootString

    case contexts.count
      
      when 0

        # nothing more to do
      
      when 1

        print_string << ::Perspective::Bindings::RouteDelimiter
        print_string << contexts[ 0 ]

      else

        contexts.each do |this_context|
          print_string << ::Perspective::Bindings::RouteDelimiter
          print_string << context_string( this_context )
        end
        
    end
    
    return print_string
    
  end
  
end
