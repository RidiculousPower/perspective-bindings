
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

        unless parent_container = @bindings_modules[ parent_container_or_type ]
          raise ::ArgumentError, 'No container defined by name :' + parent_container_or_type.to_s
        end

    end
    
    container_type_module = ::Magnets::Bindings::AttributesContainer.new( parent_container,
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
  
end