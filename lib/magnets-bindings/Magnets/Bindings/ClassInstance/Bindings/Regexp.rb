
module ::Magnets::Bindings::ClassInstance::Bindings::Regexp

  #################
  #  attr_regexp  #
  #################

  # attr_regexp :name, ... 
  # attr_regexp :name => ViewClass, ...
  # attr_regexp :name, ... { ... configuration proc ... }
  # attr_regexp :name => ViewClass, ... { ... configuration proc ... }
  # attr_regexp *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_regexp( *args, & configuration_proc )

    bindings = __create_bindings_for_args__( *args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.__regexp_permitted__ = true      
		end
		
		return bindings

	end

  ##################
  #  attr_regexps  #
  ##################

  # attr_regexps :name, ... 
  # attr_regexps :name => ViewClass, ...
  # attr_regexps :name, ... { ... configuration proc ... }
  # attr_regexps :name => ViewClass, ... { ... configuration proc ... }
  # attr_regexps *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_regexps( *args, & configuration_proc )

    bindings = attr_regexp( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ##########################
  #  attr_required_regexp  #
  ##########################

  # attr_required_regexp :name, ... 
  # attr_required_regexp :name => ViewClass, ...
  # attr_required_regexp :name, ... { ... configuration proc ... }
  # attr_required_regexp :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_regexp *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_regexp( *args, & configuration_proc )
		
		bindings = attr_regexp( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
		
		return bindings
		
	end

  ###########################
  #  attr_required_regexps  #
  ###########################

  # attr_required_regexps :name, ... 
  # attr_required_regexps :name => ViewClass, ...
  # attr_required_regexps :name, ... { ... configuration proc ... }
  # attr_required_regexps :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_regexps *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_regexps( *args, & configuration_proc )
	
	  bindings = attr_required_regexp( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
  	
	end

end
