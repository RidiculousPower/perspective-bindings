
module ::Rmagnets::Bindings::ObjectInstance
	
  include ::CascadingConfiguration::Array
  include ::CascadingConfiguration::Hash
  
  extend ModuleCluster::Define::Block::CascadingClassOrModule
  
  # We rely on inheritance structure provided by CascadingConfiguration for Binding configuration.
  # Binding instance uses configuration instance (instance including this module) for 
  # defining parallel hierarchy.
  
	attr_configuration_hash   :binding_configurations, :binding_aliases, :renamed_bindings,
	                          :binding_routers, :shared_binding_routers
	                          
  attr_configuration_array  :binding_order

  # Ensure that each inheritance level has its own binding copy.
  # This way settings cascade and any level can have its own setting.
  cascading_class_or_module_include do |class_or_module|
    
    binding_configurations.each do |this_binding_name, this_binding_instance|
      
      class_or_module.instance_eval do
        
        # Create a new binding without any settings - 
        # causes automatic lookup to superclass.
        create_binding( this_binding_name, nil, false )
        
      end
      
    end
    
  end

  ################
  #  initialize  #
  ################

  def initialize

		# instantiate specified views
		binding_configurations.each do |this_binding_name, this_binding_instance|
		  
		  bound_instance = nil
		  
		  if view_class = this_binding_instance.view_class
		    bound_instance = view_class.new
		    instance_variable_set( this_binding_name.variable_name, bound_instance )
      end
      
      # run configuration proc for each binding instance
  		this_binding_instance.configuration_procs.each do |this_configuration_proxy|
  		  this_configuration_proxy.proxy_bindings_for_configuration_proc( self, bound_instance )
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
