
module ::Magnets::Bindings::InstanceBinding::Rendering

  #########################
  #  render_value_valid?  #
  #########################

  def render_value_valid?
    
    render_value_valid = true
    
    if required? and __value__.nil?
      render_value_valid = false
    end
    
    return render_value_valid
    
  end
  alias_method  :ensure_render_value_valid, :render_value_valid?

	######################
	#  render_value      #
	#  __render_value__  #
	######################
	
	def __render_value__
	  
	  rendered_binding_value = nil
	  
	  case value = __value__
      
      when nil
      
        # nothing required
      
      when ::String

        rendered_binding_value = value
        
      when ::Symbol, ::Integer, ::Float, ::Complex, ::Rational, ::Regexp, 
           ::Class, ::Module, ::TrueClass, ::FalseClass

        rendered_binding_value = value.to_s
        
      when ::File
        
        rendered_binding_value = ::File.readlines.join
        
      else
        
        rendered_binding_value = value
        
    end
    
    return rendered_binding_value
    
  end
  alias_method  :render_value, :__render_value__

end
