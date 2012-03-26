
module ::Rmagnets::Bindings::ClassInstance::Order

	##########################################  Order  ###############################################
	
	################
  #  attr_order  #
  ################

	def attr_order( *binding_order_array )

    return_value = self

		if binding_order_array.empty? or 
		   ( binding_order_array.count == 1 and binding_order_array[ 0 ].empty? )
		
      self.__binding_order_declared_empty__ = true
		
		else

      self.__binding_order_declared_empty__ = false

	  	binding_order_array.each do |this_binding_name|
	  	  
	  	  unless has_binding?( this_binding_name )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
      		      'No binding defined for :' + this_binding_name.to_s + '.'
  	    end
	  	  
			end

			binding_order.replace( binding_order_array )
			
		end
		
		return return_value

	end

end
