
module ::Rmagnets::Bindings::ClassInstance::Bindings::Text

  ###############
  #  attr_text  #
  ###############

  # attr_text :name, ... 
  # attr_text :name => ViewClass, ...
  # attr_text :name, ... { ... configuration proc ... }
  # attr_text :name => ViewClass, ... { ... configuration proc ... }
  # attr_text *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
  # An attr_text view is treated as a container for the text bound to attr_text,
  # and the bound string will be bound to :content of the view instance. 
  #
	def attr_text( *args, & configuration_proc )

    bindings = create_bindings_for_args( args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.__text_permitted__ = true      
		end
		
		return bindings

	end

  ################
  #  attr_texts  #
  ################

  # attr_texts :name, ... 
  # attr_texts :name => ViewClass, ...
  # attr_texts :name, ... { ... configuration proc ... }
  # attr_texts :name => ViewClass, ... { ... configuration proc ... }
  # attr_texts *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
  # An attr_text view is treated as a container for the text bound to attr_text,
  # and the bound string will be bound to :content of the view instance. 
  #
	def attr_texts( *args, & configuration_proc )

    bindings = attr_text( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ########################
  #  attr_required_text  #
  ########################

  # attr_required_text :name, ... 
  # attr_required_text :name => ViewClass, ...
  # attr_required_text :name, ... { ... configuration proc ... }
  # attr_required_text :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_text *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_text( *args, & configuration_proc )
		
		bindings = attr_text( *args, & configuration_proc )

		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
    
		return bindings
		
	end

  #########################
  #  attr_required_texts  #
  #########################

  # attr_required_texts :name, ... 
  # attr_required_texts :name => ViewClass, ...
  # attr_required_texts :name, ... { ... configuration proc ... }
  # attr_required_texts :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_texts *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_texts( *args, & configuration_proc )
		
		bindings = attr_required_text( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
    
	end

end
