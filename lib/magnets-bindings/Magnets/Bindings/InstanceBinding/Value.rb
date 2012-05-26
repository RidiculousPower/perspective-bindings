
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
          raise ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError, 
                  'Invalid value ' +  object.inspect + ' for binding :' + __name__.to_s + '.'
        end

        @__value__ = object

        if __container__
          self.__container__.__autobind__( object )    
        end
      
    end    
    
    return object
    
  end

  alias_method :value=, :__value__=

end
