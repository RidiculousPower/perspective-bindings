
module ::Magnets::Bindings::Binding::Rendering

	##############################
	#  __render_binding_value__  #
	##############################
	
	def __render_binding_value__( binding_value )
	  
	  rendered_binding_value = nil
	  
	  case binding_value
      
      when nil
      
        # nothing required
      
      when ::String

        rendered_binding_value = binding_value
        
      when ::Symbol, ::Integer, ::Float, ::Complex, ::Rational, ::Regexp, 
           ::Class, ::Module, ::TrueClass, ::FalseClass

        rendered_binding_value = binding_value.to_s
        
      when ::File
        
        rendered_binding_value = File.readlines.join
        
      else
        
        rendered_binding_value = binding_value
        
    end
    
    return rendered_binding_value
    
  end

end
