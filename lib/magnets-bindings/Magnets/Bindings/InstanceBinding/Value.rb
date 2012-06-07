
module ::Magnets::Bindings::InstanceBinding::Value

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
            
    case object
      
      when ::Magnets::Bindings::InstanceBinding

        @__value__ = object.__value__
      
      else

        unless binding_value_valid?( object )
          raise ::Magnets::Bindings::Exception::BindingInstanceInvalidType, 
                  'Invalid value ' +  object.inspect + ' for binding :' + __name__.to_s + '.'
        end

        @__value__ = object
      
    end    

    __set_value_in_container__
    
    return object
    
  end

  alias_method  :value=, :__value__=
  
  ################################
  #  __set_value_in_container__  #
  ################################
  
  def __set_value_in_container__
    
    if container = __container__
      container.__autobind__( __value__ )    
    end
    
  end

end
