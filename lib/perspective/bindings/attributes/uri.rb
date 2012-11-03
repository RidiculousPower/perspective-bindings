
module ::Perspective::Bindings::Attributes::URI
  
  extend ::Perspective::Bindings::AttributeDefinitionModule
  
  ##########################
  #  __binding_value_valid__?  #
  ##########################

  def __binding_value_valid__?( binding_value )
    
    binding_value_valid = false
    
    if binding_value.is_a?( ::String )
      
      begin

        if URI.parse( binding_value )
          binding_value_valid = true
        end
      
      rescue ::URI::InvalidURIError

        # if URI is invalid we get here before binding_value_valid is set true

      end
      
    elsif binding_value.is_a?( ::URI )
      
      binding_value_valid = true
      
    elsif defined?( super )
      
      binding_value_valid = super
      
    end
    
    return binding_value_valid
    
  end

end
