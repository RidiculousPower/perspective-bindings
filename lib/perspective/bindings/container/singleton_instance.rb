
module ::Perspective::Bindings::Container::SingletonInstance

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::Configuration::ClassAndClassBindingInstance
  include ::Perspective::Bindings::Container::ClassAndObjectInstance
  include ::Perspective::Bindings::BindingTypes::ContainerBindings

  ##############
  #  __root__  #
  ##############
  
  def __root__
    
    # class instance is always the root
    # otherwise we have a class binding
    
    return self
    
  end

  ##########
  #  root  #
  ##########

  alias_method  :root, :__root__

  #####################
  #  __root_string__  #
  #####################

  def __root_string__
    
    # [root:<instance>]

    return @__root_string__ ||= '<root:' << to_s << '>'
    
  end

  ###############
  #  __route__  #
  ###############

  def __route__
    
    # class instance is always the root
    # otherwise we have a class binding
    
    return nil
    
  end

  ###########
  #  route  #
  ###########

  alias_method( :route, :__route__ )

  #########################
  #  __route_with_name__  #
  #########################

  def __route_with_name__
    
    return nil
    
  end

  #####################
  #  route_with_name  #
  #####################

  alias_method( :route_with_name, :__route_with_name__ )

	################
  #  attr_alias  #
  ################

  # attr_alias :name, :other_name
  # attr_alias :name => :other_name
  # attr_alias :name, { :binding => :name_in_binding }
  # attr_alias :name => { :binding => :name_in_binding }
  #
	def attr_alias( *alias_args )
  
		until alias_args.empty?
			
			case this_descriptor = alias_args.shift
  		  when ::Hash
  				this_descriptor.each do |this_alias_name, this_existing_descriptor|
            __create_binding_alias__( this_alias_name, this_existing_descriptor )
  				end
  	    else
          __create_binding_alias__( this_descriptor, alias_args.shift )
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

	#######################################
  #  __create_local_alias_to_binding__  #
  #######################################
  
  def __create_local_alias_to_binding__( binding_alias, binding_instance )

    __local_aliases_to_bindings__[ binding_alias ] = binding_instance

		self::Controller::ClassBindingMethods.define_local_alias_to_binding( binding_alias, binding_instance )
    self::Controller::InstanceBindingMethods.define_local_alias_to_binding( binding_alias, binding_instance )

  end

end
