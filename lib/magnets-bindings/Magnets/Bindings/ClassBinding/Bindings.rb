
module ::Magnets::Bindings::ClassBinding::Bindings
  
  #############################################
  #  __duplicate_as_inheriting_sub_binding__  #
  #############################################

  def __duplicate_as_inheriting_sub_binding__( base_route = nil )
  
    return self.class.new( nil, nil, self, base_route )
    
  end

end
