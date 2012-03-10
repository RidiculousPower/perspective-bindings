
module ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias

  ##########################################
  #  declare_aliased_class_binding_getter  #
  ##########################################

  def declare_aliased_class_binding_getter( binding_alias, binding_name )
    
  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #================#
    #  binding_name  #
    #================#

		# instance method: return the bound instance
		::CascadingConfiguration::Variable.define_module_method( self, binding_alias ) do
		  
      return __send__( binding_name )
		
		end
    
  end

	####################################
  #  declare_aliased_binding_setter  #
  ####################################

	def declare_aliased_binding_setter( binding_alias, binding_name )

    write_accessor = binding_alias.write_accessor_name
    aliased_write_accessor = binding_name.write_accessor_name

		#-----------------------------------  Instance Methods  ---------------------------------------#
  	
		#=================#
    #  binding_name=  #
    #=================#
    
		::CascadingConfiguration::Variable.define_instance_method( self, write_accessor ) do |object|
      
      __send__( aliased_write_accessor, object )
      
    end

	end

	####################################
  #  declare_aliased_binding_getter  #
  ####################################

	def declare_aliased_binding_getter( binding_alias, binding_name )

  	#-----------------------------------  Instance Methods  ---------------------------------------#

    #================#
    #  binding_name  #
    #================#

		# instance method: return the bound instance
		::CascadingConfiguration::Variable.define_instance_method( self, binding_alias ) do
      
      __send__( binding_name )
		
		end

	end

end
