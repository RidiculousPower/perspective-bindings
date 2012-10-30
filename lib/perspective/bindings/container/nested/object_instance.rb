
module ::Perspective::Bindings::Container::Nested::ObjectInstance

  ################
  #  initialize  #
  ################
  
  def initialize( parent_binding_instance, *superclass_args )
    
    ::CascadingConfiguration.register_parent( self, parent_binding_instance )
    
    @__parent_binding__ = parent_binding_instance
    @__bound_container__ = parent_binding_instance
    
    super( *superclass_args )
    
  end

end
