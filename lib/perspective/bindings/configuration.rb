
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
      else
        binding_instance = __local_aliases_to_bindings__[ binding_name ]
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
		       __binding_aliases__.has_key?( binding_name ) ||
		       __local_aliases_to_bindings__.has_key?( binding_name )
		
	end

  ###################
  #  __configure__  #
  ###################

  def __configure__( & configuration_proc )
        
    __configuration_procs__.push( configuration_proc )
    
    return self
    
  end

  ###############
  #  configure  #
  ###############

  alias_method( :configure, :__configure__ )
  
end
