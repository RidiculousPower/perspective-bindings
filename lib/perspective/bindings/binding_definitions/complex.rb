
module ::Perspective::Bindings::BindingDefinitions::Complex

  ##############################
  #  binding_value_valid?  #
  ##############################

  def binding_value_valid?( binding_value )
    
    binding_value_valid = false
    
    if binding_value.is_a?( ::Complex )
      
      binding_value_valid = true
      
    elsif defined?( super )
      
      binding_value_valid = super
      
    end
    
    return binding_value_valid
    
  end
  
end
