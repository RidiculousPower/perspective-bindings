
module ::Magnets::Bindings::Binding::Definition::Module

  ####################################
  #  __ensure_binding_value_valid__  #
  ####################################

  def __ensure_binding_value_valid__( binding_value )
    
    binding_value_valid = false
    
    if binding_value.is_a?( Module ) and ! binding_value.is_a?( Class )
      
      binding_value_valid = true
      
    elsif defined?( super )
      
      binding_value_valid = super
      
    end
    
    return binding_value_valid
    
  end

end
