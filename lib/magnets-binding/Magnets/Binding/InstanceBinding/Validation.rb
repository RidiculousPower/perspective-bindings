
module ::Magnets::Binding::InstanceBinding::Validation

  ##########################
  #  binding_value_valid?  #
  ##########################

  def binding_value_valid?( binding_value )
    
    # if we got here (the top) then the only valid value is nil
    return binding_value.nil?
    
  end
  alias_method  :ensure_binding_value_valid, :binding_value_valid?

end
