
module ::Perspective::Bindings::Container
  
	extend ::Module::Cluster

	extend ::Perspective::Bindings::Container::Context
  
	include ::Perspective::Bindings::Container::ObjectInstance

  cluster = cluster( :perspective )

  cascade = cluster.before_include_or_extend.cascade
  cascade.extend( ::Perspective::Bindings::Container::ClassInstance )
  
  cluster.before_include.cascade do |class_or_module_instance|
    
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
