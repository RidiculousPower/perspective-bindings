
module ::Perspective::Bindings::Configuration

  ########################
  #  parent_binding      #
  #  __parent_binding__  #
  ########################

  attr_reader  :__parent_binding__

  alias_method  :parent_binding, :__parent_binding__

	#################
  #  binding      #
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
  alias_method  :binding, :__binding__

  ##################
  #  has_binding?  #
  ##################

  # has_binding? :name, ...
  # 
	def has_binding?( binding_name )
		
		has_binding = false
		
		# if we have binding, alias, or re-binding
		if 	__bindings__.has_key?( binding_name )        or 
		    __binding_aliases__.has_key?( binding_name ) or
		    __local_aliases_to_bindings__.has_key?( binding_name )
		
			has_binding = true
		
		end
		
		return has_binding
		
	end

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  def __configure__( & configuration_proc )
        
    __configuration_procs__.push( configuration_proc )
    
  end

  alias_method( :configure, :__configure__ )
  
end
