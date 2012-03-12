
module ::Rmagnets::Bindings::ClassInstance::Bindings::Class

  ################
  #  attr_class  #
  ################

  # attr_class :name, ... 
  # attr_class :name => ViewClass, ...
  # attr_class :name, ... { ... configuration proc ... }
  # attr_class :name => ViewClass, ... { ... configuration proc ... }
  # attr_class *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_class( *args, & configuration_proc )

    bindings = create_bindings_for_args( args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.class_permitted = true      
		end
		
		return bindings

	end

  ##################
  #  attr_classes  #
  ##################

  # attr_classes :name, ... 
  # attr_classes :name => ViewClass, ...
  # attr_classes :name, ... { ... configuration proc ... }
  # attr_classes :name => ViewClass, ... { ... configuration proc ... }
  # attr_classes *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_classes( *args, & configuration_proc )

    bindings = attr_class( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.multiple_values_permitted = true
	  end
		
		return bindings

	end

  #########################
  #  attr_required_class  #
  #########################

  # attr_required_class :name, ... 
  # attr_required_class :name => ViewClass, ...
  # attr_required_class :name, ... { ... configuration proc ... }
  # attr_required_class :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_class *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_class( *args, & configuration_proc )
		
		bindings = attr_class( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.required = true
	  end
		
		return bindings
		
	end

  ###########################
  #  attr_required_classes  #
  ###########################

  # attr_required_classes :name, ... 
  # attr_required_classes :name => ViewClass, ...
  # attr_required_classes :name, ... { ... configuration proc ... }
  # attr_required_classes :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_classes *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_classes( *args, & configuration_proc )
		
    bindings = attr_required_class( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.multiple_values_permitted = true
	  end
		
		return bindings
		
	end

end