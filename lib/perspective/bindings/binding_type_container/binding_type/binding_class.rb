# -*- encoding : utf-8 -*-

class ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingClass
  
  ########################
  #  self.new«subclass»  #
  ########################
  
  def self.new«subclass»( parent_type_module = nil, *modules )
    
    return ::Class.new( self ) do
      if @parent_type_module = parent_type_module
        include( @parent_type_module )
      end
      include( *modules ) unless modules.empty?
    end
    
  end
  
  #############################
  #  self.parent_type_module  #
  #############################
  
  singleton_attr_reader :parent_type_module
    
end
