
module ::Magnets::Bindings::Binding::Definition::Required

  ###################################
  #  __ensure_render_value_valid__  #
  ###################################

  def __ensure_render_value_valid__( binding_value )

    render_value_valid = true

    # if binding is required and has a nil value, raise exception
		if ! binding_value

      render_value_valid = false
      
    elsif defined?( super )
      
      render_value_valid = super
      
		end
		
		return render_value_valid
		
	end

end
