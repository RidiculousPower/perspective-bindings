
module ::Magnets::Bindings::ClassInstance::Bindings::Methods::Binding

  ##################################
  #  declare_class_binding_getter  #
  ##################################

  def declare_class_binding_getter( binding_name )

  	#-------------------------------------  Class Methods  ----------------------------------------#

    #=====================#
    #  self.binding_name  #
    #=====================#

		# class method: return the binding instance
		::CascadingConfiguration::Methods.define_module_method( self, binding_name ) do

			return __binding_configurations__[ binding_name ]
		  
		end
		    
  end

  ############################
  #  declare_binding_setter  #
  ############################

	def declare_binding_setter( binding_name )

    write_accessor = binding_name.write_accessor_name
		
		#-----------------------------------  Instance Methods  ---------------------------------------#
  	
		#=================#
    #  binding_name=  #
    #=================#
    
		::CascadingConfiguration::Methods.define_instance_method( self, write_accessor ) do |object|

      __set_binding__( binding_name, object )
      
    end

	end

  ############################
  #  declare_binding_getter  #
  ############################

	def declare_binding_getter( binding_name )

    variable_name = binding_name.variable_name

  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #================#
    #  binding_name  #
    #================#

		# instance method: return the bound instance
		::CascadingConfiguration::Methods.define_instance_method( self, binding_name ) do
		  
      return __binding__( binding_name )
		
		end
        
	end

end
