
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

	###########################
  #  ensure_valid_bindings  #
  ###########################
  
	def ensure_valid_bindings
    
    attribute_order = nil
    
    if binding_order.empty?
      raise ::Rmagnets::Bindings::Exception::BindingOrderEmpty,
              'Binding order was empty. Declare binding order using :attr_order.'
    end

		binding_order.each do |this_binding_name|
      
      binding_configuration = self.class.binding_configuration( this_binding_name )
      binding_value = __send__( this_binding_name )

      binding_configuration.ensure_binding_value_valid( binding_value )

		end

	end
    
end
