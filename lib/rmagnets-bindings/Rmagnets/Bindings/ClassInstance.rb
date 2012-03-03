
module ::Rmagnets::Bindings::ClassInstance
  
	BindingConfiguration = Struct.new( :view_class, :live_configuration_proc, :required )

	#########################################  Bindings  #############################################

  ##################
  #  attr_binding  #
  ##################

	def attr_binding( *binding_names_or_maps, & live_configuration_proc )

		# accept as many bindings as declared
		binding_names_or_maps.each do |binding_name_or_map|

			# :binding => view_class
			if binding_name_or_map.is_a?( Hash )

				binding_name_or_map.each do |binding_name, view_class|
				  
					add_attribute_binding( binding_name, view_class, live_configuration_proc, false )
    			declare_binding_methods( binding_name )

				end

			# :binding
			else

				binding_name = binding_name_or_map
				add_attribute_binding( binding_name, nil, live_configuration_proc, false )
  			declare_binding_methods( binding_name )

			end
			
		end
		
		return self

	end

  ###########################
  #  attr_required_binding  #
  ###########################

	def attr_required_binding( *binding_names_or_maps )
		
		attr_binding( *binding_names_or_maps )

		set_attribute_required_for_binding_names_or_maps( true, *binding_names_or_maps )
		
		return self
		
	end

	#################
  #  attr_unbind  #
  #################

	def attr_unbind( *binding_names )
  	
		binding_names.each do |this_binding_name|

  		# delete this alias if it is one
  		if aliased_binding = binding_aliases.delete( this_binding_name )

        # if it was an alias, delete its binding
        attr_unbind( aliased_binding )

      else

    		attribute_bindings.delete( this_binding_name )
    		attribute_rebindings.delete( this_binding_name )
    		# delete any aliases for this one
        binding_aliases.delete_if { |key, value| value == this_binding_name }

      end
      
		end
		
		return self
		
	end

  ##################
  #  has_binding?  #
  ##################

	def has_binding?( binding_name )
		
		has_binding = false
		
		# if we have binding, alias, or re-binding
		if 	attribute_bindings.has_key?( binding_name )   or 
				attribute_rebindings.has_key?( binding_name ) or 
				binding_aliases.has_key?( binding_name )
		
			has_binding = true
		
		end
		
		return has_binding
		
	end

  #######################
  #  required_bindings  #
  #######################
	
	def required_bindings
	  
	  return required_bindings_hash.keys
	  
  end

  #######################
  #  binding_required?  #
  #######################
	
	def binding_required?( binding_name )
	  
	  return required_bindings_hash.has_key?( binding_name )
	  
  end
	
  ###########################
  #  binding_configuration  #
  ###########################

	def binding_configuration( binding_name )
		
		return attribute_bindings[ binding_name ]
		
	end

	##########################################  Aliases  #############################################
	
	################
  #  attr_alias  #
  ################

	def attr_alias( *new_binding_aliases )
  
		until new_binding_aliases.empty?
			
			new_binding_alias_to_existing_binding_name = new_binding_aliases.shift
			
			if new_binding_alias_to_existing_binding_name.is_a?( Hash )
				
				new_binding_alias_to_existing_binding_name.each do |new_binding_alias, existing_name|

				  unless has_binding?( existing_name )
        		raise ::Rmagnets::Bindings::Exception::NoBindingError,
        		      'No binding defined for :' + binding_name.to_s + '.'
			    end

					binding_aliases[ new_binding_alias ] = existing_name

				end
				
			else
				
				new_binding_alias	= new_binding_alias_to_existing_binding_name
				existing_name    	= new_binding_aliases.shift

			  unless has_binding?( existing_name )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
      		      'No binding defined for :' + existing_name.to_s + '.'
		    end

				binding_aliases[ new_binding_alias ] = existing_name
				
			end
			
		end

		return self
		
	end

	##########################################  Rebind  ##############################################

  #################
  #  attr_rebind  #
  #################

	def attr_rebind( binding_name, rebinding_name_or_map = nil, & live_configuration_proc )
  
		# if binding is a hash, we use key as binding and data as rebinding name
		# rebinding map would work in place of name as well, but requires explicit braces
		if binding_name.is_a?( Hash )
			binding_hash_key_data = binding_name.first
			binding_name 					= binding_hash_key_data[ 0 ]
			rebinding_name_or_map = binding_hash_key_data[ 1 ]
		end

		live_configuration_proc ||= attribute_bindings[ binding_name ].live_configuration_proc
		
		if rebinding_name_or_map.is_a?( Hash )

			rebinding_name_or_map.each do |rebinding_name, view_class|

    		unless has_binding?( binding_name )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
      		      'No binding defined for :' + binding_name.to_s + '.'
    		end

				# if we have a view class, use it to redefine this binding
				rebind_attribute( binding_name, rebinding_name, view_class, live_configuration_proc )

			end
		
		else
			
			rebinding_name = rebinding_name_or_map

  		unless has_binding?( binding_name )
    		raise ::Rmagnets::Bindings::Exception::NoBindingError,
    		      'No binding defined for :' + binding_name.to_s + '.'
  		end
			
			rebind_attribute( binding_name, 
			                  rebinding_name, 
			                  attribute_bindings[ binding_name ].view_class, 
			                  live_configuration_proc )

		end		

		return self
		
	end

	#############################
  #  attr_rebind_as_required  #
  #############################

	def attr_rebind_as_required( binding_name, rebinding_name_or_map = nil )
    
    if rebinding_name_or_map

		  attr_rebind( binding_name, rebinding_name_or_map )
  		set_attribute_required_for_binding_names_or_maps( true, rebinding_name_or_map )

    else
      
      set_attribute_required_for_binding_names_or_maps( true, binding_name )
  		
		end
		
		
		return self
	
	end

	#############################
  #  attr_rebind_as_optional  #
  #############################

	def attr_rebind_as_optional( binding_name, rebinding_name_or_map )
  
		attr_rebind( binding_name, rebinding_name_or_map )
		
		set_attribute_required_for_binding_names_or_maps( false, rebinding_name_or_map )
		
		return self
	
	end

  ###########################
  #  binding_is_rebinding?  #
  ###########################

	def binding_is_rebinding?( binding_name )

		binding_is_rebinding_name = false

		if attribute_rebindings.has_key?( binding_name )
			binding_is_rebinding_name = true
		end
		
		return binding_is_rebinding_name
		
	end

	##########################################  Order  ###############################################
	
	################
  #  attr_order  #
  ################

	def attr_order( *binding_order_array )

		if binding_order_array.empty?
		
			return binding_order
		
		else

	  	binding_order_array.each do |this_binding|
				binding_order.push( this_binding )
			end

		end
		
		return self

	end
	
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ###########################
  #  binding_for_rebinding  #
  ###########################

	def binding_for_rebinding( binding_name )
		
		binding_name_for_rebinding = nil
		
		if attribute_rebindings.has_key?( binding_name )
		  
			binding_name_for_rebinding = attribute_rebindings[ binding_name ]
	
		elsif binding_aliases.has_key?( binding_name )
	
			binding_name_for_rebinding = binding_aliases[ binding_name ]
	
		else
	
			binding_name_for_rebinding = attribute_bindings[ binding_name ]
	
		end
			
		return binding_name_for_rebinding

	end

  ###########################
  #  add_attribute_binding  #
  ###########################

	def add_attribute_binding( binding_name, view_class, live_configuration_proc, required )

    if has_binding?( binding_name )
		  raise ::Rmagnets::Bindings::Exception::BindingAlreadyDefinedError,
		        'Binding already defined for :' + binding_name.to_s + '; use attr_rebind to redefine.'
    end
    
		new_binding = BindingConfiguration.new( view_class, 
		                                        live_configuration_proc, 
		                                        required )
		
		attribute_bindings[ binding_name ] = new_binding
		
		if required
		  required_bindings_hash[ binding_name ] = true
	  end

		return self

	end

  #############################
  #  declare_binding_methods  #
  #############################

	def declare_binding_methods( binding_name )
		
		declare_binding_setter( binding_name )
		declare_binding_getter( binding_name )
		
	end
	
  ############################
  #  declare_binding_setter  #
  ############################

	def declare_binding_setter( binding_name )

    method_name = binding_name.write_accessor_name

    ::CascadingConfiguration::Variable.define_instance_method( self, method_name ) do |binding|
		  
			bind( binding_name, binding )
		
		end

	end

  ############################
  #  declare_binding_getter  #
  ############################

	def declare_binding_getter( binding_name )

    method_name = binding_name.accessor_name

		::CascadingConfiguration::Variable.define_instance_method( self, method_name ) do |binding|

  		return_object = nil
		  
			if binding
				bind( binding_name, binding )
				return_object = self
			else
				return_object = binding( binding_name )
			end
		
			return return_object
		
		end

	end
	
  ######################
  #  rebind_attribute  #
  ######################

	def rebind_attribute( binding_name, rebinding_name, view_class, live_configuration_proc )

		# remove the existing binding
		existing_configuration = attribute_bindings.delete( binding_name )

		# undefine methods
		getter_method = binding_name.accessor_name
		::CascadingConfiguration::Variable.remove_instance_method( self, getter_method )
		setter_method = binding_name.write_accessor_name
		::CascadingConfiguration::Variable.remove_instance_method( self, setter_method )

		declare_binding_methods( rebinding_name )
		
		attribute_bindings[ rebinding_name ] = existing_configuration
		
		existing_configuration.view_class = view_class
		
		if live_configuration_proc
			existing_configuration.live_configuration_proc = live_configuration_proc
		end
		
		# mark the binding as rebound - rebound bindings will be re-routed for superclass calls
		attribute_rebindings[ rebinding_name ] = binding_name

		return self
		
	end

  ######################################################
  #  set_attribute_required_for_binding_names_or_maps  #
  ######################################################
	
	def set_attribute_required_for_binding_names_or_maps( true_or_false, *binding_names_or_maps )
		
		binding_names_or_maps.each do |binding_name_or_map|
		
			if binding_name_or_map.is_a?( Hash )

				binding_name_or_map.each do |binding_name, view_class|
          binding_config = attribute_bindings[ binding_name ]
          binding_config.required = true_or_false
          if true_or_false
            required_bindings_hash[ binding_name ] = true
          else
            required_bindings_hash.delete( binding_name )
          end
				end
		
			else
			
				binding_name = binding_name_or_map
        binding_config = attribute_bindings[ binding_name ]
        binding_config.required = true_or_false
        if true_or_false
          required_bindings_hash[ binding_name ] = true
        else
          required_bindings_hash.delete( binding_name )
        end
			
			end

		end
		
	end

end
