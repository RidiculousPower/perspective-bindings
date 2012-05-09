
module ::Magnets::Bindings::ClassInstance::Bindings::File

  ###############
  #  attr_file  #
  ###############

  # attr_file :name, ... 
  # attr_file :name => ViewClass, ...
  # attr_file :name, ... { ... configuration proc ... }
  # attr_file :name => ViewClass, ... { ... configuration proc ... }
  # attr_file *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_file( *args, & configuration_proc )

    bindings = __create_bindings_for_args__( *args, & configuration_proc )

    bindings.each do |this_binding|
      this_binding.__file_permitted__ = true      
		end
		
		return bindings

	end

  ################
  #  attr_files  #
  ################

  # attr_files :name, ... 
  # attr_files :name => ViewClass, ...
  # attr_files :name, ... { ... configuration proc ... }
  # attr_files :name => ViewClass, ... { ... configuration proc ... }
  # attr_files *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_files( *args, & configuration_proc )

    bindings = attr_file( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings

	end

  ########################
  #  attr_required_file  #
  ########################

  # attr_required_file :name, ... 
  # attr_required_file :name => ViewClass, ...
  # attr_required_file :name, ... { ... configuration proc ... }
  # attr_required_file :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_file *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_file( *args, & configuration_proc )
		
		bindings = attr_file( *args, & configuration_proc )
				
		bindings.each do |this_binding|
		  this_binding.__required__ = true
	  end
		
		return bindings
		
	end

  #########################
  #  attr_required_files  #
  #########################

  # attr_required_files :name, ... 
  # attr_required_files :name => ViewClass, ...
  # attr_required_files :name, ... { ... configuration proc ... }
  # attr_required_files :name => ViewClass, ... { ... configuration proc ... }
  # attr_required_files *binding_names, ViewClass, ... { ... configuration proc ... }
  # 
	def attr_required_files( *args, & configuration_proc )
		
		bindings = attr_required_file( *args, & configuration_proc )
		
		bindings.each do |this_binding|
		  this_binding.__multiple_values_permitted__ = true
	  end
		
		return bindings
    
	end
	
end
