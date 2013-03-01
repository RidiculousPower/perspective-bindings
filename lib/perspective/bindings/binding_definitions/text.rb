# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::BindingDefinitions::Text

  ##############################
  #  binding_value_valid?  #
  ##############################

  def binding_value_valid?( binding_value )
    
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
