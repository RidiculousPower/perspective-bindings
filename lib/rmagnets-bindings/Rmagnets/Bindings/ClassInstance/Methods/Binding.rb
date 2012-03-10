
module ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Binding

  ##################################
  #  declare_class_binding_getter  #
  ##################################

  def declare_class_binding_getter( binding_name )

  	#-------------------------------------  Class Methods  ----------------------------------------#

    #=====================#
    #  self.binding_name  #
    #=====================#

		# class method: return the binding instance
		::CascadingConfiguration::Variable.define_module_method( self, binding_name ) do

			return binding_router( binding_name )
		  
		end
		    
  end

  ############################
  #  declare_binding_setter  #
  ############################

	def declare_binding_setter( binding_name, binding_instance )

    variable_name = binding_name.variable_name
    write_accessor = binding_name.write_accessor_name
		
		#-----------------------------------  Instance Methods  ---------------------------------------#
  	
		#=================#
    #  binding_name=  #
    #=================#
    
		::CascadingConfiguration::Variable.define_instance_method( self, write_accessor ) do |object|

      binding_instance.ensure_binding_value_valid( object )
      
      return instance_variable_set( variable_name, object )

    end

	end

  ############################
  #  declare_binding_getter  #
  ############################

	def declare_binding_getter( binding_name, binding_instance )

    variable_name = binding_name.variable_name

  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #================#
    #  binding_name  #
    #================#

		# instance method: return the bound instance
		::CascadingConfiguration::Variable.define_instance_method( self, binding_name ) do
		  
      return instance_variable_get( variable_name )
		
		end
        
	end

end
