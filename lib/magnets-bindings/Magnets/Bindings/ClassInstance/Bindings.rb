
module ::Magnets::Bindings::ClassInstance::Bindings

  include Methods

  include Binding
  include Class
  include Complex
  include File
  include Float
  include Integer
  include Module
  include Number
  include Rational
  include Regexp
  include Text
  include TextOrNumber
  include TrueFalse

  include Mixed
    
  #########################################  Status  ###############################################
	
  ##################
  #  has_binding?  #
  ##################

  # has_binding? :name, ...
  # 
	def has_binding?( binding_name )
		
		has_binding = false
		
		# if we have binding, alias, or re-binding
		if 	__bindings__.has_key?( binding_name )        or 
		    __shared_bindings__.has_key?( binding_name ) or
		    __binding_aliases__.has_key?( binding_name )
		
			has_binding = true
		
		end
		
		return has_binding
		
	end

	########################################  Bindings  ##############################################

  ###############################
  #  __binding_configuration__  #
  ###############################

	def __binding_configuration__( binding_name )
		
		if __binding_aliases__.has_key?( binding_name )

		  binding_name = __binding_aliases__[ binding_name ]

	  end
	  
	  unless binding_instance = __bindings__[ binding_name ]
      
      binding_instance = __shared_bindings__[ binding_name ]
      
    end
    
		return binding_instance
		
	end

	########################################  Unbinding  #############################################

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
        
        elsif binding_instance = __shared_bindings__.delete( this_binding_name )
          
          # nothing else to do here
          
        else

      		binding_instance = __bindings__.delete( this_binding_name )
        
          # if we defined a corresponding view at the same time as our binding (we probably did)
          # then remove it as well
          if corresponding_binding = binding_instance.__corresponding_view_binding__
            attr_unbind( corresponding_binding.__name__ )
          end
        
        end
      
    		# delete any aliases for this one
        __binding_aliases__.delete_if { |key, value| value == this_binding_name }

        remove_binding_methods( this_binding_name )

        # now tell each child to remove the binding
        ::CascadingConfiguration::Ancestors.children( self ).each do |this_child_bindings_module|
          this_child_bindings_module.attr_unbind( this_binding_name )
        end

      end
      
		end
		
		return self
		
	end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ##################################
  #  __create_bindings_for_args__  #
  ##################################

	def __create_bindings_for_args__( *args, & configuration_proc )

	  bindings = [ ]
    
	  until args.empty?
      
      next_arg = args.shift
      
      case next_arg
        
        when ::Hash
        
          these_bindings = __create_bindings_for_hash__( next_arg, & configuration_proc )
          bindings.concat( these_bindings )
        
        when ::Symbol, ::String
        
          binding_names = [ next_arg ]
        
          view_class = nil
        
          until args.empty?
          
            next_arg = args.shift
          
            case next_arg
            
              when ::Hash
            
                these_bindings = __create_bindings_for_hash__( next_arg, & configuration_proc )
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
            this_binding = __create_binding__( this_binding_name, view_class, & configuration_proc )
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

  def __create_bindings_for_hash__( hash_instance, & configuration_proc )
    
    bindings = [ ]
    
    hash_instance.each do |this_binding_name, this_view_class|
      this_binding = __create_binding__( this_binding_name, this_view_class, & configuration_proc )
      bindings.push( this_binding )
    end
    
    return bindings
    
  end

  ########################
  #  __create_binding__  #
  ########################

  def __create_binding__( binding_name, view_class, & configuration_proc )

    if has_binding?( binding_name )
		  raise ::Magnets::Bindings::Exception::BindingAlreadyDefinedError,
		          'Binding already defined for :' + binding_name.to_s + ' in instance ' +
		          self.inspect + '.'
    end
    
    new_binding = ::Magnets::Bindings::Binding.new( self, 
                                                    binding_name, 
                                                    view_class, 
                                                    & configuration_proc )
    
    __create_binding_with_instance__( new_binding )
    
    return new_binding
    
	end
  
	######################################
  #  __create_binding_with_instance__  #
  ######################################

  def __create_binding_with_instance__( binding_instance )
    
    binding_name = binding_instance.__name__
    
		__bindings__[ binding_name ] = binding_instance
		
    declare_class_binding_getter( binding_name )
		declare_binding_setter( binding_name )
		declare_binding_getter( binding_name )
    
    return self
    
  end
  
end
