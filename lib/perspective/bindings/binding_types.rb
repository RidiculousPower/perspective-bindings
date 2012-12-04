
###
# Container to hold BindingTypeContainers.
#
module ::Perspective::Bindings::BindingTypes
  
  @type_containers = { }

  ################################
  #  self.define_container_type  #
  ################################
  
  ###
  # Open container type for definition, creating if necessary.
  #
  def self.define_container_type( container_type,
                                  subclass_existing_bindings = true,
                                  *parent_container_or_types, 
                                  & definition_block )
    
    type_container_constant_name = container_type.to_s.to_camel_case
    
    if const_defined?( type_container_constant_name )
      const_remove( type_container_constant_name )
    end
    
    # We permit define to be called multiple times, so we check to see if 
    # we have already created our BindingTypeContainer instance for container_type.
    if type_container = type_container( container_type, false )
      
      if block_given?
        type_container.module_eval( & definition_block )
      end

    else

      type_container = create_container_type( container_type,
                                              subclass_existing_bindings,
                                              *parent_container_or_types,
                                              & definition_block )
      
    end
        
    const_set( type_container_constant_name, type_container )
    
    return type_container
    
  end
  
  ################################
  #  self.create_container_type  #
  ################################
  
  ###
  # Create type container with arbitrary name ("container type") to hold binding types 
  #   belonging to container type.
  #
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

          if this_parent_container = @type_containers[ this_parent_container_or_type ]
            parent_containers.push( this_parent_container )
          else
            raise ::ArgumentError, 'No container defined by name :' + this_parent_container_or_type.to_s
          end

      end

    end

    type_container = ::Perspective::Bindings::BindingTypeContainer.new( container_type, 
                                                                        subclass_existing_bindings, 
                                                                        *parent_containers, 
                                                                        & definition_block )
    
    ::Perspective::Bindings::BindingDefinitions.const_set( container_type.to_s.to_camel_case, type_container )
    
    @type_containers[ container_type ] = type_container
    
    return type_container
    
  end
  
  #########################
  #  self.type_container  #
  #########################
  
  ###
  # Retrieve existing type container.
  #
  def self.type_container( container_type, require_exists = true )

    bindings_module = nil
    
    unless bindings_module = @type_containers[ container_type ]
      if require_exists
        raise ::ArgumentError, 'No bindings module named :' + container_type.to_s + ' exists.'
      end
    end
    
    return bindings_module
    
  end
  
end
