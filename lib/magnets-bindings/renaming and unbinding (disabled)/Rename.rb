
module ::Magnets::Bindings::Container::ClassInstance::Rename

	#########################################  Renaming  #############################################


	#################
  #  attr_unbind  #
  #################

  # attr_unbind :name, ...
  # 
	def attr_unbind( *binding_names )
  	
		binding_names.each do |this_binding_name|

      if has_binding?( this_binding_name )

    		# delete this alias if it is one
    		if aliased_binding = __binding_aliases__.delete( this_binding_name )
  		  
    		  # we don't automatically delete associated bindings
    		  # nothing else to do
        
        else

      		binding_instance = __bindings__.delete( this_binding_name )
        
        end
      
    		# delete any aliases for this one
        __binding_aliases__.delete_if { |key, value| value == this_binding_name }

        self::ClassBindingMethods.remove_binding( this_binding_name )
        self::InstanceBindingMethods.remove_binding( this_binding_name )

        # now tell each child to remove the binding
        ::CascadingConfiguration::Ancestors.children( self ).each do |this_child_bindings_module|
          this_child_bindings_module.attr_unbind( this_binding_name )
        end

      end
      
		end
		
		return self
		
	end

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
      __create_binding_alias__( new_name, existing_alias_for_existing_name )
      
    else
    
      existing_binding_instance = __bindings__.delete( existing_name )

      remove_binding_methods( existing_name )
      
      create_corresponding_container = false
      
      if existing_corresponding_instance = existing_binding_instance.__corresponding_container_binding__

        attr_unbind( existing_corresponding_instance.__name__ )
        
        create_corresponding_container = true
        
      end

      __create_binding_with_instance__( new_name, 
                                            existing_binding_instance, 
                                            create_corresponding_container )
      
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
