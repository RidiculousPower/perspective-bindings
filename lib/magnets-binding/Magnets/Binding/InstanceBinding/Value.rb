
module ::Magnets::Binding::InstanceBinding::Value

  ###############
  #  value      #
  #  __value__  #
  ###############

  def __value__
    
    if aliased_name = self.class.__binding_aliases__[ binding_name ]
      binding_name = aliased_name
    end
    
    return instance_variable_get( binding_name.variable_name )
    
  end

  ################
  #  value=      #
  #  __value__=  #
  ################

  def __value__=( object )
        
    binding_instance = self.class.__binding_configuration__( binding_name )
        
    unless binding_instance.binding_value_valid?( object )
      raise ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError, 
              'Invalid value ' +  object.inspect + ' for binding :' + binding_name.to_s + '.'
    end
    
    instance_variable_set( binding_name.variable_name, object )
    
    return object
    
  end

end
