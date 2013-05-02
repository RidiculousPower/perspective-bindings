# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::IncludeExtendForwarding::InitializeInstances
  
  ################
  #  initialize  #
  ################
  
  def initialize( *args )
    
    @child_binding_types = ::Array::Unique.new( self )
    
    super if defined?( super )
    
  end
  
end
