
module ::Magnets::Bindings::Container::ClassInstance

  include ::Magnets::Bindings::Configuration

  ::Magnets::Bindings::Attributes.define_container_type( :bindings ) do

    define_binding_type( :binding,        ::Magnets::Bindings::Attributes::Binding )
    define_binding_type( :class,          ::Magnets::Bindings::Attributes::Class )
    define_binding_type( :complex,        ::Magnets::Bindings::Attributes::Complex )
    define_binding_type( :file,           ::Magnets::Bindings::Attributes::File )
    define_binding_type( :float,          ::Magnets::Bindings::Attributes::Float )
    define_binding_type( :integer,        ::Magnets::Bindings::Attributes::Integer )
    define_binding_type( :module,         ::Magnets::Bindings::Attributes::Module )
    define_binding_type( :number,         ::Magnets::Bindings::Attributes::Number )
    define_binding_type( :rational,       ::Magnets::Bindings::Attributes::Rational )
    define_binding_type( :regexp,         ::Magnets::Bindings::Attributes::Regexp )
    define_binding_type( :text,           ::Magnets::Bindings::Attributes::Text )
    define_binding_type( :text_or_number, ::Magnets::Bindings::Attributes::Text,
                                          ::Magnets::Bindings::Attributes::Number )
    define_binding_type( :true_false,     ::Magnets::Bindings::Attributes::TrueFalse )
    define_binding_type( :uri,            ::Magnets::Bindings::Attributes::URI )
  
  end

  include ::Magnets::Bindings::AttributesContainer::Bindings

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

        __create_shared_binding_alias__( binding_alias, existing_reference )
        
    end
    
  end
  
  ###########################
  #  __create_name_alias__  #
  ###########################
	
  def __create_name_alias__( binding_alias, existing_binding_name )
    
    unless has_binding?( existing_binding_name )
  		raise ::Magnets::Bindings::Exception::NoBindingError,
  		      'No binding defined for :' + existing_binding_name.to_s + '.'
    end
	  
    __binding_aliases__[ binding_alias ] = existing_binding_name
    
		self::ClassBindingMethods.define_binding_alias( binding_alias, existing_binding_name )
    self::InstanceBindingMethods.define_binding_alias( binding_alias, existing_binding_name )
    
  end

	#####################################
  #  __create_shared_binding_alias__  #
  #####################################
  
  def __create_shared_binding_alias__( binding_alias, shared_binding_instance )

    __shared_bindings__[ binding_alias ] = shared_binding_instance

		self::ClassBindingMethods.define_shared_binding( binding_alias, shared_binding_instance )
    self::InstanceBindingMethods.define_shared_binding( binding_alias, shared_binding_instance )

  end

end
