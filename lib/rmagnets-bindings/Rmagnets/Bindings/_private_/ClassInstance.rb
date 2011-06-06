
#-----------------------------------------------------------------------------------------------------------#
#-----------------------------------  Rmagnets Bindings - Class Instance  ----------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::Bindings::ClassInstance

  ################################
  #  self.add_attribute_binding  #
  ################################

	def add_attribute_binding( binding_name, view_class, configuration_block_proc, required )

		raise 'Binding already defined for :' + binding_name.to_s + '; use attr_rebind to redefine.' if has_binding?( binding )

		@attribute_bindings[ binding_name ] = BindingConfiguration.new( view_class, configuration_block_proc, required )

		return self

	end

  ##################################
  #  self.declare_binding_methods  #
  ##################################

	def declare_binding_methods( binding_name )
		
		declare_binding_setter( binding_name )
		declare_binding_getter( binding_name )
		
	end
	
  #################################
  #  self.declare_binding_setter  #
  #################################

	def declare_binding_setter( binding_name )

		define_method( ( binding_name.to_s + '=' ).to_sym ) do |binding|
			bind( binding_name => binding )
		end

	end

  #################################
  #  self.declare_binding_getter  #
  #################################

	def declare_binding_getter( binding_name )

		define_method( binding_name ) do |binding|
			if binding
				bind( binding_name => binding )
				return_object = self
			else
				return_object = binding( binding_name )
			end
			return return_object
		end

	end
	
  ###########################
  #  self.rebind_attribute  #
  ###########################

	def rebind_attribute( binding_name, rebinding_name, view_class, configuration_block_proc )

		# get the existing binding
		existing_configuration = bindings[ binding_name ]
		
		( @attribute_bindings ||= Hash.new )[ rebinding_name ] = existing_configuration
		
		if view_class
			existing_configuration[ :view_class ] = view_class
		end
		
		if configuration_block_proc
			existing_configuration[ :configuration_block_proc ] = configuration_block_proc
		end
		
		# mark the binding as rebound - rebound bindings will be re-routed for superclass calls
		@attribute_rebindings[ binding_name ] = rebinding_name

		return self
		
	end

  ###########################
  #  self.unbind_attribute  #
  ###########################

	def unbind_attribute( binding_name )

		@attribute_bindings.delete( binding_name )
		@attribute_rebindings.delete_if { |key, data| data == binding_name }
		@attribute_aliases.delete_if { |key, data| data == binding_name }
		
		return self
		
	end
	
  #################################
  #  self.set_attribute_required  #
  #################################

	def set_attribute_required( binding_name, true_or_false )
		@attribute_bindings[ binding_name ][ :required ] = true_or_false
	end

  ##########################################################
  #  self.set_attribute_required_for_binding_name_or_maps  #
  ##########################################################
	
	def set_attribute_required_for_binding_name_or_maps( *binding_names_or_maps )
		
		binding_names_or_maps.each do |binding_name_or_map|
		
			if binding_name_or_map.is_a?( Hash )

				binding_name_or_map.each do |binding_name, view_class|
					set_attribute_required( binding_name, true )
				end
		
			else
			
				binding_name = binding_name_or_map
				set_attribute_required( binding_name, true )
			
			end

		end
		
	end

end
