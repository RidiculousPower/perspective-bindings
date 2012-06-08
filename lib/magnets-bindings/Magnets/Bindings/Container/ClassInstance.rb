
module ::Magnets::Bindings::Container::ClassInstance

  include ::Magnets::Bindings::Configuration

  ::Magnets::Bindings::Attributes.define_container_type( :bindings ) do

    define_binding_type( :binding, nil,        ::Magnets::Bindings::Attributes::Binding )
    define_binding_type( :class, nil,          ::Magnets::Bindings::Attributes::Class )
    define_binding_type( :complex, nil,        ::Magnets::Bindings::Attributes::Complex )
    define_binding_type( :file, nil,           ::Magnets::Bindings::Attributes::File )
    define_binding_type( :float, nil,          ::Magnets::Bindings::Attributes::Float )
    define_binding_type( :integer, nil,        ::Magnets::Bindings::Attributes::Integer )
    define_binding_type( :module, nil,         ::Magnets::Bindings::Attributes::Module )
    define_binding_type( :number, nil,         ::Magnets::Bindings::Attributes::Number )
    define_binding_type( :rational, nil,       ::Magnets::Bindings::Attributes::Rational )
    define_binding_type( :regexp, nil,         ::Magnets::Bindings::Attributes::Regexp )
    define_binding_type( :text, nil,           ::Magnets::Bindings::Attributes::Text )
    define_binding_type( :text_or_number, nil, ::Magnets::Bindings::Attributes::Text,
                                               ::Magnets::Bindings::Attributes::Number )
    define_binding_type( :true_false, nil,     ::Magnets::Bindings::Attributes::TrueFalse )
    define_binding_type( :uri, nil,            ::Magnets::Bindings::Attributes::URI )
  
  end

  include ::Magnets::Bindings::AttributeContainer::Bindings

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
    
    unless has_binding?( existing_binding_name )
  		raise ::Magnets::Bindings::Exception::NoBindingError.new( self, existing_binding_name )
    end
	  
    __binding_aliases__[ binding_alias ] = existing_binding_name
    
		self::ClassBindingMethods.define_binding_alias( binding_alias, existing_binding_name )
    self::InstanceBindingMethods.define_binding_alias( binding_alias, existing_binding_name )
    
  end

	#####################################
  #  __create_local_alias_to_binding__  #
  #####################################
  
  def __create_local_alias_to_binding__( binding_alias, binding_instance )

    __local_aliases_to_bindings__[ binding_alias ] = binding_instance

		self::ClassBindingMethods.define_local_alias_to_binding( binding_alias, binding_instance )
    self::InstanceBindingMethods.define_local_alias_to_binding( binding_alias, binding_instance )

  end

end
