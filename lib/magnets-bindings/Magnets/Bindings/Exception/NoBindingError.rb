
class ::Magnets::Bindings::Exception::NoBindingError < ::ArgumentError
  
  ################
  #  initialize  #
  ################
  
  def initialize( binding_context, 
                  binding_name, 
                  starting_context = nil, 
                  local_alias = nil, 
                  local_alias_binding_instance = nil )
    
    if binding_context and binding_name
      
      exception_string = 'No binding :' << binding_name.to_s << ' found in ' << 
                         binding_context.__route_print_string__
      exception_string << ' (' << binding_context.inspect << ').'
    
    end
    
    if starting_context and local_alias
            
      exception_string << "\n\n" << 
                       'Route for local binding alias :' << local_alias.to_s 
      exception_string << ' in context ' << starting_context.__route_print_string__
      exception_string << ' (' << starting_context.inspect << ') ' << 'could not be resolved.'

    end

    if local_alias_binding_instance
      
      bound_instance = local_alias_binding_instance.__bound_container__

      exception_string << "\n\n" <<
                       'Aliased binding ' << local_alias_binding_instance.__route_print_string__
      exception_string << ' (defined in ' << bound_container.inspect << ') could not be reached.'
    
    end
    
    super( exception_string )
    
  end
  
end
