
module ::Rmagnets::Bindings::ClassInstance::Bindings::Float

  ################
  #  attr_float  #
  ################

  # attr_float :name, ... 
  # attr_float :name => ViewClass, ...
  # attr_float :name, ... { ... configuration proc ... }
  # attr_float :name => ViewClass, ... { ... configuration proc ... }
  # attr_float *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_float( *args, & configuration_proc )

    bindings = create_bindings_for_args( args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.float_permitted = true      
		end
		
		return bindings

	end

  #################
  #  attr_floats  #
  #################

  # attr_floats :name, ... 
  # attr_floats :name => ViewClass, ...
  # attr_floats :name, ... { ... configuration proc ... }
  # attr_floats :name => ViewClass, ... { ... configuration proc ... }
  # attr_floats *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_floats( *args, & configuration_proc )

    bindings = attr_float( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.multiple_values_permitted = true
	  end
		
		return bindings

	end

  #########################
  #  attr_required_float  #
  #########################

  # attr_required_float :name, ... 
  # attr_required_float :name => ViewClass, ...
  # attr_required_float :name, ... { ... configuration proc ... }
  # attr_required_float :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_float *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_float( *args, & configuration_proc )
		
		bindings = attr_float( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.required = true
	  end
		
		return bindings
		
	end

  ##########################
  #  attr_required_floats  #
  ##########################

  # attr_required_floats :name, ... 
  # attr_required_floats :name => ViewClass, ...
  # attr_required_floats :name, ... { ... configuration proc ... }
  # attr_required_floats :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_floats *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_floats( *args, & configuration_proc )
		
		bindings = attr_required_float( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.multiple_values_permitted = true
	  end
		
		return bindings
    
	end

end
