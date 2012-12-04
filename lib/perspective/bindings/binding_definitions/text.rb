
module ::Perspective::Bindings::BindingDefinitions::Text

  ##############################
  #  __binding_value_valid__?  #
  ##############################

  def __binding_value_valid__?( binding_value )
    
    binding_value_valid = false

    case binding_value
      
      when ::String, ::Symbol

        binding_value_valid = true
      
      else

        if defined?( super )
          binding_value_valid = super
        end

    end
    
    return binding_value_valid
    
  end

end
