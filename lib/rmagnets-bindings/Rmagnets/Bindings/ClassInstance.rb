
module ::Rmagnets::Bindings::ClassInstance

	#########################################  Bindings  #############################################

  ###############
  #  attr_view  #
  ###############

  # attr_view :name, ... 
  # attr_view :name => DefaultViewClass, ...
  # attr_view :name, ... { ... configuration proc ... }
  # attr_view :name => DefaultViewClass, ... { ... configuration proc ... }
  # attr_view *binding_names, DefaultViewClass, ... { ... configuration proc ... }
  # 
	def attr_view( *args, & configuration_proc )

    create_bindings_for_args( args, false, false, & configuration_proc )
		
		return self

	end
	alias_method :attr_binding, :attr_view

  ###############
  #  attr_text  #
  ###############

  # attr_text :name, ... 
  # attr_text :name => DefaultViewClass, ...
  # attr_text :name, ... { ... configuration proc ... }
  # attr_text :name => DefaultViewClass, ... { ... configuration proc ... }
  # attr_text *binding_names, DefaultViewClass, ... { ... configuration proc ... }
  # 
	def attr_text( *args, & configuration_proc )

    create_bindings_for_args( args, false, true, & configuration_proc )
		
		return self

	end

  ########################
  #  attr_required_view  #
  ########################

  # attr_required_view :name, ... 
  # attr_required_view :name => DefaultViewClass, ...
  # attr_required_view :name, ... { ... configuration proc ... }
  # attr_required_view :name => DefaultViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_view( *args, & configuration_proc )
		
    create_bindings_for_args( args, true, false, & configuration_proc )
		
		return self
		
	end
	alias_method :attr_required_binding, :attr_required_view

  ########################
  #  attr_required_text  #
  ########################

  # attr_required_text :name, ... 
  # attr_required_text :name => DefaultViewClass, ...
  # attr_required_text :name, ... { ... configuration proc ... }
  # attr_required_text :name => DefaultViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_text( *args, & configuration_proc )
		
    create_bindings_for_args( args, true, true, & configuration_proc )
		
		return self
		
	end

	#################
  #  attr_unbind  #
  #################

  # attr_unbind :name, ...
  # 
	def attr_unbind( *binding_names )
  	
		binding_names.each do |this_binding_name|

  		# delete this alias if it is one
  		if aliased_binding = binding_aliases.delete( this_binding_name )

        # if it was an alias, delete its binding
        attr_unbind( aliased_binding )
        
      elsif shared_binding_routers.delete( this_binding_name )
        
        # nothing else to do
        
      else

    		binding_configurations.delete( this_binding_name )

      end
      
      binding_routers.delete( this_binding_name )

  		# delete any aliases for this one
      binding_aliases.delete_if { |key, value| value == this_binding_name }

      ::CascadingConfiguration::Variable.remove_module_method( self, this_binding_name )
      ::CascadingConfiguration::Variable.remove_instance_method( self, this_binding_name )
      ::CascadingConfiguration::Variable.remove_instance_method( self, this_binding_name.write_accessor_name )
      
		end
		
		return self
		
	end

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

  #######################
  #  binding_required?  #
  #######################
	
	def binding_required?( binding_name )
	  
	  binding_required = false
	  
	  if binding_instance = binding_instance( binding_name )
	    binding_required = binding_instance.required?
    end
	  
	  return binding_required
	  
  end

  #######################
  #  required_bindings  #
  #######################
	
	def required_bindings
	  
	  return binding_routers.select do |this_binding_name, this_binding_router| 
	    if this_binding_router.__binding_instance__.required?
	      this_binding_router.__binding_instance__
	    else
	      next
	    end
    end.keys
	  
  end

  ####################
  #  binding_router  #
  ####################

	def binding_router( binding_name, binding_base_path = nil )
		
		binding_router_instance = nil
    
    unless binding_router_instance = shared_binding_routers[ binding_name ]
      binding_router_instance = binding_routers[ binding_name ]
		end
		
		# if we have a binding path then we are creating a new router for this binding to be used
		# in another view class
		if binding_base_path
		  
		  binding_instance = binding_router_instance.__binding_instance__
		  binding_router_instance = ::Rmagnets::Bindings::Binding::Router.new( binding_instance, 
		                                                                       binding_base_path )
	    
    end
		
		return binding_router_instance
		
  end
  
  ######################
  #  binding_instance  #
  ######################

	def binding_instance( binding_name )
		
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

	##########################################  Aliases  #############################################
	
	################
  #  attr_alias  #
  ################

  # attr_alias :name, :other_name
  # attr_alias :name => :other_name
  # attr_alias :name, { :binding => :name_in_binding }
  # attr_alias :name => { :binding => :name_in_binding }
  #
	def attr_alias( *new_binding_aliases )
  
		until new_binding_aliases.empty?
			
			new_binding_alias_to_existing_binding_name = new_binding_aliases.shift
			
			if new_binding_alias_to_existing_binding_name.is_a?( Hash )
				
				new_binding_alias_to_existing_binding_name.each do |new_binding_alias, existing_name|

          create_binding_alias( new_binding_alias, existing_name )
          
				end
				
			else
				
				new_binding_alias	= new_binding_alias_to_existing_binding_name
				existing_name    	= new_binding_aliases.shift

        create_binding_alias( new_binding_alias, existing_name )
				
			end
			
		end

		return self
		
	end

	##########################################  Order  ###############################################
	
	################
  #  attr_order  #
  ################

	def attr_order( *binding_order_array )

    return_value = self

		if binding_order_array.empty?
		
			return_value = binding_order
		
		else

	  	binding_order_array.each do |this_binding_name|
	  	  
	  	  unless has_binding?( this_binding_name )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
      		      'No binding defined for :' + this_binding_name.to_s + '.'
  	    end
	  	  
	  	  if binding_order.include?( this_binding_name )
	  	    raise ArgumentError, 'Order already includes binding ' + this_binding_name.to_s
  	    end
	  	  
				binding_order.push( this_binding_name )
				
			end

		end
		
		return return_value

	end
	
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ##############################
  #  create_bindings_for_args  #
  ##############################

	def create_bindings_for_args( args, required, text_only, & configuration_proc )
	  
	  until args.empty?
      
      next_arg = args.shift
      
      case next_arg
        
        when Hash
        
          create_bindings_for_hash( next_arg, required, text_only, & configuration_proc )
        
        when Symbol, String
        
          binding_names = [ next_arg ]
        
          view_class = nil
        
          until args.empty?
          
            next_arg = args.shift
          
            case next_arg
            
              when Hash
            
                create_bindings_for_hash( next_arg, required, text_only, & configuration_proc )
                break
            
              when Symbol, String
            
                binding_names.push( next_arg )
            
              else
            
                view_class = next_arg
                break
            
            end
          
          end
          
          binding_names.each do |this_binding_name|
            create_binding( this_binding_name, view_class, required, text_only, & configuration_proc )
          end
                
        else
        
          raise ArgumentError, 'Got View argument without binding name.'
        
      end
    
    end
    
  end

  ##############################
  #  create_bindings_for_hash  #
  ##############################

  def create_bindings_for_hash( hash_instance, required, text_only, & configuration_proc )
    
    hash_instance.each do |this_binding_name, this_view_class|
      create_binding( this_binding_name, this_view_class, required, text_only, & configuration_proc )
    end
    
  end

  ####################
  #  create_binding  #
  ####################

  def create_binding( binding_name, view_class, required, text_only, & configuration_proc )

    if has_binding?( binding_name )
		  raise ::Rmagnets::Bindings::Exception::BindingAlreadyDefinedError,
		        'Binding already defined for :' + binding_name.to_s + '; use attr_rebind to redefine.'
    end
    
		new_binding = ::Rmagnets::Bindings::Binding.new( self,
		                                                 binding_name,
		                                                 view_class, 
		                                                 required,
		                                                 text_only,
		                                                 & configuration_proc )
		
		binding_configurations[ binding_name ] = new_binding
	  
	  binding_routers[ binding_name ] = ::Rmagnets::Bindings::Binding::Router.new( new_binding )
	  
		declare_binding_setter( binding_name )
		declare_binding_getter( binding_name )

	end

	##########################
  #  create_binding_alias  #
  ##########################
	
	def create_binding_alias( binding_alias, existing_binding_or_name )

    case existing_binding_or_name
      
      when Symbol, String
      
    	  unless has_binding?( existing_binding_or_name )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
      		      'No binding defined for :' + existing_binding_or_name.to_s + '.'
        end

    		binding_aliases[ binding_alias ] = existing_binding_or_name
        
      else

        shared_binding_routers[ binding_alias ] = existing_binding_or_name
        
    end

		declare_binding_setter( binding_alias )
		declare_binding_getter( binding_alias )
    
  end
  
  ############################
  #  declare_binding_setter  #
  ############################

	def declare_binding_setter( binding_name )

    method_name = binding_name.write_accessor_name

		# instance method: return the bound instance
    ::CascadingConfiguration::Variable.define_instance_method( self, method_name ) do |object|
		  
			binding_router( binding_name ).object = object
		
		end

	end

  ############################
  #  declare_binding_getter  #
  ############################

	def declare_binding_getter( binding_name )

    accessor_write_name = binding_name.write_accessor_name
    accessor_is_set_name = binding_name.is_set_accessor_name

		# class method: return the binding instance
		::CascadingConfiguration::Variable.define_module_method( self, binding_name ) do

			return binding_router( binding_name )
		  
		end

    ##################
    #  binding_name  #
    ##################

		# instance method: return the bound instance
		::CascadingConfiguration::Variable.define_instance_method( self, binding_name ) do
		  
			return binding_router( binding_name )
		
		end
		
		###################
    #  binding_name=  #
    ###################
    
		::CascadingConfiguration::Variable.
		  define_instance_method( self, accessor_write_name ) do |object_to_bind|

      # set binding to object instance
      binding_router( binding_name ).object = object_to_bind
    
    end
    
    ###################
    #  binding_name?  #
    ###################
    
		::CascadingConfiguration::Variable.define_instance_method( self, accessor_is_set_name ) do
    
      # return whether binding has been assigned object instance
      binding_router( binding_name ).bound?
    
    end
    
	end
	
end
