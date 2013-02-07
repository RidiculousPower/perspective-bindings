
module ::Perspective::Bindings::Configuration

  ########################
  #  __parent_binding__  #
  ########################

  attr_reader  :__parent_binding__

	#################
  #  __binding__  #
  #################
    
  def __binding__( binding_name )
    
    binding_instance = nil

    unless binding_instance = __bindings__[ binding_name ]
      if binding_alias = __binding_aliases__[ binding_name ]
        binding_instance = __bindings__[ binding_alias ]
      end
    end
    
    return binding_instance
    
  end

  ######################
  #  __has_binding__?  #
  ######################

  # __has_binding__? :name, ...
  # 
	def __has_binding__?( binding_name )
		
		return __bindings__.has_key?( binding_name )        || 
		       __binding_aliases__.has_key?( binding_name )
		
	end

end
