# -*- encoding : utf-8 -*-

class ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingClass
  
  #######################
  #  self.new«subclass» #
  #######################
  
  def self.new«subclass»( parent_type_module, *modules )
    
    return ::Class.new( self ) { include( @parent_type_module = parent_type_module, *modules ) }
    
  end
  
  #############################
  #  self.parent_type_module  #
  #############################
  
  singleton_attr_reader :parent_type_module
    
end
