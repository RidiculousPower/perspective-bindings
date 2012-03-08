
module ::Rmagnets::Bindings::ClassInstance

	#########################################  Bindings  #############################################

  ###############
  #  attr_view  #
  ###############

  # attr_view :name, ... 
  # attr_view :name => ViewClass, ...
  # attr_view :name, ... { ... configuration proc ... }
  # attr_view :name => ViewClass, ... { ... configuration proc ... }
  # attr_view *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_view( *args, & configuration_proc )

    create_bindings_for_args( args, false, false, & configuration_proc )
		
		return self

	end

  ###############
  #  attr_text  #
  ###############

  # attr_text *binding_names, ... { ... configuration proc ... }
  # 
	def attr_text( *binding_names, & configuration_proc )

    binding_names.each do |this_binding_name|
      
      unless this_binding_name.is_a?( Symbol ) or
             this_binding_name.is_a?( String )
        
     		raise ::Rmagnets::Bindings::Exception::TextBindingExpectsString,
     		        'Binding ' + binding_name.to_s + ' is defined as a text-only binding, ' +
     		        'which expects a string, but ' + this_binding_name.to_s + ' was not a string.'
        
      end
    
      create_binding( this_binding_name, nil, false, true, & configuration_proc )
		end
		
		return self

	end

  ########################
  #  attr_required_view  #
  ########################

  # attr_required_view :name, ... 
  # attr_required_view :name => ViewClass, ...
  # attr_required_view :name, ... { ... configuration proc ... }
  # attr_required_view :name => ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_view( *args, & configuration_proc )
		
    create_bindings_for_args( args, true, false, & configuration_proc )
		
		return self
		
	end
	alias_method :attr_required_view, :attr_required_view

  ########################
  #  attr_required_text  #
  ########################

  # attr_required_text *binding_names, ... { ... configuration proc ... }
  # 
	def attr_required_text( *binding_names, & configuration_proc )
		
    binding_names.each do |this_binding_name|
      create_binding( this_binding_name, nil, false, true, & configuration_proc )
		end
		
		return self
		
	end

	#################
  #  attr_rename  #
  #################

  def attr_rename( existing_name, new_name )
    
    unless has_binding?( existing_name )
  		raise ::Rmagnets::Bindings::Exception::NoBindingError,
  		      'No binding defined for :' + existing_name.to_s + '.'
    end
	  
    if existing_alias_for_existing_name = binding_aliases.delete( existing_name )
      
      remove_binding_methods( existing_name )
      binding_aliases.each do |key, value|
        if value == existing_name
          binding_aliases[ key ] = new_name
        end
      end
      create_binding_alias( new_name, existing_alias_for_existing_name )
      
    elsif shared_binding_router = shared_binding_routers.delete( existing_name )
      
      remove_binding_methods( existing_name )
      shared_binding_routers[ new_name ] = new_name
      create_binding_alias( new_name, shared_binding_router )
      
    else
    
      binding_instance = binding_configurations.delete( existing_name )
      binding_instance.name = new_name
      binding_routers.delete( existing_name )
      remove_binding_methods( existing_name )
      create_binding_from_configuration( new_name, binding_instance )
      
    end
            
  end

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

    		binding_configurations.delete( this_binding_name )

      end
      
      binding_routers.delete( this_binding_name )

  		# delete any aliases for this one
      binding_aliases.delete_if { |key, value| value == this_binding_name }

      remove_binding_methods( this_binding_name )
      
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
	  
	  if binding_instance = binding_configuration( binding_name )
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

	  	  if this_binding_name.is_a?( Array )
	  	    this_binding_name = this_binding_name[ 0 ]
  	    end
	  	  
	  	  unless has_binding?( this_binding_name )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
      		      'No binding defined for :' + this_binding_name.to_s + '.'
  	    end
	  	  
			end

			binding_order.replace( binding_order_array )
			
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
		        'Binding already defined for :' + binding_name.to_s + '.'
    end
    
		new_binding = ::Rmagnets::Bindings::Binding.new( self,
		                                                 binding_name,
		                                                 view_class, 
		                                                 required,
		                                                 text_only,
		                                                 & configuration_proc )
		
	  create_binding_from_configuration( binding_name, new_binding )

	end

  #######################################
  #  create_binding_from_configuration  #
  #######################################

  def create_binding_from_configuration( binding_name, binding_configuration )

		binding_configurations[ binding_name ] = binding_configuration
	  
	  binding_routers[ binding_name ] = ::Rmagnets::Bindings::Binding::Router.new( binding_configuration )
	  
    declare_class_binding_getter( binding_name )
		declare_binding_setter( binding_name, binding_configuration )
		declare_binding_getter( binding_name, binding_configuration )

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
        
        binding_name = existing_binding_or_name
    		binding_aliases[ binding_alias ] = binding_name

        declare_aliased_class_binding_getter( binding_alias, binding_name )
    		declare_aliased_binding_setter( binding_alias, binding_name )
    		declare_aliased_binding_getter( binding_alias, binding_name )
        
      else

        shared_binding_router_instance = existing_binding_or_name
        shared_binding_routers[ binding_alias ] = shared_binding_router_instance

        declare_class_shared_binding_getter( binding_alias )
    		declare_shared_binding_setter( binding_alias, shared_binding_router_instance )
    		declare_shared_binding_getter( binding_alias, shared_binding_router_instance )
        
    end
    
  end
  
  ##################################
  #  declare_class_binding_getter  #
  ##################################

  def declare_class_binding_getter( binding_name )

  	#-------------------------------------  Class Methods  ----------------------------------------#

    #=====================#
    #  self.binding_name  #
    #=====================#

		# class method: return the binding instance
		::CascadingConfiguration::Variable.define_module_method( self, binding_name ) do

			return binding_router( binding_name )
		  
		end
		    
  end

  ##########################################
  #  declare_aliased_class_binding_getter  #
  ##########################################

  def declare_aliased_class_binding_getter( binding_alias, binding_name )
    
  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #================#
    #  binding_name  #
    #================#

		# instance method: return the bound instance
		::CascadingConfiguration::Variable.define_module_method( self, binding_alias ) do
		  
      return __send__( binding_name )
		
		end
    
  end

  #########################################
  #  declare_class_shared_binding_getter  #
  #########################################

  def declare_class_shared_binding_getter( binding_name )
    
    declare_class_binding_getter( binding_name )
    
  end

  ############################
  #  declare_binding_setter  #
  ############################

	def declare_binding_setter( binding_name, binding_instance )

    variable_name = binding_name.variable_name
    write_accessor = binding_name.write_accessor_name
		
		#-----------------------------------  Instance Methods  ---------------------------------------#
  	
		#=================#
    #  binding_name=  #
    #=================#
    
		::CascadingConfiguration::Variable.define_instance_method( self, write_accessor ) do |object|
      
      if binding_instance.text_only?
        unless object.is_a?( String )
      		raise ::Rmagnets::Bindings::Exception::TextBindingExpectsString,
      		      'Binding ' + binding_name.to_s + ' is defined as a text-only binding, ' +
      		      'which expects a string.'
        end
      end
      
      return instance_variable_set( variable_name, object )

    end

	end

	####################################
  #  declare_aliased_binding_setter  #
  ####################################

	def declare_aliased_binding_setter( binding_alias, binding_name )

    write_accessor = binding_alias.write_accessor_name
    aliased_write_accessor = binding_name.write_accessor_name

		#-----------------------------------  Instance Methods  ---------------------------------------#
  	
		#=================#
    #  binding_name=  #
    #=================#
    
		::CascadingConfiguration::Variable.define_instance_method( self, write_accessor ) do |object|
      
      __send__( aliased_write_accessor, object )
      
    end

	end

	###################################
  #  declare_shared_binding_setter  #
  ###################################

	def declare_shared_binding_setter( binding_name, shared_binding_router_instance )

    write_accessor = binding_name.write_accessor_name
		
		binding_route = shared_binding_router_instance.__binding_route__

		#-----------------------------------  Instance Methods  ---------------------------------------#
  	
		#=================#
    #  binding_name=  #
    #=================#
    
		::CascadingConfiguration::Variable.define_instance_method( self, write_accessor ) do |object|
      
      instance_binding = self
            
      binding_route.each do |this_binding_route_part|
        
        unless instance_binding.respond_to?( this_binding_route_part )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
        		      'Shared binding :' + binding_name.to_s + ' was inaccessible in ' + 
          	      instance_binding.to_s + '. No binding :' + binding_name.to_s + ' defined ' +
        		      'in ' + ( [ instance_binding.to_s ] + 
        		      binding_route.slice( 0, index ) ).join( '.' ) + '.'
        end
        
        instance_binding = instance_binding.__send__( this_binding_route_part )
      
      end

      unless instance_binding.respond_to?( binding_name )
    		raise ::Rmagnets::Bindings::Exception::NoBindingError,
        	      'Shared binding :' + binding_name.to_s + ' was inaccessible in ' + 
        	      instance_binding.to_s + '. No binding :' + binding_name.to_s + ' defined ' +
      		      'in ' + ( [ instance_binding.to_s ] + binding_route ).join( '.' ) + '.'
      end
      
      instance_binding.__send__( write_accessor, object )
      
    end

	end

  ############################
  #  declare_binding_getter  #
  ############################

	def declare_binding_getter( binding_name, binding_instance )

    variable_name = binding_name.variable_name

  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #================#
    #  binding_name  #
    #================#

		# instance method: return the bound instance
		::CascadingConfiguration::Variable.define_instance_method( self, binding_name ) do
		  
      return instance_variable_get( variable_name )
		
		end
        
	end

	####################################
  #  declare_aliased_binding_getter  #
  ####################################

	def declare_aliased_binding_getter( binding_alias, binding_name )

  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #================#
    #  binding_name  #
    #================#

		# instance method: return the bound instance
		::CascadingConfiguration::Variable.define_instance_method( self, binding_alias ) do
      
      __send__( binding_name )
		
		end

	end
	
	###################################
  #  declare_shared_binding_getter  #
  ###################################

	def declare_shared_binding_getter( binding_name, shared_binding_router_instance )

		binding_route = shared_binding_router_instance.__binding_route__

  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #================#
    #  binding_name  #
    #================#

		# instance method: return the bound instance
		::CascadingConfiguration::Variable.define_instance_method( self, binding_name ) do
		  
      instance_binding = self
      
      binding_route.each_with_index do |this_binding_route_part, index|

        unless instance_binding.respond_to?( this_binding_route_part )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
        		      'Shared binding :' + binding_name.to_s + ' was inaccessible in ' + 
          	      instance_binding.to_s + '. No binding :' + binding_name.to_s + ' defined ' +
        		      'in ' + ( [ instance_binding.to_s ] + 
        		      binding_route.slice( 0, index ) ).join( '.' ) + '.'
        end

        instance_binding = instance_binding.__send__( this_binding_route_part )

      end

      unless instance_binding.respond_to?( binding_name )
    		raise ::Rmagnets::Bindings::Exception::NoBindingError,
        	      'Shared binding :' + binding_name.to_s + ' was inaccessible in ' + 
        	      instance_binding.to_s + '. No binding :' + binding_name.to_s + ' defined ' +
      		      'in ' + ( [ instance_binding.to_s ] + binding_route ).join( '.' ) + '.'
      end
      
      instance_binding.__send__( binding_name )
		
		end

	end
	
	############################
	#  remove_binding_methods  #
	############################
	
	def remove_binding_methods( binding_name )

    write_accessor = binding_name.write_accessor_name
    
    unless ::CascadingConfiguration::Variable.undef_module_method( self, binding_name )
      eigenclass = class << self ; self ; end
      eigenclass.instance_eval do
        undef_method( binding_name )
      end
    end
    
    unless ::CascadingConfiguration::Variable.undef_instance_method( self, binding_name )
      undef_method( binding_name )
    end

    unless ::CascadingConfiguration::Variable.undef_instance_method( self, write_accessor )
      undef_method( write_accessor )
    end

  end

end
