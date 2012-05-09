
module ::Magnets::Bindings::ClassInstance::Order

	##########################################  Order  ###############################################
	
	################
  #  attr_order  #
  ################

	def attr_order( *binding_order_array )

    return_value = self

		if binding_order_array.empty?         or 
		   ( binding_order_array.count == 1            and 
		     binding_order_array[ 0 ].is_a?( ::Array ) and
		     binding_order_array[ 0 ].empty? )
		
      self.__binding_order_declared_empty__ = true
		
		else

      self.__binding_order_declared_empty__ = false

	  	binding_order_array.each do |this_binding_name|
	  	  
	  	  validate_binding_name_for_order( this_binding_name )
	  	  
			end

			__binding_order__.replace( binding_order_array )
			
		end
		
		return return_value

	end
	
	#####################################
  #  validate_binding_name_for_order  #
	#####################################
	
	def validate_binding_name_for_order( binding_name )
	  
	  unless has_binding?( binding_name )
  		raise ::Magnets::Bindings::Exception::NoBindingError,
  		      'No binding defined for :' + binding_name.to_s + '.'
    end
	  
  end

end
