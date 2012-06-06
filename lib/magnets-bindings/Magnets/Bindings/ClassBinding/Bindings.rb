
module ::Magnets::Bindings::ClassBinding::Bindings

  #############################################
  #  __duplicate_as_inheriting_sub_binding__  #
  #############################################

  def __duplicate_as_inheriting_sub_binding__( base_route = nil )
  
    new_binding = self.class.new( nil, nil, self, base_route )
    new_binding.__bound_container_class__ = __bound_container_class__
    
    return new_binding
    
  end

end
