
module ::Magnets::Binding::Container::ClassInstance::Creation
  
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ##################################
  #  __create_bindings_for_args__  #
  ##################################

	def __create_bindings_for_args__( class_binding_type, 
	                                  permits_multiple, 
	                                  *args, 
	                                  & configuration_proc )

	  bindings = [ ]
    
	  until args.empty?
      
      next_arg = args.shift
      
      case next_arg
        
        when ::Hash
        
          these_bindings = __create_bindings_for_hash__( class_binding_type, 
                                                         permits_multiple,
                                                         next_arg, 
                                                         & configuration_proc )
          bindings.concat( these_bindings )
        
        when ::Symbol, ::String
        
          binding_names = [ next_arg ]
        
          view_class = nil
        
          until args.empty?
          
            next_arg = args.shift
          
            case next_arg
            
              when ::Hash
            
                these_bindings = __create_bindings_for_hash__( class_binding_type,
                                                               permits_multiple,
                                                               next_arg, 
                                                               & configuration_proc )
                bindings.concat( these_bindings )
                break
            
              when ::Symbol, ::String
            
                binding_names.push( next_arg )
            
              else
            
                view_class = next_arg                
                break
            
            end
          
          end
          
          binding_names.each do |this_binding_name|
            this_binding = __create_binding__( class_binding_type, 
                                               permits_multiple,
                                               this_binding_name, 
                                               view_class, 
                                               & configuration_proc )
            bindings.push( this_binding )
          end
                
        else
        
          raise ::ArgumentError, 'Got View argument without binding name.'
        
      end
    
    end
    
    return bindings
    
  end

  ##################################
  #  __create_bindings_for_hash__  #
  ##################################

  def __create_bindings_for_hash__( class_binding_type, 
                                    permits_multiple, 
                                    hash_instance, 
                                    & configuration_proc )
    
    bindings = [ ]
    
    hash_instance.each do |this_binding_name, this_view_class|
      this_binding = __create_binding__( class_binding_type, 
                                         permits_multiple,
                                         this_binding_name, 
                                         this_view_class, 
                                         & configuration_proc )
      bindings.push( this_binding )
    end
    
    return bindings
    
  end

  ########################
  #  __create_binding__  #
  ########################

  def __create_binding__( class_binding_type, 
                          permits_multiple, 
                          binding_name, 
                          view_class, 
                          & configuration_proc )

    if has_binding?( binding_name )
		  raise ::Magnets::Binding::Exception::BindingAlreadyDefinedError,
		          'Binding already defined for :' + binding_name.to_s + ' in instance ' +
		          self.inspect + '.'
    end

    new_class_binding = class_binding_type.new( binding_name, view_class, & configuration_proc )
    
    # Now we subclass instance binding for this binding declaration so that we can configure 
    # instance binding instances ahead of time (since they are created on each request).
    
    
    new_instance_binding_class = nil
    
    if permits_multiple
      new_instance_binding_class = ::Class.new( class_binding_type::Instance::Multiple )
    else
      new_instance_binding_class = ::Class.new( class_binding_type::Instance )
    end
    
		__bindings__[ binding_name ] = binding_instance

    declare_class_binding_getter( binding_name )
		declare_binding_setter( binding_name )
		declare_binding_getter( binding_name )
    
    return new_class_binding
    
	end
  
end
