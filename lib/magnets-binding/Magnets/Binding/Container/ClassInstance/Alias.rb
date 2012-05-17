
module ::Magnets::Binding::Container::ClassInstance::Alias

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

          __create_binding_alias__( new_binding_alias, existing_name )
          
				end
				
			else
				
				new_binding_alias	= new_binding_alias_to_existing_binding_name
				existing_name    	= new_binding_aliases.shift

        __create_binding_alias__( new_binding_alias, existing_name )
				
			end
			
		end

		return self
		
	end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	##############################
  #  __create_binding_alias__  #
  ##############################
	
	def __create_binding_alias__( binding_alias, existing_binding_or_name )

    case existing_binding_or_name
      
      when ::Symbol, String
      
    	  unless has_binding?( existing_binding_or_name )
      		raise ::Magnets::Binding::Exception::NoBindingError,
      		      'No binding defined for :' + existing_binding_or_name.to_s + '.'
        end
        
        __create_name_alias__( binding_alias, existing_binding_or_name )
                
      else

        __create_shared_binding_alias__( binding_alias, existing_binding_or_name )
        
    end
    
  end
  
  ###########################
  #  __create_name_alias__  #
  ###########################
	
  def __create_name_alias__( binding_alias, existing_binding_or_name )
    
    __binding_aliases__[ binding_alias ] = existing_binding_or_name
    
    declare_aliased_class_binding_getter( binding_alias, existing_binding_or_name )
		declare_aliased_binding_setter( binding_alias, existing_binding_or_name )
		declare_aliased_binding_getter( binding_alias, existing_binding_or_name )

    binding_instance = __binding_configuration__( existing_binding_or_name )
		
  end

	#####################################
  #  __create_shared_binding_alias__  #
  #####################################
  
  def __create_shared_binding_alias__( binding_alias, existing_binding_or_name )

    shared_binding_instance = existing_binding_or_name
    __shared_bindings__[ binding_alias ] = shared_binding_instance

    declare_class_shared_binding_getter( binding_alias )
		declare_shared_binding_setter( binding_alias, shared_binding_instance )
		declare_shared_binding_getter( binding_alias, shared_binding_instance )

  end
  
end
