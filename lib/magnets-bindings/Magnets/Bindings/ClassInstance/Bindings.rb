
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
  include TrueFalse
  include View

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
		if 	__binding_configurations__.has_key?( binding_name )        or 
		    __shared_binding_configurations__.has_key?( binding_name ) or
		    __binding_aliases__.has_key?( binding_name )
		
			has_binding = true
		
		end
		
		return has_binding
		
	end

	########################################  Bindings  ##############################################

  ###########################
  #  binding_configuration  #
  ###########################

	def __binding_configuration__( binding_name )
		
		if __binding_aliases__.has_key?( binding_name )

		  binding_name = __binding_aliases__[ binding_name ]

	  end
	  
	  unless binding_instance = __binding_configurations__[ binding_name ]
      
      binding_instance = __shared_binding_configurations__[ binding_name ]
      
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
        
        elsif binding_instance = __shared_binding_configurations__.delete( this_binding_name )
          
          # nothing else to do here
          
        else

      		binding_instance = __binding_configurations__.delete( this_binding_name )
        
          # if we defined a corresponding view at the same time as our binding (we probably did)
          # then remove it as well
          if corresponding_binding_name = binding_instance.__corresponding_view_binding__
            attr_unbind( corresponding_binding_name )
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

	####################################  Defining Bindings  #########################################

  ##############################
  #  create_bindings_for_args  #
  ##############################

	def create_bindings_for_args( args, also_create_view_methods = nil, & configuration_proc )

	  bindings = [ ]
	  
	  until args.empty?
      
      next_arg = args.shift
      
      case next_arg
        
        when ::Hash
        
          these_bindings = create_bindings_for_hash( next_arg, 
                                                     also_create_view_methods, 
                                                     & configuration_proc )
          bindings.concat( these_bindings )
        
        when ::Symbol, ::String
        
          binding_names = [ next_arg ]
        
          view_class = nil
        
          until args.empty?
          
            next_arg = args.shift
          
            case next_arg
            
              when ::Hash
            
                these_bindings = create_bindings_for_hash( next_arg, 
                                                           also_create_view_methods,
                                                           & configuration_proc )
                bindings.concat( these_bindings )
                break
            
              when ::Symbol, ::String
            
                binding_names.push( next_arg )
            
              else
            
                view_class = next_arg
                
                unless view_class.nil?
                  unless also_create_view_methods == false
                    also_create_view_methods = true
                  end
                end
                
                break
            
            end
          
          end
          
          binding_names.each do |this_binding_name|
            this_binding = create_binding( this_binding_name, 
                                           view_class,
                                           true, 
                                           also_create_view_methods, 
                                           & configuration_proc )
            bindings.push( this_binding )
          end
                
        else
        
          raise ::ArgumentError, 'Got View argument without binding name.'
        
      end
    
    end
    
    return bindings
    
  end

  ##############################
  #  create_bindings_for_hash  #
  ##############################

  def create_bindings_for_hash( hash_instance, 
                                also_create_view_methods = true, 
                                & configuration_proc )
    
    bindings = [ ]
    
    hash_instance.each do |this_binding_name, this_view_class|
      binding = create_binding( this_binding_name, 
                                this_view_class, 
                                true, 
                                also_create_view_methods, 
                                & configuration_proc )
      bindings.push( binding )
    end
    
    return bindings
    
  end

  ####################
  #  create_binding  #
  ####################

  def create_binding( binding_name, 
                      view_class, 
                      check_for_existing_binding = true, 
                      also_create_view_methods = false, 
                      & configuration_proc )

    if check_for_existing_binding and has_binding?( binding_name )
		  raise ::Magnets::Bindings::Exception::BindingAlreadyDefinedError,
		          'Binding already defined for :' + binding_name.to_s + ' in instance ' +
		          self.inspect + '.'
    end
    
    if ::Magnets::Bindings::ProhibitedNames.has_key?( binding_name.to_sym )
      raise ::ArgumentError, 'Cannot declare :' + binding_name.to_s + ' as a binding - prohibited' +
                             ' to prevent errors that are very difficult to debug.'
    end
    
		new_binding = ::Magnets::Bindings::Binding.new( self,
		                                                 binding_name,
		                                                 view_class,
		                                                 & configuration_proc )
		
    create_binding_from_binding_instance( binding_name, new_binding, also_create_view_methods )
    
    return new_binding
    
	end
	
	##########################################
  #  create_binding_from_binding_instance  #
  ##########################################

  def create_binding_from_binding_instance( binding_name, 
                                            binding_instance, 
                                            also_create_view_methods )
    
    binding_instance.__name__ = binding_name
    
		__binding_configurations__[ binding_name ] = binding_instance
		
    declare_class_binding_getter( binding_name )
		declare_binding_setter( binding_name )
		declare_binding_getter( binding_name )
    
    if also_create_view_methods

      corresponding_view_name = ( binding_name.to_s + '_view' ).to_sym

      binding_instance.__corresponding_view_binding__ = corresponding_view_name
      
      attr_view( corresponding_view_name, binding_instance.__view_class__ )
      
    end
    
  end
  
end
