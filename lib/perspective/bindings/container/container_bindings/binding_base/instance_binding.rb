
module ::Perspective::View::Bindings::BindingBase::InstanceBinding
  
  include ::Perspective::View::Configuration
  include ::Perspective::View::ObjectAndBindingInstance

  ###############
  #  view       #
  #  view=      #
  #  __view__   #
  #  __view__=  #
  ###############

  cluster( :aliases ).before_include.cascade_to( :module ) do |hooked_instance|
    
    hooked_instance.class_eval do

      alias_method :__view__, :__container__
      alias_method :__view__=, :__container__=

      alias_method :view, :__view__
      alias_method :view=, :__view__=
      
    end
  
  end
  
	########################
	#  __render_value__    #
	#  __autobind_value__  #
	########################
	
	def __autobind_value__( current_value = __value__ )
	  
    return current_value
    
  end
  
  alias_method  :__render_value__, :__autobind_value__

  #############################
  #  __render_value_valid__?  #
  #############################

  def __render_value_valid__?( ensure_valid = false, 
                               view_rendering_empty = @__view_rendering_empty__ )
    
    render_value_valid = true

    if __required__? and ! view_rendering_empty and __value__.nil?
      render_value_valid = false
    elsif view = __view__
      render_value_valid = view.__render_value_valid__?( ensure_valid, view_rendering_empty )
    end

    if ensure_valid and ! render_value_valid
      raise ::Perspective::Bindings::Exception::BindingRequired.new( self )
    end
    
    return render_value_valid
    
  end

end
