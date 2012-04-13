
module ::Magnets::Bindings::ClassInstance::Bindings::Binding

  ##################
  #  attr_binding  #
  ##################

  # attr_binding :name, ... 
  # attr_binding :name => ViewClass, ...
  # attr_binding :name, ... { ... configuration proc ... }
  # attr_binding :name => ViewClass, ... { ... configuration proc ... }
  # attr_binding *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_binding( *args, & configuration_proc )

    bindings = create_bindings_for_args( args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__object_permitted__ = true
	  end
		
		return bindings

	end

  ###################
  #  attr_bindings  #
  ###################

  # attr_bindings :name, ... 
  # attr_bindings :name => ViewClass, ...
  # attr_bindings :name, ... { ... configuration proc ... }
  # attr_bindings :name => ViewClass, ... { ... configuration proc ... }
  # attr_bindings *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_bindings( *args, & configuration_proc )

    bindings = attr_binding( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ###########################
  #  attr_required_binding  #
  ###########################

  # attr_required_binding :name, ... 
  # attr_required_binding :name => ViewClass, ...
  # attr_required_binding :name, ... { ... configuration proc ... }
  # attr_required_binding :name => ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_binding( *args, & configuration_proc )
		
		bindings = attr_binding( *args, & configuration_proc )

		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
		
		return bindings
		
	end

  ############################
  #  attr_required_bindings  #
  ############################

  # attr_required_bindings :name, ... 
  # attr_required_bindings :name => ViewClass, ...
  # attr_required_bindings :name, ... { ... configuration proc ... }
  # attr_required_bindings :name => ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_bindings( *args, & configuration_proc )
		
    bindings = attr_required_binding( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
		
	end

end
