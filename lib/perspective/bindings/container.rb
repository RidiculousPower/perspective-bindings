# -*- encoding : utf-8 -*-

module ::Perspective::Bindings::Container
  
	extend ::Module::Cluster

	extend ::Perspective::Bindings::Container::Context
  
	include ::Perspective::Bindings::Container::ObjectInstance

  cluster( :perspective ).before_include_or_extend.
  cascade_to( :class ).extend( ::Perspective::Bindings::Container::ClassInstance ).
  cascade_to( :class, :module ).extend( ::Perspective::Bindings::Container::SingletonInstance ) do |class_or_module|
    # Any time we are included in or cascade to a class we need to create our BindingMethods
    # module, which holds the methods for our bindings. This is necessary to make the bindings
    # portable, so that they can be inserted in bindings as well as containers.
    class_binding_methods_module    = self::BindingMethods::ClassBindingMethods.new
    instance_binding_methods_module = self::BindingMethods::InstanceBindingMethods.new
    class_or_module.const_set( :ClassBindingMethods, class_binding_methods_module )
    class_or_module.const_set( :InstanceBindingMethods, instance_binding_methods_module )
    class_or_module.extend( class_binding_methods_module )
    class_or_module.instance_eval { include( instance_binding_methods_module ) }
    case class_or_module
      when ::Class
      when ::Module
        class_or_module.extend( ::Module::Cluster )
        cluster = class_or_module.cluster( :binding_methods_modules )
        cluster.before_include.cascade_to( :class, :module ).extend( class_binding_methods_module )
    end
  end
  
end
