
module ::Magnets::Binding::InstanceBinding::Value

  ###############
  #  value      #
  #  __value__  #
  ###############

  attr_reader  :__value__

  alias_method  :value, :__value__

  ################
  #  value=      #
  #  __value__=  #
  ################

  def __value__=( object )
        
    unless binding_value_valid?( object )
      raise ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError, 
              'Invalid value ' +  object.inspect + ' for binding :' + __name__.to_s + '.'
    end
    
    @__value__ = object
    
    return object
    
  end

  alias_method  :value=, :__value__=

end
