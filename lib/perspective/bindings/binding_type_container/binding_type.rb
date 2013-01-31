
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

  ################
  #  initialize  #
  ################
  
  ###
  # We use a class so that singleton inheritance cascades. We do not want instances of
  #   the singleton, so we override #new to give us a subclass.
  #
  def initialize( type_container, type_name, parent_type_instance = nil )
        
    @child_binding_classes = ::Array::Unique.new( self )
    
    @type_container = type_container
    @type_name = type_name

    class_binding_class = nil
    instance_binding_class = nil
    
    if @parent_type = parent_type_instance
      include @parent_type
      child_type = self
      @parent_type.module_eval { @child_binding_classes.push( child_type ) }
      class_binding_class = @parent_type.class_binding_class
      instance_binding_class = @parent_type.instance_binding_class
    else
      class_binding_class = ::Perspective::Bindings::BindingTypeContainer::BindingType::ClassBindingClass
      instance_binding_class = ::Perspective::Bindings::BindingTypeContainer::BindingType::InstanceBindingClass
    end

    @class_binding_class = class_binding_class.new_subclass( self, @type_container.class_binding_base )
    @instance_binding_class = instance_binding_class.new_subclass( self, @type_container.instance_binding_base )
    
    const_set( :ClassBindingClass,    @class_binding_class )
    const_set( :InstanceBindingClass, @instance_binding_class )
        
  end

  ##############
  #  included  #
  ##############
  
  def included( module_instance )
    
    @child_binding_classes.push( module_instance )
    
    super
    
  end
  
  #################
  #  __include__  #
  #################
  
  alias_method :__include__, :include
  
  #############
  #  include  #
  #############
  
  def include( *modules )
    
    super
    
    _binding_base = self

    @child_binding_classes.each do |this_child_binding_class|
      this_child_binding_class.module_eval { include( _binding_base ) }
    end
    
    return self
    
  end

  ################
  #  __extend__  #
  ################

  alias_method :__extend__, :extend
  
  ############
  #  extend  #
  ############

  def extend( *modules )

    super

    @child_binding_classes.each do |this_child_binding_class|
      this_child_binding_class.extend( *modules )
    end
    
    return self
    
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

  ####################
  #  type_container  #
  ####################
  
  attr_reader :type_container

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
