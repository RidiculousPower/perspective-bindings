
module ::Rmagnets::Bindings::ObjectInstance
	
  include ::CascadingConfiguration::Array
  include ::CascadingConfiguration::Hash
  
  # We rely on inheritance structure provided by CascadingConfiguration for Binding configuration.
  # Binding instance uses configuration instance (instance including this module) for 
  # defining parallel hierarchy.
  
	attr_configuration_hash   :binding_configurations, :binding_aliases, 
	                          :binding_routers, :shared_binding_routers
	                          
  attr_configuration_array  :binding_order

  ################
  #  initialize  #
  ################

  def initialize

		# instantiate specified views
		binding_configurations.each do |this_binding_name, this_binding_configuration|
		  
		  if view_class = this_binding_configuration.view_class
		    instance_variable_set( this_binding_name.variable_name, view_class.new )
      end
      
	  end

  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

	##############################
  #  ensure_required_bindings  #
  ##############################
  
	def ensure_required_bindings
    
    attribute_order = nil
    
		if ( attribute_order = self.class.attr_order ).empty?
		  attribute_order = self.class.binding_configurations.keys
	  end

		attribute_order.each do |this_binding_name|

      binding_takes_multiple = false
      
      if this_binding_name.is_a?( Array )
        binding_takes_multiple = true
        this_binding_name = this_binding_name[ 0 ]
      end

      binding_value = __send__( this_binding_name )

      # if binding is required and has a nil value, raise exception
			unless ! self.class.binding_configuration( this_binding_name ).required? or 
			       binding_value

				raise ::Rmagnets::Bindings::Exception::BindingRequired,
				        'Binding :' + this_binding_name.to_s + ' is required but not bound for class ' + 
				        self.class.to_s + '.'

			end
			
			# if binding value exists, make sure it is only one or permits many
			unless binding_takes_multiple
			  if binding_value.is_a?( Array )
			    raise ::Rmagnets::Bindings::Exception::BindingDoesNotExpectMultiple,
			            'Binding order declares ' + this_binding_name.to_s + 
			            ' to accept a single parameter, but multiple (' + binding_value.count.to_s + 
			            ') parameters were received.'
			  end
		  end

		end

	end
    
end
