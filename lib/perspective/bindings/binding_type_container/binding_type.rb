# -*- encoding : utf-8 -*-

###
# A BindingType groups the actual classes used to create a binding of the given type.
#
#   A BindingType holds modules for each binding type so that they can be included
#   in inheriting modules of the same type. 
#
#   A BindingType also holds classes for each binding type, which are used to create
#   the actual bindings that will be used.
#
class ::Perspective::Bindings::BindingTypeContainer::BindingType < ::Module

  include ::Perspective::Bindings::IncludeExtend

  ################
  #  initialize  #
  ################
  
  ###
  # We use a class so that singleton inheritance cascades. We do not want instances of
  #   the singleton, so we override #new to give us a subclass.
  #
  def initialize( types_controller, type_name, parent_type_instance = nil )
    
    super()
    
    @types_controller = types_controller
    @type_name = type_name

    class_binding_class = nil
    instance_binding_class = nil
    
    if @parent_type = parent_type_instance
      include @parent_type
      class_binding_class = @parent_type.class_binding_class
      instance_binding_class = @parent_type.instance_binding_class
    else
      class_binding_class = ::Perspective::Bindings::BindingTypeContainer::BindingType::ClassBindingClass
      instance_binding_class = ::Perspective::Bindings::BindingTypeContainer::BindingType::InstanceBindingClass
    end
        
    @class_binding_class = class_binding_class.new_subclass( self, @types_controller.class_binding_base )
    @instance_binding_class = instance_binding_class.new_subclass( self, @types_controller.instance_binding_base )
    
    const_set( :ClassBinding,    @class_binding_class )
    const_set( :InstanceBinding, @instance_binding_class )
            
  end

  ###############
  #  type_name  #
  ###############
  
  ###
  # Name of binding type.
  #
  # @!attribute [r] type_name
  #
  # @return [Symbol,String] Name of binding type.
  #
  attr_reader :type_name

  ######################
  #  types_controller  #
  ######################
  
  attr_reader :types_controller

  #################
  #  parent_type  #
  #################

  attr_reader :parent_type
  
  #########################
  #  class_binding_class  #
  #########################

  attr_reader :class_binding_class

  ############################
  #  instance_binding_class  #
  ############################

  attr_reader :instance_binding_class

end
