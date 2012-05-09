
module ::Magnets::Bindings::Binding::SubBindings

	#################
  #  __binding__  #
  #################
    
  def __binding__( binding_name )
    
    binding_instance = nil
    
    unless binding_instance = @__sub_bindings__[ binding_name ]
      
      binding_instance = @__shared_sub_bindings__[ binding_name ]
      
    end
    
    return binding_instance    
    
  end
    
  ##################################
  #  __shared_binding_for_route__  #
  ##################################
  
  def __shared_binding_for_route__( binding_route, shared_binding_name )
    
    binding_context_for_route = ::Magnets::Bindings.binding_context_for_route( shared_binding_name,
                                                                               self,
                                                                               binding_route,
                                                                               shared_binding_name )
    
    return binding_context_for_route.__binding__( shared_binding_name )
    
  end

  #############################################
  #  __duplicate_as_inheriting_sub_binding__  #
  #############################################

  def __duplicate_as_inheriting_sub_binding__( base_route = @__route__ )
    
    return self.class.new( @__bound_module__, __name__, __view_class__, self, base_route )
    
  end

end
