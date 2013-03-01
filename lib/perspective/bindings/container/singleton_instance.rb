# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Container::SingletonInstance

  include ::Perspective::Bindings::Configuration
  include ::Perspective::Bindings::Configuration::SingletonAndClassBindingInstance
  include ::Perspective::Bindings::Container::SingletonAndObjectInstance
  include ::Perspective::BindingTypes::ContainerBindings
  include ::Perspective::Bindings::Container::Configuration

  ##############
  #  «name  #
  ##############
  
  def «name
    
    return name
    
  end

  ##############
  #  «root  #
  ##############
  
  def «root
    
    # class instance is always the root
    # otherwise we have a class binding
    
    return self
    
  end

  ##########
  #  root  #
  ##########

  alias_method  :root, :«root

  ##################
  #  is_root?  #
  ##################
  
  def is_root?
    
    return true
    
  end
  
  #####################
  #  «root_string  #
  #####################

  def «root_string
    
    # [root:<instance>]

    return @«root_string ||= '<root:' << to_s << '>'
    
  end

  ###############
  #  «route  #
  ###############

  def «route
    
    # class instance is always the root
    # otherwise we have a class binding
    
    return nil
    
  end

  ###########
  #  route  #
  ###########

  alias_method( :route, :«route )

  #########################
  #  «route_with_name  #
  #########################

  def «route_with_name
    
    return nil
    
  end

  #####################
  #  route_with_name  #
  #####################

  alias_method( :route_with_name, :«route_with_name )

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
            «create_binding_alias( this_alias_name, this_existing_descriptor )
  				end
  	    else
          «create_binding_alias( this_descriptor, alias_args.shift )
		  end
		  			
		end

		return self
		
	end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	##############################
  #  «create_binding_alias  #
  ##############################
	
	def «create_binding_alias( binding_alias, existing_reference )

    case existing_reference
      
      when ::Symbol, ::String
              
        «create_name_alias( binding_alias, existing_reference )
                
      else

        «create_local_alias_to_binding( binding_alias, existing_reference )
        
    end
    
  end
  
  ###########################
  #  «create_name_alias  #
  ###########################
	
  def «create_name_alias( binding_alias, existing_binding_name )
    
    unless has_binding?( existing_binding_name )
  		begin
  		  raise ::Perspective::Bindings::Exception::NoBindingError.new( self, existing_binding_name )
  		rescue ::Exception => exception
  		  exception.reraise( 3 )
  		end
    end
	  
    «binding_aliases[ binding_alias ] = existing_binding_name

		self::Controller::ClassBindingMethods.define_binding_alias( binding_alias, existing_binding_name )
    self::Controller::InstanceBindingMethods.define_binding_alias( binding_alias, existing_binding_name )
    
  end

	#######################################
  #  «create_local_alias_to_binding  #
  #######################################
  
  def «create_local_alias_to_binding( binding_alias, binding_instance )

    «local_aliases_to_bindings[ binding_alias ] = binding_instance

		self::Controller::ClassBindingMethods.define_local_alias_to_binding( binding_alias, binding_instance )
    self::Controller::InstanceBindingMethods.define_local_alias_to_binding( binding_alias, binding_instance )

  end

end
