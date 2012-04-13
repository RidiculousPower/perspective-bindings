
module ::Magnets::Bindings::ClassInstance::Bindings::Integer

  ##################
  #  attr_integer  #
  ##################

  # attr_integer :name, ... 
  # attr_integer :name => ViewClass, ...
  # attr_integer :name, ... { ... configuration proc ... }
  # attr_integer :name => ViewClass, ... { ... configuration proc ... }
  # attr_integer *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_integer( *args, & configuration_proc )

    bindings = create_bindings_for_args( args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.__integer_permitted__ = true      
		end
		
		return bindings

	end

  ###################
  #  attr_integers  #
  ###################

  # attr_integers :name, ... 
  # attr_integers :name => ViewClass, ...
  # attr_integers :name, ... { ... configuration proc ... }
  # attr_integers :name => ViewClass, ... { ... configuration proc ... }
  # attr_integers *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_integers( *args, & configuration_proc )

    bindings = attr_integer( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ###########################
  #  attr_required_integer  #
  ###########################

  # attr_required_integer :name, ... 
  # attr_required_integer :name => ViewClass, ...
  # attr_required_integer :name, ... { ... configuration proc ... }
  # attr_required_integer :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_integer *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_integer( *args, & configuration_proc )
		
		bindings = attr_integer( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
		
		return bindings
		
	end

  ############################
  #  attr_required_integers  #
  ############################

  # attr_required_integers :name, ... 
  # attr_required_integers :name => ViewClass, ...
  # attr_required_integers :name, ... { ... configuration proc ... }
  # attr_required_integers :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_integers *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_integers( *args, & configuration_proc )
		
		bindings = attr_required_integer( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
    
	end

end
