
module ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber

  #########################
  #  attr_text_or_number  #
  #########################

  # attr_text_or_number :name, ... 
  # attr_text_or_number :name => ViewClass, ...
  # attr_text_or_number :name, ... { ... configuration proc ... }
  # attr_text_or_number :name => ViewClass, ... { ... configuration proc ... }
  # attr_text_or_number *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
  # An attr_text_or_number view is treated as a container for the text bound to attr_text_or_number,
  # and the bound string will be bound to :content of the view instance. 
  #
	def attr_text_or_number( *args, & configuration_proc )

    bindings = attr_text( *args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.__number_permitted__ = true
		end
		
		return bindings

	end

  ##########################
  #  attr_text_or_numbers  #
  ##########################

  # attr_text_or_numbers :name, ... 
  # attr_text_or_numbers :name => ViewClass, ...
  # attr_text_or_numbers :name, ... { ... configuration proc ... }
  # attr_text_or_numbers :name => ViewClass, ... { ... configuration proc ... }
  # attr_text_or_numbers *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
  # An attr_text_or_number view is treated as a container for the text bound to attr_text_or_number,
  # and the bound string will be bound to :content of the view instance. 
  #
	def attr_text_or_numbers( *args, & configuration_proc )

    bindings = attr_text_or_number( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ##################################
  #  attr_required_text_or_number  #
  ##################################

  # attr_required_text_or_number :name, ... 
  # attr_required_text_or_number :name => ViewClass, ...
  # attr_required_text_or_number :name, ... { ... configuration proc ... }
  # attr_required_text_or_number :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_text_or_number *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_text_or_number( *args, & configuration_proc )
		
		bindings = attr_text_or_number( *args, & configuration_proc )

		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
    
		return bindings
		
	end

  ###################################
  #  attr_required_text_or_numbers  #
  ###################################

  # attr_required_text_or_numbers :name, ... 
  # attr_required_text_or_numbers :name => ViewClass, ...
  # attr_required_text_or_numbers :name, ... { ... configuration proc ... }
  # attr_required_text_or_numbers :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_text_or_numbers *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_text_or_numbers( *args, & configuration_proc )
		
		bindings = attr_required_text_or_number( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
    
	end

end
