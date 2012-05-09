
module ::Magnets::Bindings::ClassInstance::Rename

	#########################################  Renaming  #############################################

	#################
  #  attr_rename  #
  #################

  def attr_rename( existing_name, new_name )

    unless has_binding?( existing_name )
  		raise ::Magnets::Bindings::Exception::NoBindingError,
  		      'No binding defined for :' + existing_name.to_s + '.'
    end
	  
    if existing_alias_for_existing_name = __binding_aliases__.delete( existing_name )
      
      remove_binding_methods( existing_name )
      __binding_aliases__.each do |key, value|
        if value == existing_name
          __binding_aliases__[ key ] = new_name
        end
      end
      create_binding_alias( new_name, existing_alias_for_existing_name )
      
    else
    
      existing_binding_instance = __bindings__.delete( existing_name )

      remove_binding_methods( existing_name )
      
      create_corresponding_view = false
      
      if existing_corresponding_instance = existing_binding_instance.__corresponding_view_binding__

        attr_unbind( existing_corresponding_instance.__name__ )
        
        create_corresponding_view = true
        
      end

      __create_binding_with_instance__( new_name, 
                                            existing_binding_instance, 
                                            create_corresponding_view )
      
    end
            
  end


  ####################
  #  method_missing  #
  ####################
  
  def method_missing( method_name, *args )
    
    return_value = nil
    
    if @__binding_redirection_map_for_proc__
      
      binding_name = method_name.accessor_name

      # if our method names a binding, route to the binding
      if binding_instance = @__binding_redirection_map_for_proc__[ binding_name ]
    
        # for a given name we need to know the current path to its equivalent instance
    
        case method_name

          when binding_name

            binding_accessor_name = binding_instance.__name__.accessor_name
            return_value = __binding__( binding_accessor_name, *args )

          when binding_name.write_accessor_name

            binding_write_accessor_name = binding_instance.__name__.write_accessor_name
            return_value = __binding__( binding_write_accessor_name, *args )

        end
      
      end
    
    else
      
      # we didn't capture method - handle as normal
      begin
        super
      rescue Exception => exception
        backtrace_array = exception.backtrace
        missing_method_call_index = 1
        missing_method_call = exception.backtrace[ missing_method_call_index ]
        backtrace_array.unshift( missing_method_call )
        raise exception
      end
      
    end
    
    return return_value
    
  end

end
