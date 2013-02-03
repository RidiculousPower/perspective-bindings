
module ::Perspective::Bindings::Container
  
	extend ::Module::Cluster

	extend ::Perspective::Bindings::Container::Context
  
	include ::Perspective::Bindings::Container::ObjectInstance

  cluster = cluster( :perspective )

  cluster.before_include_or_extend.cascade.extend( ::Perspective::Bindings::Container::ClassInstance )
  
  cluster.before_include.cascade do |class_or_module|
    
    # Any time we are included in or cascade to a class we need to create our BindingMethods
    # module, which holds the methods for our bindings. This is necessary to make the bindings
    # portable, so that they can be inserted in bindings as well as containers.
    unless controller = ::CascadingConfiguration.instance_controller( class_or_module )
      controller = ::CascadingConfiguration.create_instance_controller( class_or_module )
    end    

    controller.create_singleton_support( :class_binding_methods, self::BindingMethods )
    controller.create_instance_support( :instance_binding_methods, self::BindingMethods::InstanceBindingMethods )
    
  end
  
end
