
class ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingClass
    
  #######################
  #  self.new_subclass  #
  #######################
  
  def self.new_subclass( parent_type_module, *modules )
    
    return ::Class.new( self ) do
      @parent_type_module = parent_type_module
      include( parent_type_module, *modules )
    end
    
  end
  
  #############################
  #  self.parent_type_module  #
  #############################
  
  singleton_attr_reader :parent_type_module
  
end
