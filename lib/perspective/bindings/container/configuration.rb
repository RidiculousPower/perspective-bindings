# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Container::Configuration
  
  #################
  #  «binding  #
  #################
    
  def «binding( binding_name )
    
    binding_instance = nil

    unless binding_instance = super
      binding_instance = «local_aliases_to_bindings[ binding_name.to_sym ]
    end
    
    return binding_instance
    
  end

  ######################
  #  has_binding?  #
  ######################

  # has_binding? :name, ...
  # 
	def has_binding?( binding_name )
		
		return super || «local_aliases_to_bindings.has_key?( binding_name )
		
	end
	
end
