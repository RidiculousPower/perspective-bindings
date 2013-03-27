# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Configuration

  include ::CascadingConfiguration::Value
  
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
		
		return «bindings».has_key?( binding_name )  || 
		       «binding_aliases».has_key?( binding_name )
		
	end

  #################################
  #  «autobind_value_to_binding»  #
  #################################
  
  attr_instance_value :«autobind_value_to_binding» do |parent_binding, parent_instance|
    parent_binding ? «binding»( parent_binding.«name» ) : nil
  end
  
  ##################################
  #  «autobind_value_to_binding»=  #
  ##################################
  
  def «autobind_value_to_binding»=( binding_or_binding_name )

    set_value = nil

    case binding_or_binding_name
      when ::Symbol, ::String
        set_value = «binding»( binding_or_binding_name )
      else
        set_value = binding_or_binding_name
    end

    return super( set_value )
    
  end

end
