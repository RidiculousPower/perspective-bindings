
module ::Magnets::Bindings::Attributes

  @bindings_modules = { }

  ################################
  #  self.define_container_type  #
  ################################
  
  def self.define_container_type( container_type, 
                                  parent_container_or_type = nil, 
                                  class_binding_class = nil, 
                                  instance_binding_class = nil, 
                                  & definition_block )

    if container_type_module = @bindings_modules[ container_type ]

      if block_given?
        container_type_module.module_eval( & definition_block )
      end

    else

      container_type_module = create_container_type( container_type,
                                                     parent_container_or_type,
                                                     class_binding_class,
                                                     instance_binding_class,
                                                     & definition_block )
      
    end
        
    return container_type_module
    
  end
  
  ################################
  #  self.create_container_type  #
  ################################
  
  def self.create_container_type( container_type, 
                                  parent_container_or_type = nil, 
                                  class_binding_class = nil, 
                                  instance_binding_class = nil, 
                                  & definition_block )
    
    parent_container = nil

    case parent_container_or_type
    
      when ::Module
    
        parent_container = parent_container_or_type
  
      when ::Symbol, ::String

        unless parent_container = @bindings_modules[ parent_container_type ]
          raise ::ArgumentError, 'No container defined by name :' + parent_container_type.to_s
        end

    end
    
    container_type_module = ::Magnets::Bindings::AttributesContainer.new( parent_container,
                                                                          class_binding_class,
                                                                          instance_binding_class,
                                                                          & definition_block )
    
    ::Magnets::Bindings::AttributesContainer.const_set( container_type.to_s.to_camel_case, 
                                                        container_type_module )
    
    @bindings_modules[ container_type ] = container_type_module
    
    return container_type_module
    
  end
  
  ##########################
  #  self.bindings_module  #
  ##########################
  
  def self.bindings_module( container_type )

    bindings_module = nil
    
    unless bindings_module = @bindings_modules[ container_type ]
      raise ::ArgumentError, 'No bindings module named :' + container_type.to_s + ' exists.'
    end
    
    return bindings_module
    
  end
      
  ####################################  Base Attribute Types  ######################################
	
	attributes = self
  
  define_container_type( :bindings ) do

    define_binding_type( :binding,        attributes::Binding )
    define_binding_type( :class,          attributes::Class )
    define_binding_type( :complex,        attributes::Complex )
    define_binding_type( :file,           attributes::File )
    define_binding_type( :float,          attributes::Float )
    define_binding_type( :integer,        attributes::Integer )
    define_binding_type( :module,         attributes::Module )
    define_binding_type( :number,         attributes::Number )
    define_binding_type( :rational,       attributes::Rational )
    define_binding_type( :regexp,         attributes::Regexp )
    define_binding_type( :text,           attributes::Text )
    define_binding_type( :text_or_number, attributes::Text,
                                          attributes::Number )
    define_binding_type( :true_false,     attributes::TrueFalse )
    define_binding_type( :uri,            attributes::URI )
  
  end
  
end
