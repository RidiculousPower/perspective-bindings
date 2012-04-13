
module ::Magnets::Bindings::ClassInstance::Bindings::Rational

  ###################
  #  attr_rational  #
  ###################

  # attr_rational :name, ... 
  # attr_rational :name => ViewClass, ...
  # attr_rational :name, ... { ... configuration proc ... }
  # attr_rational :name => ViewClass, ... { ... configuration proc ... }
  # attr_rational *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_rational( *args, & configuration_proc )

    bindings = create_bindings_for_args( args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.__rational_permitted__ = true      
		end
		
		return bindings

	end

  ####################
  #  attr_rationals  #
  ####################

  # attr_rationals :name, ... 
  # attr_rationals :name => ViewClass, ...
  # attr_rationals :name, ... { ... configuration proc ... }
  # attr_rationals :name => ViewClass, ... { ... configuration proc ... }
  # attr_rationals *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_rationals( *args, & configuration_proc )

    bindings = attr_rational( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ############################
  #  attr_required_rational  #
  ############################

  # attr_required_rational :name, ... 
  # attr_required_rational :name => ViewClass, ...
  # attr_required_rational :name, ... { ... configuration proc ... }
  # attr_required_rational :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_rational *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_rational( *args, & configuration_proc )
		
		bindings = attr_rational( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
		
		return bindings
		
	end

  #############################
  #  attr_required_rationals  #
  #############################

  # attr_required_rationals :name, ... 
  # attr_required_rationals :name => ViewClass, ...
  # attr_required_rationals :name, ... { ... configuration proc ... }
  # attr_required_rationals :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_rationals *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_rationals( *args, & configuration_proc )
		
		bindings = attr_required_rational( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
    
	end

end
