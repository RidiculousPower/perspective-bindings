
module ::Magnets::Binding::Container::ObjectInstance::Validation

  ############################################
  #  ensure_binding_render_values_valid      #
  #  __ensure_binding_render_values_valid__  #
  ############################################
  
  def __ensure_binding_render_values_valid__
  
    # if we are rendering an empty view we don't want to raise an error for empty required values
    unless @__view_rendering_empty__
      
      self.class.__bindings__.each do |this_binding_name, this_binding_instance|
        
    		this_binding_value = __binding_value__( this_binding_name )
        unless this_binding_instance.render_value_valid?( this_binding_value )
          raise ::Magnets::Binding::Exception::BindingRequired,
                'Binding value required for :' + this_binding_name.to_s + ', but received nil.'
        end
        
      end

    else

      @__view_rendering_empty__ = false

	  end
    
  end
  alias_method  :ensure_binding_render_values_valid, :__ensure_binding_render_values_valid__

end
