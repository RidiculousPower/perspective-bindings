
module ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding

  #########################################
  #  declare_class_shared_binding_getter  #
  #########################################

  def declare_class_shared_binding_getter( shared_alias_name )
    
    declare_class_binding_getter( shared_alias_name )
    
  end

	###################################
  #  declare_shared_binding_setter  #
  ###################################

	def declare_shared_binding_setter( shared_alias_name, shared_binding_router )

		binding_route = shared_binding_router.__binding_route__
    binding_name = shared_binding_router.__binding_name__

    # our write accessor
		write_accessor = shared_alias_name.write_accessor_name
		# the write accessor our shared write accessor calls
    shared_alias_write_accessor = binding_name.write_accessor_name

		#-----------------------------------  Instance Methods  ---------------------------------------#
  	
		#======================#
    #  shared_alias_name=  #
    #======================#
    
		::CascadingConfiguration::Variable.define_instance_method( self, write_accessor ) do |object|
      
      instance_binding = self
            
      binding_route.each_with_index do |this_binding_route_part, index|

        unless instance_binding.respond_to?( this_binding_route_part )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
        		      'Shared binding :' + shared_alias_name.to_s + ' was inaccessible in ' + 
          	      instance_binding.to_s + '. No binding :' + shared_alias_name.to_s + ' defined ' +
        		      'in ' + ( [ instance_binding.to_s ] + 
        		      binding_route.slice( 0, index ) ).join( '.' ) + '.'
        end
        
        instance_binding = instance_binding.__send__( this_binding_route_part )
      
      end

      unless instance_binding.respond_to?( binding_name )
    		raise ::Rmagnets::Bindings::Exception::NoBindingError,
        	      'Shared binding :' + shared_alias_name.to_s + ' was inaccessible in ' + 
        	      self.to_s + '. No binding :' + shared_alias_name.to_s + 
        	      ' defined ' + 'in ' + ( [ instance_binding.inspect ] + binding_route ).join( '.' ) + '.'
      end
      
      instance_binding.__send__( shared_alias_write_accessor, object )
      
    end

	end
	
	###################################
  #  declare_shared_binding_getter  #
  ###################################

	def declare_shared_binding_getter( shared_alias_name, shared_binding_router )

		binding_route = shared_binding_router.__binding_route__
    binding_name = shared_binding_router.__binding_name__

  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #=====================#
    #  shared_alias_name  #
    #=====================#

		# instance method: return the bound instance
		::CascadingConfiguration::Variable.define_instance_method( self, shared_alias_name ) do
		  
      instance_binding = self
      
      binding_route.each_with_index do |this_binding_route_part, index|

        unless instance_binding.respond_to?( this_binding_route_part )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
        		      'Shared binding :' + shared_alias_name.to_s + ' was inaccessible in ' + 
          	      self.to_s + '. No binding :' + shared_alias_name.to_s + ' defined ' +
        		      'in ' + ( [ instance_binding.to_s ] + 
        		      binding_route.slice( 0, index ) ).join( '.' ) + '.'
        end

        instance_binding = instance_binding.__send__( this_binding_route_part )

      end

      unless instance_binding.respond_to?( binding_name )
    		raise ::Rmagnets::Bindings::Exception::NoBindingError,
        	      'Shared binding :' + shared_alias_name.to_s + ' was inaccessible in ' + 
        	      instance_binding.to_s + '. No binding :' + shared_alias_name.to_s + 
        	      ' defined ' + 'in ' + ( [ instance_binding.inspect ] + binding_route ).join( '.' ) + '.'
      end

      instance_binding.__send__( binding_name )
		
		end

	end

end
