
module ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Remove

	############################
	#  remove_binding_methods  #
	############################
	
	def remove_binding_methods( binding_name )

    write_accessor = binding_name.write_accessor_name
    
    unless ::CascadingConfiguration::Variable.undef_module_method( self, binding_name )
      eigenclass = class << self ; self ; end
      eigenclass.instance_eval do
        undef_method( binding_name )
      end
    end
    
    unless ::CascadingConfiguration::Variable.undef_instance_method( self, binding_name )
      undef_method( binding_name )
    end

    unless ::CascadingConfiguration::Variable.undef_instance_method( self, write_accessor )
      undef_method( write_accessor )
    end

  end

end
