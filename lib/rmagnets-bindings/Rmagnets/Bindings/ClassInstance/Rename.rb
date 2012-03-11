
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
      
    elsif shared_binding_router = shared_binding_routers.delete( existing_name )
      
      remove_binding_methods( existing_name )
      shared_binding_routers[ new_name ] = new_name
      create_binding_alias( new_name, shared_binding_router )
      
    else
    
      binding_instance = binding_configurations.delete( existing_name )
      binding_instance.__binding_name__ = new_name
      binding_routers.delete( existing_name )
      remove_binding_methods( existing_name )
      create_binding_from_configuration( new_name, binding_instance )
      
    end
            
  end

end
