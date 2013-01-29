
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
    
    # And if we're including in a class instance, we need a Nested subclass.
    #
    # This class will live at including_class::Nested, and as parameters takes: 
    #
    #   #new( parent_instance_binding, *args )
    # 
    # where parent is the InstanceBinding instance from which configurations are to inherit,
    # and *args will be passed to including_class#new via super( *args ). 
    #
    unless class_or_module.const_defined?( :Nested ) or
          ! class_or_module.is_a?( ::Class )         or
          class_or_module.is_a?( ::Perspective::Bindings::Container::Nested::ClassInstance )
        
      nested_class_instance = nil
      
      # we need to disable this cluster so that we don't loop
      class_or_module.cluster( :perspective ).disable { nested_class_instance = ::Class.new( class_or_module ) }
      class_or_module.const_set( :Nested, nested_class_instance )
      nested_class_instance.extend( ::Perspective::Bindings::Container::Nested::ClassInstance )
      nested_class_instance.class_eval { include( ::Perspective::Bindings::Container::Nested::ObjectInstance ) }

      nested_class_instance.non_nested_class = class_or_module

    end
    
  end
  
end
