
module ::Rmagnets::Bindings::ClassInstance::Bindings::Complex

  ##################
  #  attr_complex  #
  ##################

  # attr_complex :name, ... 
  # attr_complex :name => ViewClass, ...
  # attr_complex :name, ... { ... configuration proc ... }
  # attr_complex :name => ViewClass, ... { ... configuration proc ... }
  # attr_complex *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_complex( *args, & configuration_proc )

    bindings = create_bindings_for_args( args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.complex_permitted = true      
		end
		
		return bindings

	end

  ####################
  #  attr_complexes  #
  ####################

  # attr_complexes :name, ... 
  # attr_complexes :name => ViewClass, ...
  # attr_complexes :name, ... { ... configuration proc ... }
  # attr_complexes :name => ViewClass, ... { ... configuration proc ... }
  # attr_complexes *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_complexes( *args, & configuration_proc )

    bindings = attr_complex( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.multiple_values_permitted = true
	  end
		
		return bindings

	end

  ###########################
  #  attr_required_complex  #
  ###########################

  # attr_required_complex :name, ... 
  # attr_required_complex :name => ViewClass, ...
  # attr_required_complex :name, ... { ... configuration proc ... }
  # attr_required_complex :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_complex *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_complex( *args, & configuration_proc )
		
		bindings = attr_complex( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.required = true
	  end
		
		return bindings
		
	end

  #############################
  #  attr_required_complexes  #
  #############################

  # attr_required_complexes :name, ... 
  # attr_required_complexes :name => ViewClass, ...
  # attr_required_complexes :name, ... { ... configuration proc ... }
  # attr_required_complexes :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_complexes *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_complexes( *args, & configuration_proc )
				
    bindings = attr_required_complex( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.multiple_values_permitted = true
	  end
		
		return bindings
				
	end

end
