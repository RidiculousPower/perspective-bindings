
module ::Magnets::Binding::InstanceBinding::Initialization

  ################
  #  initialize  #
  ################

  def initialize( parent_class_binding )
    
    @__parent_binding__ = parent_class_binding
        
    # register parent class binding as ancestor for configurations
    ::CascadingConfiguration::Variable.register_child_for_parent( self, parent_class_binding )
            
    __initialize_for_parent_binding__
            
  end
  
  #######################################
  #  __initialize_for_parent_binding__  #
  #######################################
  
  def __initialize_for_parent_binding__
    
  end
  
end
