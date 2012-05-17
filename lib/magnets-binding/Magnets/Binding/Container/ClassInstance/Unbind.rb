
module ::Magnets::Binding::Container::ClassInstance::Unbind

	#################
  #  attr_unbind  #
  #################

  # attr_unbind :name, ...
  # 
	def attr_unbind( *binding_names )
  	
		binding_names.each do |this_binding_name|

      if has_binding?( this_binding_name )

    		# delete this alias if it is one
    		if aliased_binding = __binding_aliases__.delete( this_binding_name )
  		  
    		  # we don't automatically delete associated bindings
    		  # nothing else to do
        
        elsif binding_instance = __shared_bindings__.delete( this_binding_name )
          
          # nothing else to do here
          
        else

      		binding_instance = __bindings__.delete( this_binding_name )
        
        end
      
    		# delete any aliases for this one
        __binding_aliases__.delete_if { |key, value| value == this_binding_name }

        remove_binding_methods( this_binding_name )

        # now tell each child to remove the binding
        ::CascadingConfiguration::Ancestors.children( self ).each do |this_child_bindings_module|
          this_child_bindings_module.attr_unbind( this_binding_name )
        end

      end
      
		end
		
		return self
		
	end

end
