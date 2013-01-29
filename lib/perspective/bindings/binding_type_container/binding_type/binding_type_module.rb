
###
# A BindingTypeModule controls the class instance for class, nested class, instance, or nested instance
#   bindings. It is a module so that it can be included in subclassed types while also maintaining the
#   inheritance structure for nested bindings.
#
#   This last detail can be illustrated as follows for binding type A and B with class bindings A-C and B-C
#   and nested class bindings A-NC and B-NC:
#   
#   * A-NC will include A-C
#   * B-C will include A-C
#   * B-NC will include A-C, A-NC, B-C
#
#   The third case makes handling with subclassing difficult (due to the split for nested bindings), as
#   B-NC would end up inheriting from B-C, leaving out A-NC. The difficulty can be resolved by using modules 
#   for each rather than classes.
#
#   The result is that the modules that control each type of binding control an internal class that will
#   be used to create the particular binding instances.
#
class ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeModule < ::Module
  
  ################
  #  initialize  #
  ################
  
  def initialize( parent_binding_type, *modules )
    
    @parent_binding_type = parent_binding_type

    # module controls a class to create instances
    @binding_type_class = ::Perspective::Bindings::BindingTypeContainer::BindingType::
                            BindingTypeClass.new_subclass( self )
    const_set( :Class, @binding_type_class )
    
    include( *modules )
        
  end
  
  #############
  #  include  #
  #############
  
  def include( *modules )
    
    super
    
    # include or re-include self to keep class up-to-date
    binding_type_module = self
    @binding_type_class.class_eval { __include__( binding_type_module ) }    
    
    return self
    
  end

  ############
  #  extend  #
  ############
  
  def extend( *modules )

    super

    # include or re-include self to keep class up-to-date
    @binding_type_class.__extend__( self )  
    
    return self

  end

  #########################
  #  parent_binding_type  #
  #########################
  
  ###
  # Parent binding type for which this instance was created.
  #
  attr_reader :parent_binding_type

  ########################
  #  binding_type_class  #
  ########################
  
  attr_reader :binding_type_class
  
  #########
  #  new  #
  #########
  
  def new( *args )
    
    return @binding_type_class.new( *args )
    
  end
  
end
