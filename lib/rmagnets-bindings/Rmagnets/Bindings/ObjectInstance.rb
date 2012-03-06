
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
    
end
