# -*- encoding : utf-8 -*-

###
# Container to hold BindingTypeContainers.
#
module ::Perspective::BindingTypes
  
  @type_containers = { }

  ################################
  #  self.define_container_type  #
  ################################
  
  ###
  # Open container type for definition, creating if necessary.
  #
  def self.define_container_type( container_type, 
                                  parent_container_or_type = nil, 
                                  subclass_all_parent_bindings = false, 
                                  & definition_block )
    
    # We permit define to be called multiple times, so we check to see if 
    # we have already created our BindingTypeContainer instance for container_type.
    if type_container = type_container( container_type, false )
      type_container.module_eval( & definition_block ) if block_given?
    else
      type_container = create_container_type( container_type, 
                                              parent_container_or_type, 
                                              subclass_all_parent_bindings,
                                              & definition_block )
    end
    
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
                                  parent_container_or_type = nil, 
                                  subclass_all_parent_bindings = false, 
                                  & definition_block )
    
    case parent_container_or_type
  
      when ::Module
  
        # nothing to do

      when ::Symbol, ::String
        
        parent_container_type_name = parent_container_or_type
        unless parent_container_or_type = @type_containers[ parent_container_type_name ]
          raise ::ArgumentError, 'No container defined by name :' + parent_container_type_name.to_s
        end

    end

    type_container = ::Perspective::Bindings::BindingTypeContainer.new( container_type, 
                                                                        parent_container_or_type,
                                                                        subclass_all_parent_bindings, 
                                                                        & definition_block )
    
    
    type_container_constant_name = container_type.to_s.to_camel_case
    remove_const( type_container_constant_name ) if const_defined?( type_container_constant_name, false )
    const_set( type_container_constant_name, type_container )
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
