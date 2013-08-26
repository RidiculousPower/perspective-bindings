# -*- encoding : utf-8 -*-

###
# Type controller for groups of binding types.
#
class ::Perspective::Bindings::BindingTypeContainer::TypesController

  ##############
  #  self.new  #
  ##############
  
  def self.new( type_container, parent_types_controller = nil, & module_block )
    
    superclass = parent_types_controller || self

    return ::Class.new( superclass ) { initialize( type_container,parent_types_controller, & module_block ) }
    
  end

  #####################
  #  self.initialize  #
  #####################

  def self.initialize( type_container, parent_types_controller = nil, & module_block )

    @type_container = type_container
    
    binding_base = ::Perspective::Bindings::BindingTypeContainer::BindingBase
    @class_binding_base = binding_base::ClassBinding.new( self )
    @class_binding_class_base = binding_base::ClassBindingClass.new( self )
    @class_binding_class_and_binding_base = binding_base::ClassBindingClassAndBinding.new( self )
    @instance_binding_base = binding_base::InstanceBinding.new( self )

    parent_class_binding_base = nil
    parent_instance_binding_base = nil
    if @parent_types_controller = parent_types_controller
      parent_class_binding_base = parent_types_controller.class_binding_base
      parent_instance_binding_base = parent_types_controller.instance_binding_base
      parent_class_binding_class_and_binding_base = parent_types_controller.class_binding_class_and_binding_base
      @class_binding_class_base.module_eval { include parent_types_controller.class_binding_class_base }
      @class_binding_class_and_binding_base.module_eval { include parent_class_binding_class_and_binding_base }
    else
      parent_class_binding_base = ::Perspective::Bindings::ClassBinding
      parent_instance_binding_base = ::Perspective::Bindings::InstanceBinding
    end

    class_binding_class_and_binding_base = @class_binding_class_and_binding_base
    @class_binding_class_base.module_eval { include class_binding_class_and_binding_base }
    @class_binding_base.module_eval do
      include parent_class_binding_base
      include class_binding_class_and_binding_base
    end
    @instance_binding_base.module_eval { include parent_instance_binding_base }
    
    @binding_types = { }
    
    module_eval( & module_block ) if block_given?
    
  end

  #########################
  #  self.type_container  #
  #########################
  
  singleton_attr_reader :type_container

  ##################################
  #  self.parent_types_controller  #
  ##################################
  
  singleton_attr_reader :parent_types_controller
  
  #############################
  #  self.class_binding_base  #
  #############################

  singleton_attr_reader :class_binding_base

  ###################################
  #  self.class_binding_class_base  #
  ###################################

  singleton_attr_reader :class_binding_class_base

  ###############################################
  #  self.class_binding_class_and_binding_base  #
  ###############################################

  singleton_attr_reader :class_binding_class_and_binding_base

  ################################
  #  self.instance_binding_base  #
  ################################

  singleton_attr_reader :instance_binding_base

  ########################
  #  self.binding_types  #
  ########################
  
  singleton_attr_reader :binding_types

  ##########################
  #  self.binding_aliases  #
  ##########################
  
  singleton_attr_reader :binding_aliases

  ##############################
  #  self.define_binding_type  #
  ##############################
  
  def self.define_binding_type( binding_type_name, ancestor_type = nil )

    unless new_binding_type = @binding_types[ binding_type_name ]

      # Storage name is provided type name as a symbol
      binding_type_name = binding_type_name.to_sym
    
      # get ancestor instance from ancestor parameter, which can be type name or instance
      parent_type_instance = nil
      case ancestor_type
        
        # if ancestor_type is already a binding type we use it as the parent type instance
        when ::Perspective::Bindings::BindingTypeContainer::BindingType
        
          parent_type_instance = ancestor_type
        
        when ::Perspective::Bindings::BindingTypeContainer
          
          parent_type_instance = ancestor_type.types_controller.binding_types[ binding_type_name ]
          
        when ::Perspective::Bindings::BindingTypeContainer::TypesController

          parent_type_instance = ancestor_type.binding_types[ binding_type_name ]
          
        # if we have a parent type container we can look up a parent type instance
        # * if we have an ancestor type provided explicitly we use it
        # * otherwise we look up the name being defined in parent container
        when nil
          
          if parent_container = @type_container.parent_container
            parent_type_instance = parent_container.binding_types[ binding_type_name ]
          end
          
        else
          
          ancestor_type = ancestor_type.to_sym
          
          unless parent_type_instance = @binding_types[ ancestor_type ]
            if parent_container = @type_container.parent_container
              parent_type_instance = parent_container.types_controller.binding_types[ ancestor_type ]
            end
          end

      end
    
      # create and store new binding type
      new_binding_type = ::Perspective::Bindings::BindingTypeContainer::BindingType.new( self, 
                                                                                         binding_type_name, 
                                                                                         parent_type_instance )
      @binding_types[ binding_type_name ] = new_binding_type

      # declare any aliases that already existed for parent type (if any)
      if type_aliases = new_binding_type.aliases
        @binding_aliases ||= { }
        type_aliases.each { |this_alias| @binding_aliases[ this_alias ] = binding_type_name }
      end
    
    end
    
    return new_binding_type
    
  end

  #############################
  #  self.alias_binding_type  #
  #############################
  
  def self.alias_binding_type( alias_name, binding_type_name, binding_instance = @binding_types[ binding_type_name ] )
    
    @binding_aliases ||= { }
    
    @binding_aliases[ alias_name = alias_name.to_sym ] = binding_type_name = binding_type_name.to_sym
    binding_instance.declare_alias( alias_name )

    return self
    
  end

  #############################
  #  self.new«class_bindings»  #
  #############################
  
  ###
  # Create a new class binding for each binding name, each having the same configuration block. 
  #
  # 
  #
  def self.new«class_bindings»( binding_type, bound_to_container, *binding_names, & configuration_proc )

    return binding_names.collect do |this_binding_name|
      binding_type.class_binding_class.new( bound_to_container, this_binding_name, & configuration_proc )
    end
    
  end

  ###############################
  #  self.enable_class_binding  #
  ###############################
  
  ###
  # 
  #
  def self.enable_class_binding( bound_to_container, binding_instance )
    
    binding_name = binding_instance.«name»
    bound_to_container.«bindings»[ binding_name ] = binding_instance
    
    bound_to_container::ClassBindingMethods.define_binding( binding_name )
    bound_to_container::InstanceBindingMethods.define_binding( binding_name )
    
    return binding_instance
    
  end

end
