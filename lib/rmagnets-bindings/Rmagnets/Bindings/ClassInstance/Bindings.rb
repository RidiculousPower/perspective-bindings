
module ::Rmagnets::Bindings::ClassInstance::Bindings

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
		if 	binding_routers.has_key?( binding_name )        or 
		    shared_binding_routers.has_key?( binding_name ) or
		    binding_aliases.has_key?( binding_name )
		
			has_binding = true
		
		end
		
		return has_binding
		
	end

	########################################  Bindings  ##############################################

  ####################
  #  binding_router  #
  ####################

	def binding_router( binding_name )
		
		binding_router = nil
    
    unless binding_router = shared_binding_routers[ binding_name ]
      binding_router = binding_routers[ binding_name ]
		end
		
		return binding_router
		
  end
  
  ###########################
  #  binding_configuration  #
  ###########################

	def binding_configuration( binding_name )
		
		binding_instance = nil
	
	  if binding_router = shared_binding_routers[ binding_name ]

      binding_instance = binding_router.__binding_instance__

    else

  		if binding_aliases.has_key?( binding_name )

  		  binding_name = binding_aliases[ binding_name ]

  	  end

  		binding_instance = binding_configurations[ binding_name ]
    
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

      unless has_binding?( this_binding_name )
    		raise ::Rmagnets::Bindings::Exception::NoBindingError,
    		      'No binding defined for :' + this_binding_name.to_s + '.'
      end

  		# delete this alias if it is one
  		if aliased_binding = binding_aliases.delete( this_binding_name )
  		  
  		  # we don't automatically delete associated bindings
  		  # nothing else to do
        
      elsif shared_binding_routers.delete( this_binding_name )
        
        # nothing else to do
        
      else

    		binding_instance = binding_configurations.delete( this_binding_name )
        
        # if we defined a corresponding view at the same time as our binding (we probably did)
        # then remove it as well
        if corresponding_binding_name = binding_instance.corresponding_view_binding
          attr_unbind( corresponding_binding_name )
        end
        
      end
      
      binding_routers.delete( this_binding_name )

  		# delete any aliases for this one
      binding_aliases.delete_if { |key, value| value == this_binding_name }

      remove_binding_methods( this_binding_name )
      
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

	def create_bindings_for_args( args, also_create_view_methods = true, & configuration_proc )

	  bindings = [ ]
	  
	  until args.empty?
      
      next_arg = args.shift
      
      case next_arg
        
        when Hash
        
          these_bindings = create_bindings_for_hash( next_arg, 
                                                     also_create_view_methods, 
                                                     & configuration_proc )
          bindings.concat( these_bindings )
        
        when Symbol, String
        
          binding_names = [ next_arg ]
        
          view_class = nil
        
          until args.empty?
          
            next_arg = args.shift
          
            case next_arg
            
              when Hash
            
                these_bindings = create_bindings_for_hash( next_arg, 
                                                           also_create_view_methods,
                                                           & configuration_proc )
                bindings.concat( these_bindings )
                break
            
              when Symbol, String
            
                binding_names.push( next_arg )
            
              else
            
                view_class = next_arg
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
        
          raise ArgumentError, 'Got View argument without binding name.'
        
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
                      also_create_view_methods = true, 
                      & configuration_proc )

    if check_for_existing_binding and has_binding?( binding_name )
		  raise ::Rmagnets::Bindings::Exception::BindingAlreadyDefinedError,
		          'Binding already defined for :' + binding_name.to_s + '.'
    end
    
		new_binding = ::Rmagnets::Bindings::Binding.new( self,
		                                                 binding_name,
		                                                 view_class, 
		                                                 & configuration_proc )
		
	  create_binding_from_configuration( binding_name, 
	                                     new_binding, 
	                                     also_create_view_methods, 
	                                     view_class )
    
    return new_binding
    
	end
  
  #######################################
  #  create_binding_from_configuration  #
  #######################################

  def create_binding_from_configuration( binding_name, 
                                         binding_instance, 
                                         also_create_view_methods = true,
                                         view_class = nil )

		binding_configurations[ binding_name ] = binding_instance
	  
	  binding_routers[ binding_name ] = ::Rmagnets::Bindings::Binding::Router.new( binding_instance )
	  
    declare_class_binding_getter( binding_name )
		declare_binding_setter( binding_name, binding_instance )
		declare_binding_getter( binding_name, binding_instance )
    
    if also_create_view_methods
      view_name = ( binding_name.to_s + '_view' ).to_sym
      binding_instance.corresponding_view_binding = view_name
      attr_view( view_name, view_class )
    end

	end
	 
end