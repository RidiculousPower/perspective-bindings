
module ::Rmagnets::Bindings::ClassInstance::Rename

	#########################################  Renaming  #############################################

	#################
  #  attr_rename  #
  #################

  def attr_rename( existing_name, new_name )

    unless has_binding?( existing_name )
  		raise ::Rmagnets::Bindings::Exception::NoBindingError,
  		      'No binding defined for :' + existing_name.to_s + '.'
    end
	  
    if existing_alias_for_existing_name = binding_aliases.delete( existing_name )
      
      remove_binding_methods( existing_name )
      binding_aliases.each do |key, value|
        if value == existing_name
          binding_aliases[ key ] = new_name
        end
      end
      create_binding_alias( new_name, existing_alias_for_existing_name )
      
    else
    
      existing_binding_instance = binding_configurations.delete( existing_name )

      remove_binding_methods( existing_name )
      
      create_corresponding_view = false
      
      if corresponding_binding_name = existing_binding_instance.__corresponding_view_binding__

        existing_corresponding_instance = binding_configurations[ corresponding_binding_name ]

        attr_unbind( corresponding_binding_name )
        
        create_corresponding_view = true
        
      end

      create_binding_from_binding_instance( new_name, 
                                            existing_binding_instance, 
                                            create_corresponding_view )
      
    end
            
  end

end
