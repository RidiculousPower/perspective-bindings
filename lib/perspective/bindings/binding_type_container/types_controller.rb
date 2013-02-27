
###
# Type controller for groups of binding types.
#
class ::Perspective::Bindings::BindingTypeContainer::TypesController < ::Module

  include ::CascadingConfiguration::Hash

  ################
  #  initialize  #
  ################
  
  def initialize( parent_types_controller = nil, subclass_existing_bindings = true, & module_block )
    
    @subclass_existing_bindings = subclass_existing_bindings
    
    @class_binding_base = ::Perspective::Bindings::BindingTypeContainer::BindingBase::ClassBinding.new( self )
    @instance_binding_base = ::Perspective::Bindings::BindingTypeContainer::BindingBase::InstanceBinding.new( self )
    
    if @parent_types_controller = parent_types_controller
      include parent_types_controller
      @class_binding_base.module_eval    { include parent_types_controller.class_binding_base }
      @instance_binding_base.module_eval { include parent_types_controller.instance_binding_base }
    else
      @class_binding_base.module_eval    { include ::Perspective::Bindings::BindingBase::ClassBinding }
      @instance_binding_base.module_eval { include ::Perspective::Bindings::BindingBase::InstanceBinding }
    end
    
    super( & module_block )
    
  end

  #############################
  #  parent_types_controller  #
  #############################
  
  attr_reader :parent_types_controller
  
  ################################
  #  subclass_existing_bindings  #
  ################################
  
  attr_reader :subclass_existing_bindings

  ########################
  #  class_binding_base  #
  ########################

  attr_reader :class_binding_base

  ###########################
  #  instance_binding_base  #
  ###########################

  attr_reader :instance_binding_base

  ###################
  #  binding_types  #
  ###################
  
  attr_instance_hash :binding_types do
    
    #======================#
    #  child_pre_set_hook  #
    #======================#
    
    def child_pre_set_hook( binding_type_name, parent_binding_type_instance, parent_hash )
      
      child_instance = nil

      if configuration_instance.subclass_existing_bindings
        child_instance = parent_binding_type_instance.class.new( configuration_instance, 
                                                                 binding_type_name, 
                                                                 parent_binding_type_instance )
      else
        child_instance = parent_binding_type_instance
      end
      
      return child_instance
      
    end
    
  end

  #####################
  #  binding_aliases  #
  #####################
  
  attr_instance_hash :binding_aliases

  #########################
  #  define_binding_type  #
  #########################
  
  def define_binding_type( binding_type_name, ancestor_type = nil )
    
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

  ########################
  #  alias_binding_type  #
  ########################
  
  def alias_binding_type( alias_name, binding_type_name )
    
    binding_aliases[ alias_name.to_sym ] = binding_type_name.to_sym

    return self
    
  end

end
