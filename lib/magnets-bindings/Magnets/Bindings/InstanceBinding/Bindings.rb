
module ::Magnets::Bindings::InstanceBinding::Bindings

  #############################################
  #  __duplicate_as_inheriting_sub_binding__  #
  #############################################

  def __duplicate_as_inheriting_sub_binding__
  
    return self.class.new( self )
    
  end

end
