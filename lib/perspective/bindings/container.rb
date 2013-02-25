
module ::Perspective::Bindings::Container
  
	extend ::Module::Cluster

	extend ::Perspective::Bindings::Container::Context
  
	include ::Perspective::Bindings::Container::ObjectInstance

  cluster = cluster( :perspective )
  
  cluster.before_include_or_extend.
  cascade_to( :class, :module ).extend( ::Perspective::Bindings::Container::SingletonInstance ).
  cascade_to( :class ).extend( ::Perspective::Bindings::Container::SingletonInstance ).
  cascade do |instance|
    # Any time we are included in or cascade to a class we need to create our BindingMethods
    # module, which holds the methods for our bindings. This is necessary to make the bindings
    # portable, so that they can be inserted in bindings as well as containers.
    unless controller = ::CascadingConfiguration.instance_controller( instance )
      controller = ::CascadingConfiguration.create_instance_controller( instance )
    end    
    controller.create_singleton_support( :class_binding_methods, self::BindingMethods )
    controller.create_instance_support( :instance_binding_methods, self::BindingMethods )    
  end
  
end
