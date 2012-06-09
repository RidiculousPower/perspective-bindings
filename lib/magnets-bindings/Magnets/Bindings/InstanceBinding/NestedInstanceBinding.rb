
module ::Magnets::Bindings::InstanceBinding::NestedInstanceBinding
  
  ######################
  #  nested_route      #
  #  __nested_route__  #
  ######################

  def __nested_route__( nested_in_binding )
    
    return @__parent_binding__.__nested_route__( nested_in_binding )
    
  end
  
end
