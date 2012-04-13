
module ::Magnets::Bindings::ClassInstance::Bindings::Methods::SharedBinding

  #########################################
  #  declare_class_shared_binding_getter  #
  #########################################

  def declare_class_shared_binding_getter( shared_alias_name )
    
  	#-------------------------------------  Class Methods  ----------------------------------------#

    #=====================#
    #  self.binding_name  #
    #=====================#

		# class method: return the binding instance
		::CascadingConfiguration::Methods.define_module_method( self, shared_alias_name ) do

			return __shared_binding_configurations__[ shared_alias_name ]
		  
		end
    
  end

	###################################
  #  declare_shared_binding_setter  #
  ###################################

	def declare_shared_binding_setter( shared_alias_name, shared_binding_instance )

		binding_route = shared_binding_instance.__route__
    binding_name = shared_binding_instance.__name__

    # our write accessor
		write_accessor = shared_alias_name.write_accessor_name
		# the write accessor that our shared write accessor calls
    shared_alias_write_accessor = binding_name.write_accessor_name

		#-----------------------------------  Instance Methods  ---------------------------------------#
  	
		#======================#
    #  shared_alias_name=  #
    #======================#
    
		::CascadingConfiguration::Methods.define_instance_method( self, write_accessor ) do |object|
      
      binding_class = ::Magnets::Bindings::Binding
      binding_context = binding_class.shared_binding_context( shared_alias_name,
                                                              self, 
                                                              binding_route,
                                                              shared_alias_write_accessor )
      
      return binding_context.__set_binding__( binding_name, object )
      
    end

	end
	
	###################################
  #  declare_shared_binding_getter  #
  ###################################

	def declare_shared_binding_getter( shared_alias_name, shared_binding_instance )

		binding_route = shared_binding_instance.__route__
    binding_name = shared_binding_instance.__name__

  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #=====================#
    #  shared_alias_name  #
    #=====================#

		# instance method: return the bound instance
		::CascadingConfiguration::Methods.define_instance_method( self, shared_alias_name ) do
      
      binding_class = ::Magnets::Bindings::Binding
      binding_context = binding_class.shared_binding_context( shared_alias_name,
                                                              self, 
                                                              binding_route,
                                                              binding_name )

      return binding_context.__binding__( binding_name )
		
		end

	end

end
