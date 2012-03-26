
module ::Rmagnets::Bindings::ClassInstance::Bindings::Module

  #################
  #  attr_module  #
  #################

  # attr_module :name, ... 
  # attr_module :name => ViewClass, ...
  # attr_module :name, ... { ... configuration proc ... }
  # attr_module :name => ViewClass, ... { ... configuration proc ... }
  # attr_module *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_module( *args, & configuration_proc )

    bindings = create_bindings_for_args( args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.__module_permitted__ = true      
		end
		
		return bindings

	end

  ##################
  #  attr_modules  #
  ##################

  # attr_modules :name, ... 
  # attr_modules :name => ViewClass, ...
  # attr_modules :name, ... { ... configuration proc ... }
  # attr_modules :name => ViewClass, ... { ... configuration proc ... }
  # attr_modules *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_modules( *args, & configuration_proc )

    bindings = attr_module( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ##########################
  #  attr_required_module  #
  ##########################

  # attr_required_module :name, ... 
  # attr_required_module :name => ViewClass, ...
  # attr_required_module :name, ... { ... configuration proc ... }
  # attr_required_module :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_module *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_module( *args, & configuration_proc )
		
		bindings = attr_module( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
		
		return bindings
		
	end

  ###########################
  #  attr_required_modules  #
  ###########################

  # attr_required_modules :name, ... 
  # attr_required_modules :name => ViewClass, ...
  # attr_required_modules :name, ... { ... configuration proc ... }
  # attr_required_modules :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_modules *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_modules( *args, & configuration_proc )

    bindings = attr_required_module( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
		
	end

end
