
module ::Magnets::Binding::InstanceBinding::Initialization

  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding )
    
    __initialize_for_parent_binding__( parent_class_binding )
    
    __initialize_view__
              
  end
  
  #######################################
  #  __initialize_for_parent_binding__  #
  #######################################
  
  def __initialize_for_parent_binding__( parent_class_binding )
    
    @__parent_binding__ = parent_class_binding
    
    # register parent class binding as ancestor for configurations
    ::CascadingConfiguration::Variable.register_child_for_parent( self, parent_class_binding )
    
  end

  #########################
  #  __initialize_view__  #
  #########################
  
  def __initialize_view__
    
    if view_class = @__parent_binding__.__view_class__
      self.__view__ = view_class.new
      #        child_instance.extend( view_class::BindingMethods )
    end
    
  end
  
end
