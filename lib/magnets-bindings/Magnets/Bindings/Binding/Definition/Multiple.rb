
module ::Magnets::Bindings::Binding::Definition::Multiple

  ####################################
  #  __ensure_binding_value_valid__  #
  ####################################

  def __ensure_binding_value_valid__( binding_value )
    
    binding_value_valid = false
    
    if binding_value.is_a?( ::Array )
      
      binding_value_valid = true
      
      # ensure each member value is valid
      binding_value.each do |this_member|
        
        break unless binding_value_valid = __ensure_binding_value_valid__( this_member )
        
      end
    
    elsif defined?( super )
      
      binding_value_valid = super
          
    end
    
    return binding_value_valid
    
  end

end
