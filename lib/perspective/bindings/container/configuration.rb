
module ::Perspective::Bindings::Container::Configuration
  
  #################
  #  __binding__  #
  #################
    
  def __binding__( binding_name )
    
    binding_instance = nil

    unless binding_instance = super
      binding_instance = __local_aliases_to_bindings__[ binding_name.to_sym ]
    end
    
    return binding_instance
    
  end

  ######################
  #  has_binding?  #
  ######################

  # has_binding? :name, ...
  # 
	def has_binding?( binding_name )
		
		return super || __local_aliases_to_bindings__.has_key?( binding_name )
		
	end
	
end
