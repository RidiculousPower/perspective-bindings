
module ::Rmagnets::Bindings::ClassInstance::Bindings::View

  ###############
  #  attr_view  #
  ###############

  # attr_view :name, ... 
  # attr_view :name => ViewClass, ...
  # attr_view :name, ... { ... configuration proc ... }
  # attr_view :name => ViewClass, ... { ... configuration proc ... }
  # attr_view *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_view( *args, & configuration_proc )

    bindings = attr_text( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.view_permitted = true
	  end
		
		return bindings

	end

  ################
  #  attr_views  #
  ################

  # attr_views :name, ... 
  # attr_views :name => ViewClass, ...
  # attr_views :name, ... { ... configuration proc ... }
  # attr_views :name => ViewClass, ... { ... configuration proc ... }
  # attr_views *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_views( *args, & configuration_proc )

    bindings = attr_view( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.multiple_values_permitted = true
	  end
		
		return bindings

	end

  ########################
  #  attr_required_view  #
  ########################

  # attr_required_view :name, ... 
  # attr_required_view :name => ViewClass, ...
  # attr_required_view :name, ... { ... configuration proc ... }
  # attr_required_view :name => ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_view( *args, & configuration_proc )
		
		bindings = attr_view( *args, & configuration_proc )

		bindings.each do |this_binding|
		  this_binding.required = true
	  end
		
		return bindings
		
	end

  #########################
  #  attr_required_views  #
  #########################

  # attr_required_views :name, ... 
  # attr_required_views :name => ViewClass, ...
  # attr_required_views :name, ... { ... configuration proc ... }
  # attr_required_views :name => ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_views( *args, & configuration_proc )
		
		bindings = attr_required_view( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.multiple_values_permitted = true
	  end
		
		return bindings
    
	end

end
