
module ::Magnets::Bindings::Binding::Validation

  ####################################
  #  __ensure_binding_value_valid__  #
  ####################################

  def __ensure_binding_value_valid__( binding_value )
    
    # if we got here (the top) then the only valid value is nil
    return binding_value.nil?
    
  end

end
