
module ::Magnets::Bindings::Container
  
	extend ::ModuleCluster
  extend ::ModuleCluster::Define::Block::CascadingClassOrModule

  extend ::Magnets::Bindings::Attributes
	extend ::Magnets::Bindings::Container::Context
  
  ccm_module = CascadingConfiguration::Methods::Module

  cascading_class_or_module_include do |class_instance|
    
    # Any time we are included in or cascade to a class we need to create our BindingMethods
    # module, which holds the methods for our bindings. This is necessary to make the bindings
    # portable, so that they can be inserted in bindings as well.

    ccm_module.create_support_module( class_instance, 
                                      :ClassBindingMethods,
                                      :class_bindings, 
                                      false, 
                                      true,
                                      self::BindingMethods )

    ccm_module.create_support_module( class_instance, 
                                      :InstanceBindingMethods,
                                      :instance_bindings, 
                                      true,
                                      false,
                                      self::BindingMethods,
                                      self::BindingMethods::InstanceBindingMethods )
    
  end

	include_or_extend_cascades_extends ::Magnets::Bindings::Container::ClassInstance

	include ::Magnets::Bindings::Container::ObjectInstance
  
end
