
module ::Magnets::Bindings::Container
  
	extend ::ModuleCluster
  extend ::ModuleCluster::Define::Block::CascadingClassOrModule

	extend ::Magnets::Bindings::Container::Context
  
	include ::Magnets::Bindings::Container::ObjectInstance

	include_or_extend_cascades_prepend_extends ::Magnets::Bindings::Container::ClassInstance

  cascading_prepend_class_or_module_include do |class_or_module_instance|
    
    # Any time we are included in or cascade to a class we need to create our BindingMethods
    # module, which holds the methods for our bindings. This is necessary to make the bindings
    # portable, so that they can be inserted in bindings as well.
    
    unless instance_controller = ::CascadingConfiguration::Core::
                                   InstanceController.instance_controller( class_or_module_instance )
      instance_controller = ::CascadingConfiguration::Core::
                              InstanceController.create_instance_controller( class_or_module_instance )
    end
    
    instance_controller.create_support( :class_binding_methods, 
                                        :default,
                                        self::BindingMethods,
                                        false, 
                                        true,
                                        false,
                                        true )
    
    instance_controller.create_support( :instance_binding_methods, 
                                        :default,
                                        self::BindingMethods::InstanceBindingMethods,
                                        true,
                                        false,
                                        true,
                                        false )
        
  end
  
end
