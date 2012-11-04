
module ::Perspective::Bindings::Container::ClassInstance

  include ::Perspective::Bindings::Configuration

  include ::Perspective::Bindings::Container::ClassAndObjectInstance

  ::Perspective::Bindings::Attributes.define_container_type( :bindings ) do

    define_binding_type( :binding,        ::Perspective::Bindings::Attributes::Binding )
    define_binding_type( :class,          ::Perspective::Bindings::Attributes::Class )
    define_binding_type( :complex,        ::Perspective::Bindings::Attributes::Complex )
    define_binding_type( :file,           ::Perspective::Bindings::Attributes::File )
    define_binding_type( :float,          ::Perspective::Bindings::Attributes::Float )
    define_binding_type( :integer,        ::Perspective::Bindings::Attributes::Integer )
    define_binding_type( :module,         ::Perspective::Bindings::Attributes::Module )
    define_binding_type( :number,         ::Perspective::Bindings::Attributes::Number )
    define_binding_type( :rational,       ::Perspective::Bindings::Attributes::Rational )
    define_binding_type( :regexp,         ::Perspective::Bindings::Attributes::Regexp )
    define_binding_type( :text,           ::Perspective::Bindings::Attributes::Text )
    define_binding_type( :text_or_number, ::Perspective::Bindings::Attributes::Text,
                                          ::Perspective::Bindings::Attributes::Number )
    define_binding_type( :true_false,     ::Perspective::Bindings::Attributes::TrueFalse )
    define_binding_type( :uri,            ::Perspective::Bindings::Attributes::URI )
  
  end

  include ::Perspective::Bindings::AttributeContainer::Bindings
  
  #########
  #  new  #
  #########
  
  def new( *args )
    
    # We add this here instead of in #initialize - where it usually would go - so that
    # we can avoid requiring #initialize to call super.
    #
    # This is clearly an odd thing to do, but perhaps it can be defended on the basis
    # that the class instance is already acting as a controller for instances, not
    # only in terms of creating them (as always) but also in terms of bindings.
    
    instance = super
    
    # Call to #each causes __bindings__ to populate.
    #
    # As each binding is created, any sub-bindings it has are created.
    #
    # We need the entire tree to be created first then initialized top-down, otherwise
    # we end up with most-nested bindings configuring first.
    #
    # We also need to initialize each binding's container before configuring any bindings,
    # otherwise odd initialization loops can happen, resulting in configuration happening
    # against a nil container, which is not only wrong but confusing to debug.
    
    initialize_bindings( instance )
    
    return instance
    
  end

  #########################
  #  initialize_bindings  #
  #########################
  
  def initialize_bindings( instance )

    instance.__bindings__.each do |this_binding_name, this_binding_instance|
      this_binding_instance.__initialize_container__
	  end
  	  
    instance.__bindings__.each do |this_binding_name, this_binding_instance|
      this_binding_instance.__configure_container__
    end
    
  end
  
  ######################
  #  non_nested_class  #
  ######################
  
  def non_nested_class
    
    return self
    
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
  		raise ::Perspective::Bindings::Exception::NoBindingError.new( self, existing_binding_name )
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
