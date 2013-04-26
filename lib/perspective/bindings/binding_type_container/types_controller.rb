# -*- encoding : utf-8 -*-

###
# Type controller for groups of binding types.
#
class ::Perspective::Bindings::BindingTypeContainer::TypesController

  include ::CascadingConfiguration::Hash

  ##############
  #  self.new  #
  ##############
  
  def self.new( type_container, parent_types_controller = nil, subclass_parent_bindings = true, & module_block )
    
    return ::Class.new( parent_types_controller || self ) { initialize( type_container,
                                                                        parent_types_controller,
                                                                        subclass_parent_bindings,
                                                                        & module_block ) }
    
  end

  #####################
  #  self.initialize  #
  #####################

  def self.initialize( type_container, parent_types_controller = nil, subclass_parent_bindings = true, & module_block )

    @type_container = type_container
    @subclass_parent_bindings = subclass_parent_bindings
  
    @class_binding_base = ::Perspective::Bindings::BindingTypeContainer::BindingBase::ClassBinding.new( self )
    @instance_binding_base = ::Perspective::Bindings::BindingTypeContainer::BindingBase::InstanceBinding.new( self )
  
    if @parent_types_controller = parent_types_controller
      @class_binding_base.module_eval    { include parent_types_controller.class_binding_base }
      @instance_binding_base.module_eval { include parent_types_controller.instance_binding_base }
    else
      @class_binding_base.module_eval    { include ::Perspective::Bindings::ClassBinding }
      @instance_binding_base.module_eval { include ::Perspective::Bindings::InstanceBinding }
    end
    
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
  
  #####################################
  #  self.subclass_parent_bindings  #
  #####################################
  
  singleton_attr_reader :subclass_parent_bindings

  #############################
  #  self.class_binding_base  #
  #############################

  singleton_attr_reader :class_binding_base

  ################################
  #  self.instance_binding_base  #
  ################################

  singleton_attr_reader :instance_binding_base

  ########################
  #  self.binding_types  #
  ########################
  
  attr_singleton_hash :binding_types do
    
    #======================#
    #  child_pre_set_hook  #
    #======================#
    
    def child_pre_set_hook( binding_type_name, parent_binding_type_instance, parent_hash )
      
      child_instance = nil
      
      instance = configuration_instance
      
      # don't subclass bindings from parents of parent - only bindings that parent owns
      if instance.subclass_parent_bindings and 
         parent_binding_type_instance.types_controller == parent_hash.configuration_instance
        
        child_instance = parent_binding_type_instance.class.new( instance, 
                                                                 binding_type_name, 
                                                                 parent_binding_type_instance )
        instance.const_set( binding_type_name.to_s.to_camel_case, child_instance )
        instance.type_container.define_binding_methods( binding_type_name )
        
      else
      
        child_instance = parent_binding_type_instance
      
      end
      
      return child_instance
      
    end
    
  end

  ##########################
  #  self.binding_aliases  #
  ##########################
  
  attr_singleton_hash :binding_aliases

  ##############################
  #  self.define_binding_type  #
  ##############################
  
  def self.define_binding_type( binding_type_name, ancestor_type = nil )
    
    unless new_binding_type = binding_types[ binding_type_name ]

      # Storage name is provided type name as a symbol
      binding_type_name = binding_type_name.to_sym
    
      # get ancestor instance from ancestor parameter, which can be type name or instance
      parent_type_instance = nil
      case ancestor_type
        # if ancestor_type is already a binding type we use it as the parent type instance
        when ::Perspective::Bindings::BindingTypeContainer::BindingType
          parent_type_instance = ancestor_type
        # if we have a parent type container we can look up a parent type instance
        # * if we have an ancestor type provided explicitly we use it
        # * otherwise we look up the name being defined in parent container
        else
          parent_type_instance = ancestor_type ? binding_types[ ancestor_type.to_sym ]
                                               : binding_types[ binding_type_name ]
      end
    
      # create and store new binding type
      new_binding_type = ::Perspective::Bindings::BindingTypeContainer::BindingType.new( self, 
                                                                                         binding_type_name, 
                                                                                         parent_type_instance )
      binding_types[ binding_type_name ] = new_binding_type
    
    end
    
    return new_binding_type
    
  end

  #############################
  #  self.alias_binding_type  #
  #############################
  
  def self.alias_binding_type( alias_name, binding_type_name )
    
    binding_aliases[ alias_name.to_sym ] = binding_type_name.to_sym

    return self
    
  end

  #############################
  #  self.new_class_bindings  #
  #############################
  
  ###
  # Create a new class binding for each binding name, each having the same configuration block. 
  #
  # 
  #
  def self.new_class_bindings( binding_type, bound_to_container, *binding_names, & configuration_proc )

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
    
    bound_to_container::Controller::ClassBindingMethods.define_binding( binding_name )
    bound_to_container::Controller::InstanceBindingMethods.define_binding( binding_name )
    
    return binding_instance
    
  end

end
