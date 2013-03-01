# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Configuration

  ######################
  #  «parent_binding»  #
  ######################

  attr_reader  :«parent_binding»

	###############
  #  «binding»  #
  ###############
    
  def «binding»( binding_name )
    
    binding_instance = nil

    unless binding_instance = «bindings»[ binding_name = binding_name.to_sym ]
      if binding_alias = «binding_aliases»[ binding_name ]
        binding_instance = «bindings»[ binding_alias ]
      end
    end
    
    return binding_instance
    
  end

  ##################
  #  has_binding?  #
  ##################

  # has_binding? :name, ...
  # 
	def has_binding?( binding_name )
		
		return «bindings».has_key?( binding_name )        || 
		       «binding_aliases».has_key?( binding_name )
		
	end

end
