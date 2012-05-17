
module ::Magnets::Binding::ClassBinding::Bindings

	#################
  #  binding      #
  #  __binding__  #
  #################
    
  def __binding__( binding_name )
    
    binding_instance = nil
    
    unless binding_instance = @__sub_bindings__[ binding_name ]
      
      binding_instance = @__shared_sub_bindings__[ binding_name ]
      
    end
    
    return binding_instance    
    
  end
  alias_method  :binding, :__binding__

  #############################################
  #  __duplicate_as_inheriting_sub_binding__  #
  #############################################

  def __duplicate_as_inheriting_sub_binding__( base_route = nil )
    
    base_route ||= __route__.dup
    
    return self.class.new( nil, nil, self, base_route )
    
  end

end
