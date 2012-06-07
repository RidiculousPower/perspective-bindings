
module ::Magnets::Bindings::ClassBinding::Bindings

  #############################################
  #  __duplicate_as_inheriting_sub_binding__  #
  #############################################

  def __duplicate_as_inheriting_sub_binding__( base_route = nil )
  
    new_binding = self.class.new( self, nil, nil, self, base_route )
    
    return new_binding
    
  end

end
