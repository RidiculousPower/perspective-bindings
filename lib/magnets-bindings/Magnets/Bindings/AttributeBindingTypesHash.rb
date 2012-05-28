
class ::Magnets::Bindings::AttributeBindingTypesHash < ::CompositingHash

  ################
  #  initialize  #
  ################

  def initialize( configuration_instance, parent_compositing_hash )
    
    super( parent_compositing_hash )
    
    @configuration_instance = configuration_instance
    
  end
  
  ########################
  #  child_pre_set_hook  #
  ########################

  def child_pre_set_hook( configuration_instance, binding_definition_hash )

    # We are inheriting types - we have to define our own corresponding classes.
    configuration_instance.define_binding_type( binding_type, *instance_definition_modules )

    return instance_definition_modules
    
  end
  
end
