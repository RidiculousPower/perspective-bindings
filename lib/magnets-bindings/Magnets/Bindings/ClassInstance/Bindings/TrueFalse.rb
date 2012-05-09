
module ::Magnets::Bindings::ClassInstance::Bindings::TrueFalse

  #####################
  #  attr_true_false  #
  #####################

  # attr_true_false :name, ... 
  # attr_true_false :name => ViewClass, ...
  # attr_true_false :name, ... { ... configuration proc ... }
  # attr_true_false :name => ViewClass, ... { ... configuration proc ... }
  # attr_true_false *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_true_false( *args, & configuration_proc )

    bindings = __create_bindings_for_args__( *args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.__true_false_permitted__ = true      
		end
		
		return bindings

	end

  ######################
  #  attr_true_falses  #
  ######################

  # attr_true_falses :name, ... 
  # attr_true_falses :name => ViewClass, ...
  # attr_true_falses :name, ... { ... configuration proc ... }
  # attr_true_falses :name => ViewClass, ... { ... configuration proc ... }
  # attr_true_falses *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_true_falses( *args, & configuration_proc )

    bindings = attr_true_false( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ##############################
  #  attr_required_true_false  #
  ##############################

  # attr_required_true_false :name, ... 
  # attr_required_true_false :name => ViewClass, ...
  # attr_required_true_false :name, ... { ... configuration proc ... }
  # attr_required_true_false :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_true_false *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_true_false( *args, & configuration_proc )
		
		bindings = attr_true_false( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
		
		return bindings
		
	end

  ###############################
  #  attr_required_true_falses  #
  ###############################

  # attr_required_true_falses :name, ... 
  # attr_required_true_falses :name => ViewClass, ...
  # attr_required_true_falses :name, ... { ... configuration proc ... }
  # attr_required_true_falses :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_true_falses *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_true_falses( *args, & configuration_proc )
		
		bindings = attr_required_true_false( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
    
	end

end
