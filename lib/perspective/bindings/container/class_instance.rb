
module ::Perspective::Bindings::Container::ClassInstance

  include ::Perspective::Bindings::Configuration

  include ::Perspective::Bindings::Container::ClassAndObjectInstance

  include ::Perspective::Bindings::BindingTypes::PropertyBindings
  
  #########
  #  new  #
  #########
  
  ###
  # Ensure that instance bindings initialize prior to calling #initialize.
  #
  # We add this here instead of in #initialize - where it usually would go - so that
  # we can avoid requiring #initialize to call super.
  #
  # As each binding is created, any sub-bindings it has are created. We need the entire tree 
  # to be created first then initialized top-down, otherwise we end up with most-nested bindings 
  # configuring before its parents have initialized. This also tends to cause odd initialization 
  # loops, resulting in configuration happening against a nil container, which is not only wrong 
  # but also quite confusing to debug.
  #
  def new( *args, & block )

    __initialize_bindings__

    initialize( *args, & block )

    __configure_containers__

    return instance
    
  end

  #########################
  #  new_nested_instance  #
  #########################
  
  ###
  # When we have a nested object instance we need to ensure that parent configurations are
  #   registered before initialization occurs.
  #
  def new_nested_instance( parent_binding_instance, *args, & block )
    
    return allocate.instance_eval do

      @__parent_binding__ = parent_binding_instance
      @__bound_container__ = parent_binding_instance
      ::CascadingConfiguration.register_parent( self, parent_binding_instance )

      __initialize_bindings__

      initialize( *args, & block )

      __configure_containers__

    end
    
  end

  ##############
  #  root      #
  #  __root__  #
  ##############
  
  def __root__
    
    # class instance is always the root
    # otherwise we have a class binding
    
    return self
    
  end

  alias_method  :root, :__root__

  ###############
  #  route      #
  #  __route__  #
  ###############

  def __route__
    
    # class instance is always the root
    # otherwise we have a class binding
    
    return nil
    
  end

  alias_method( :route, :__route__ )

  #########################
  #  route_with_name      #
  #  __route_with_name__  #
  #########################

  def __route_with_name__
    
    return @__route_with_name__ ||= [ __name__ ]
    
  end

  alias_method( :route_with_name, :__route_with_name__ )

  ###############
  #  configure  #
  #  render     #
  ###############

  # declare a configuration block to be run before final rendering
  def configure( & configuration_block )
    
    __configuration_procs__.push( configuration_block )
    
    return self
    
  end
  alias_method :render, :configure
	
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
			
			if new_binding_alias_to_existing_binding_name.is_a?( ::Hash )
				
				new_binding_alias_to_existing_binding_name.each do |new_binding_alias, existing_reference|

          __create_binding_alias__( new_binding_alias, existing_reference )
          
				end
				
			else
				
				new_binding_alias	 = new_binding_alias_to_existing_binding_name
				existing_reference = new_binding_aliases.shift

        __create_binding_alias__( new_binding_alias, existing_reference )
				
			end
			
		end

		return self
		
	end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	##############################
  #  __create_binding_alias__  #
  ##############################
	
	def __create_binding_alias__( binding_alias, existing_reference )

    case existing_reference
      
      when ::Symbol, ::String
              
        __create_name_alias__( binding_alias, existing_reference )
                
      else

        __create_local_alias_to_binding__( binding_alias, existing_reference )
        
    end
    
  end
  
  ###########################
  #  __create_name_alias__  #
  ###########################
	
  def __create_name_alias__( binding_alias, existing_binding_name )
    
    unless __has_binding__?( existing_binding_name )
  		begin
  		  raise ::Perspective::Bindings::Exception::NoBindingError.new( self, existing_binding_name )
  		rescue ::Exception => exception
  		  exception.reraise( 3 )
  		end
    end
	  
    __binding_aliases__[ binding_alias ] = existing_binding_name
    
		self::Controller::ClassBindingMethods.define_binding_alias( binding_alias, existing_binding_name )
    self::Controller::InstanceBindingMethods.define_binding_alias( binding_alias, existing_binding_name )
    
  end

	#####################################
  #  __create_local_alias_to_binding__  #
  #####################################
  
  def __create_local_alias_to_binding__( binding_alias, binding_instance )

    __local_aliases_to_bindings__[ binding_alias ] = binding_instance

		self::Controller::ClassBindingMethods.define_local_alias_to_binding( binding_alias, binding_instance )
    self::Controller::InstanceBindingMethods.define_local_alias_to_binding( binding_alias, binding_instance )

  end

end
