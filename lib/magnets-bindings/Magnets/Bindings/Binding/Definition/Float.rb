
module ::Magnets::Bindings::Binding::Definition::Float

  ####################################
  #  __ensure_binding_value_valid__  #
  ####################################

  def __ensure_binding_value_valid__( binding_value )
    
    binding_value_valid = false
    
    if binding_value.is_a?( Float )
      
      binding_value_valid = true
      
    elsif defined?( super )
      
      binding_value_valid = super
      
    end
    
    return binding_value_valid
    
  end

end
