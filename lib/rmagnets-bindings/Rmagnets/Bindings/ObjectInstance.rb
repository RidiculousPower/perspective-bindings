
module ::Rmagnets::Bindings::ObjectInstance
	
  include ::CascadingConfiguration::Array
  include ::CascadingConfiguration::Hash

	attr_configuration_hash          :attribute_bindings, :required_bindings_hash, 
	                                 :attribute_rebindings, :binding_aliases
  attr_configuration_array         :binding_order

  ################
  #  initialize  #
  ################

  def initialize
    
    @bound_bindings = { }
		
  end
  
  ##########
  #  bind  #
  ##########

	def bind( *object_binding )
		
		until object_binding.empty?
			
			this_object_binding = object_binding.shift
			
			if this_object_binding.is_a?( Hash )
				
				this_object_binding.each do |this_binding, this_object|

				  bind( this_binding, this_object )

				end
				
			else
				
				this_binding 	= this_object_binding
				this_object		=	object_binding.shift
				
				unless self.class.has_binding?( this_binding )
      		raise ::Rmagnets::Bindings::Exception::NoBindingError,
      		      'No binding defined for :' + binding_name.to_s + ' in class ' + 
				        self.class.to_s + '.'
				end
				
				@bound_bindings[ this_binding ] = this_object
				
			end
			
		end

		return self
		
	end

  ############
  #  unbind  #
  ############

	def unbind( *object_bindings )
		
		object_bindings.each do |this_binding|
      
      @bound_bindings.delete( this_binding )
      
    end
    
  end
  
  #############
  #  binding  #
  #############

	def binding( *binding_names )
		
		binding_instance = nil

		until binding_names.empty?

			this_binding_name = binding_names.shift
			
			if binding_instance
				
				binding_instance = binding_instance.binding( this_binding_name )
			
			else
				
				if self.class.binding_is_rebinding?( this_binding_name )
					this_binding_name = self.class.binding_for_rebinding( this_binding_name )
				end
				
				unless self.class.has_binding?( this_binding_name )
				  raise 'No binding defined for :' + this_binding_name.to_s + ' in ' + self.class.to_s + '.'
				end
				
				binding_instance = @bound_bindings[ this_binding_name ]
			
			end

		end

		return binding_instance

	end
	
  ##################
  #  has_binding?  #
  ##################

	def has_binding?( binding )
		
		return @bound_bindings.has_key?( binding )

	end

  ###############################################
  #  binding_requires_rendering_to_html_node?  #
  ###############################################
	
	def binding_requires_rendering_to_html_node?( binding )
	  
		return binding( binding ).respond_to?( :to_html_node )

	end
	
	###########################
  #  ensure_binding_exists  #
  ###########################
	
	# looks for has_binding?( binding_name ) in each of cascading_bindings_or_objects
	# if no object or binding in cascading_bindings_or_objects has the binding, uses default view
	# or instantiates default view class
	def ensure_binding_exists( binding_name, default_view_or_class, *cascading_bindings_or_objects )
	
		binding_instance	=	nil
		
		if cascading_bindings_or_objects.empty?
			cascading_bindings_or_objects = [ self ]
		end
	
		# cascade through bindings and objects until we find one that has the requested binding
		cascading_bindings_or_objects.each do |this_binding_or_object|

			if this_binding_or_object.is_a?( Symbol )

				if binding( this_binding_or_object ).has_binding?( binding_name )
					binding_instance = binding( this_binding_or_object ).binding( binding_name )
					break
				end

			else

				if this_binding_or_object.has_binding?( binding_name )
					binding_instance = this_binding_or_object.binding( binding_name )
					break
				end

			end

		end
		
		# if we don't have a binding instance from bindings or objects, use default
		unless binding_instance

			# default can be a class, in which case we instantiate it
			if default_view_or_class.is_a?( Class )

				binding_instance = default_view_or_class.new

			# or it can be an instance, in which case we simply bind it
			else

				binding_instance = default_view_or_class

			end

		end
	
		# finally, bind our requested instance
		bind( binding_name => binding_instance )
		
		return self
		
	end
		
	#####################
	#  cascade_binding  #
	#####################

  # cascade_binding( :binding_name_in_self, :to_same_binding_name_in_binding )
  # cascade_binding( :binding_name_in_self, :in_binding => :to_other_binding_name )
	def cascade_binding( binding_name, cascade_descriptor_hash_or_binding )
		
		binding_cascade_fills = nil
		
		if cascade_descriptor_hash_or_binding.is_a?( Hash )

  		binding_cascade_fills = nil
		  
	  else
	    
	    binding_cascade_fills = binding_name
  		
    end
				
		# link binding in self with binding in with_binding_name unless with_binding_name already has a binding
		unless binding( with_binding_name ).has_binding?( binding_name )
		  
			binding( with_binding_name ).bind( binding_name => binding( binding_name ) ) 
		
		end
		
		return self
		
	end
	
end
