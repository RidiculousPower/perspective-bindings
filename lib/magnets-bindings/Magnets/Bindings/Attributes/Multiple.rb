
module ::Magnets::Bindings::Attributes::Multiple

  extend ::Magnets::Bindings::AttributeDefinitionModule

  ################
  #  value=      #
  #  __value__=  #
  ################

  def __value__=( object )
    
    super
    
    if current_container = __container__
      
      # if we have an array we want 1 corresponding container per member
      if object.is_a?( ::Array )

        object_count_minus_one = object.count - 1

        if object_count_minus_one > 0
          
          case current_container
            
            when   ::Magnets::Bindings::Container::MultiContainerProxy

              current_container.__autobind__( *object )

            else

              self.__container__ = ::Magnets::Bindings::Container::
                                     MultiContainerProxy.new( self, *object )

          end
        
        else
          
          current_container.__autobind__( object[ 0 ] )
        
        end
      
      end
      
    end
    
    return object
    
  end

  alias_method :value=, :__value__=

  ##########################
  #  binding_value_valid?  #
  ##########################

  def binding_value_valid?( binding_value )

    binding_value_valid = false
    
    if binding_value.is_a?( ::Array )
      
      binding_value_valid = true
      
      # ensure each member value is valid
      binding_value.each do |this_member|
        
        break unless binding_value_valid = binding_value_valid?( this_member )
        
      end
    
    elsif defined?( super )
      
      binding_value_valid = super
          
    end
    
    return binding_value_valid
    
  end

end
