
module ::Magnets::Bindings::Attributes

  @bindings_modules = { }

  ################################
  #  self.define_container_type  #
  ################################
  
  def self.define_container_type( container_type,
                                  subclass_existing_bindings = true,
                                  *parent_container_or_types, 
                                  & definition_block )

    if container_type_module = @bindings_modules[ container_type ]

      if block_given?
        container_type_module.module_eval( & definition_block )
      end

    else

      container_type_module = create_container_type( container_type,
                                                     subclass_existing_bindings,
                                                     *parent_container_or_types,
                                                     & definition_block )
      
    end
        
    return container_type_module
    
  end
  
  ################################
  #  self.create_container_type  #
  ################################
  
  def self.create_container_type( container_type, 
                                  subclass_existing_bindings = true,
                                  *parent_container_or_types,
                                  & definition_block )
    
    parent_containers = [ ]
    
    parent_container_or_types.each do |this_parent_container_or_type|

      case this_parent_container_or_type
    
        when ::Module
    
          parent_containers.push( this_parent_container_or_type )
  
        when ::Symbol, ::String

          if this_parent_container = @bindings_modules[ this_parent_container_or_type ]
            parent_containers.push( this_parent_container )
          else
            raise ::ArgumentError, 
                    'No container defined by name :' + this_parent_container_or_type.to_s
          end

      end

    end

    container_type_module = ::Magnets::Bindings::
                              AttributeContainer.new( ::Magnets::Bindings::AttributeContainer,
                                                      container_type,
                                                      subclass_existing_bindings,
                                                      *parent_containers,
                                                      & definition_block )
    
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
