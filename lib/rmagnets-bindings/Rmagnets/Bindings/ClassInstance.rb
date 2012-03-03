
#-----------------------------------------------------------------------------------------------------------#
#-----------------------------------  Rmagnets Bindings - Class Instance  ----------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rmagnets::Bindings::ClassInstance

	BindingConfiguration = Struct.new( :view_class, :configuration_block_proc, :required )

  #######################
  #  self.attr_binding  #
  #######################

	def attr_binding( *binding_names_or_maps, & configuration_block_proc )

		@attribute_bindings	||= Hash.new

		# accept as many bindings as declared
		binding_names_or_maps.each do |binding_name_or_map|

			# :binding => view_class
			if binding_name_or_map.is_a?( Hash )

				binding_name_or_map.each do |binding_name, view_class|
					add_attribute_binding( binding_name, view_class, configuration_block_proc, false )
					declare_binding_methods( binding_name )
				end

			# :binding
			else

				binding_name = binding_name_or_map
				add_attribute_binding( binding_name, nil, configuration_block_proc, false )
				# we don't check for collisions, following the attr_accessor/reader/writer model
				declare_binding_methods( binding_name )

			end
			
		end
		
		return self

	end

  ######################
  #  self.attr_rebind  #
  ######################

	def attr_rebind( binding, rebinding_name_or_map = nil, & configuration_block_proc )
  
		@attribute_rebindings	||= Hash.new

		# if binding is a hash, we use key as binding and data as rebinding name
		# rebinding map would work in place of name as well, but requires explicit braces
		if binding.is_a?( Hash )
			binding_hash_key_data = binding.first
			binding 							= binding_hash_key_data[ 0 ]
			rebinding_name_or_map = binding_hash_key_data[ 1 ]
		end

		# if we don't have the binding we are rebinding, raise error
		raise 'No binding defined for :' + binding.to_s + '.' unless has_binding?( binding )
		
		if rebinding_name_or_map.is_a?( Hash )

			rebinding_name_or_map.each do |rebinding_name, view_class|
				# if we have a view class, use it to redefine this binding
				rebind_attribute( binding, rebinding_name, view_class, configuration_block_proc )
			end
		
		else
			
			rebinding_name = rebinding_name_or_map
			rebind_attribute( binding, rebinding_name, nil, configuration_block_proc )

		end		

		return self
		
	end
	
	#####################
  #  self.attr_alias  #
  #####################

	def attr_alias( *new_binding_aliases_to_existing_binding_names )
  
		@attribute_aliases ||= Hash.new

		until new_binding_aliases_to_existing_binding_names.empty?
			
			new_binding_alias_to_existing_binding_name = new_binding_aliases_to_existing_binding_names.shift
			
			if new_binding_alias_to_existing_binding_name.is_a?( Hash )
				
				new_binding_alias_to_existing_binding_name.each do |new_binding_alias, existing_binding_name|
					@attribute_aliases[ new_binding_alias ] = existing_binding_name
				end
				
			else
				
				new_binding_alias			= new_binding_alias_to_existing_binding_name
				existing_binding_name	= new_binding_aliases_to_existing_binding_names.shift
				@attribute_aliases[ new_binding_alias ] = existing_binding_name
				
			end
			
		end

		return self
		
	end

	#######################
  #  self.attr_binding  #
  #######################

	def attr_unbind( *binding_names )
  	
		binding_names.each do |this_binding|
			unbind_attribute( this_binding )
		end
		
		return self
		
	end

	##################################
  #  self.attr_rebind_as_required  #
  ##################################

	def attr_rebind_as_required( binding, rebinding_name_or_map )
  
		attr_rebind( binding, rebinding_name_or_map )
		
		set_attribute_required_for_binding_name_or_maps( rebinding_name_or_map )
		
		return self
	
	end

  ################################
  #  self.attr_required_binding  #
  ################################

	def attr_required_binding( *binding_names_or_maps )
		
		attr_binding( *binding_names_or_maps )

		set_attribute_required_for_binding_name_or_maps( *binding_names_or_maps )
		
		return self
		
	end
	
	#####################
  #  self.attr_order  #
  #####################

	def attr_order( *binding_order_array )

		@attribute_binding_order ||= Array.new

		if binding_order_array.empty?
		
			return @attribute_binding_order
		
		else

	  	binding_order_array.each do |this_binding|
				@attribute_binding_order.push( this_binding )
			end

		end
		
		return self

	end

  ###################
  #  self.bindings  #
  ###################

	def bindings

		# look up ancestor chain and compile attribute bindings
		ancestors_to_object = ancestors
		ancestors_to_object = ancestors_to_object.slice( 0, ancestors_to_object.index( Object ) + 1 ).reverse
		attribute_bindings = Hash.new
		ancestors_to_object.each do |ancestor|
			# get the attribute binding - any renamed attributes have already been moved
			attribute_bindings_from_ancestor = ancestor.instance_variable_get( :@attribute_bindings )
			# but since we are merging, before we merge we need to remove any renamed attributes
			if renamed_attribute_bindings_from_ancestor = ancestor.instance_variable_get( :@attribute_rebindings )
				renamed_attribute_bindings_from_ancestor.each do |this_rebinding|
					attribute_bindings.delete( this_rebinding )
				end
			end
			attribute_bindings = attribute_bindings.merge( attribute_bindings_from_ancestor ) if attribute_bindings_from_ancestor
			attribute_bindings
		end

		return attribute_bindings

	end

  #####################
  #  self.rebindings  #
  #####################

	def rebindings
		# return this class's rebindings - rebindings from super classes are mapped as bindings in inherited classes
		return @attribute_rebindings ||= Hash.new
	end
	
  ##################
  #  has_binding?  #
  ##################

	def has_binding?( binding )
		
		has_binding = false
		
		# if we have binding
		if 	bindings.has_key?( binding ) or 
				( @attribute_rebindings ||= Hash.new ).has_key?( binding ) or 
				( @attribute_aliases ||= Hash.new ).has_key?( binding )
			has_binding = true
		end
		
		# or if we have a re-binding
		return has_binding
	end
	
  ###########################
  #  binding_is_rebinding?  #
  ###########################

	def binding_is_rebinding?( binding )

		binding_is_rebinding_name = false

		if ( @attribute_rebindings ||= Hash.new ).has_key?( binding )
			binding_is_rebinding_name = true
		end
		
		return binding_is_rebinding_name
		
	end
	
  ###########################
  #  binding_for_rebinding  #
  ###########################

	def binding_for_rebinding( binding )
		
		binding_name_for_rebinding = nil
		
		if ( @attribute_rebindings ||= Hash.new ).has_key?( binding )
			binding_name_for_rebinding = @attribute_rebindings[ binding ]
		elsif ( @attribute_aliases ||= Hash.new ).has_key?( binding )
			binding_name_for_rebinding = @attribute_aliases[ binding ]
		else
			binding_name_for_rebinding = bindings[ binding ]
		end
			
		return binding_name_for_rebinding

	end

  #######################
  #  required_bindings  #
  #######################

	def required_bindings
		return bindings.select { |this_binding, this_binding_configuration| this_binding_configuration[ :required ] }
	end
	
  ################################
  #  self.binding_configuration  #
  ################################

	def binding_configuration( binding )
		return bindings[ binding ]
	end

end
