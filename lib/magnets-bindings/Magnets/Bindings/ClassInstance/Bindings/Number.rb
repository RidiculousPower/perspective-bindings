
module ::Magnets::Bindings::ClassInstance::Bindings::Number

  #################
  #  attr_number  #
  #################

  # attr_number :name, ... 
  # attr_number :name => ViewClass, ...
  # attr_number :name, ... { ... configuration proc ... }
  # attr_number :name => ViewClass, ... { ... configuration proc ... }
  # attr_number *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_number( *args, & configuration_proc )

    bindings = create_bindings_for_args( args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.__number_permitted__ = true      
		end
		
		return bindings

	end

  ##################
  #  attr_numbers  #
  ##################

  # attr_numbers :name, ... 
  # attr_numbers :name => ViewClass, ...
  # attr_numbers :name, ... { ... configuration proc ... }
  # attr_numbers :name => ViewClass, ... { ... configuration proc ... }
  # attr_numbers *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_numbers( *args, & configuration_proc )

    bindings = attr_number( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ##########################
  #  attr_required_number  #
  ##########################

  # attr_required_number :name, ... 
  # attr_required_number :name => ViewClass, ...
  # attr_required_number :name, ... { ... configuration proc ... }
  # attr_required_number :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_number *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_number( *args, & configuration_proc )
		
		bindings = attr_number( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
		
		return bindings
		
	end

  ###########################
  #  attr_required_numbers  #
  ###########################

  # attr_required_numbers :name, ... 
  # attr_required_numbers :name => ViewClass, ...
  # attr_required_numbers :name, ... { ... configuration proc ... }
  # attr_required_numbers :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_numbers *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_numbers( *args, & configuration_proc )
		
    bindings = attr_required_number( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
		
	end

end
