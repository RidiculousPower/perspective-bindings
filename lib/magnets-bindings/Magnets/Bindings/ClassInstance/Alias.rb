
module ::Magnets::Bindings::ClassInstance::Alias

	##########################################  Aliases  #############################################

	################
  #  attr_alias  #
  ################

  # attr_alias :name, :other_name
  # attr_alias :name => :other_name
  # attr_alias :name, { :binding => :name_in_binding }
  # attr_alias :name => { :binding => :name_in_binding }
  #
	def attr_alias( *new_binding_aliases )
  
		until new_binding_aliases.empty?
			
			new_binding_alias_to_existing_binding_name = new_binding_aliases.shift
			
			if new_binding_alias_to_existing_binding_name.is_a?( Hash )
				
				new_binding_alias_to_existing_binding_name.each do |new_binding_alias, existing_name|

          create_binding_alias( new_binding_alias, existing_name )
          
				end
				
			else
				
				new_binding_alias	= new_binding_alias_to_existing_binding_name
				existing_name    	= new_binding_aliases.shift

        create_binding_alias( new_binding_alias, existing_name )
				
			end
			
		end

		return self
		
	end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	##########################
  #  create_binding_alias  #
  ##########################
	
	def create_binding_alias( binding_alias, existing_binding_or_name )

    case existing_binding_or_name
      
      when ::Symbol, String
      
    	  unless has_binding?( existing_binding_or_name )
      		raise ::Magnets::Bindings::Exception::NoBindingError,
      		      'No binding defined for :' + existing_binding_or_name.to_s + '.'
        end
        
    		__binding_aliases__[ binding_alias ] = existing_binding_or_name
        
        declare_aliased_class_binding_getter( binding_alias, existing_binding_or_name )
    		declare_aliased_binding_setter( binding_alias, existing_binding_or_name )
    		declare_aliased_binding_getter( binding_alias, existing_binding_or_name )

        binding_instance = __binding_configuration__( existing_binding_or_name )

        if corresponding_view_binding = binding_instance.__corresponding_view_binding__
          corresponding_alias_name = ( binding_alias.to_s + '_view' ).to_sym
          create_binding_alias( corresponding_alias_name, corresponding_view_binding.__name__ )
        end
                
      else

        shared_binding_instance = existing_binding_or_name
        __shared_bindings__[ binding_alias ] = shared_binding_instance

        declare_class_shared_binding_getter( binding_alias )
    		declare_shared_binding_setter( binding_alias, shared_binding_instance )
    		declare_shared_binding_getter( binding_alias, shared_binding_instance )

        if corresponding_view_binding = shared_binding_instance.__corresponding_view_binding__
          corresponding_alias_name = ( binding_alias.to_s + '_view' ).to_sym
          create_binding_alias( corresponding_alias_name, corresponding_view_binding.__name__ )
        end
        
    end
    
  end
  
end
