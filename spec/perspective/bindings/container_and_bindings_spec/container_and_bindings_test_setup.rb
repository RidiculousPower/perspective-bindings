# -*- encoding : utf-8 -*-

require_relative '../../../support/named_class_and_module.rb'

########################################
#  setup_container_and_bindings_tests  #
########################################

def setup_container_and_bindings_tests
  
  let( :nested_class_A ) do
    _nested_class_A_B = nested_class_A_B
    _topclass_binding_A_B_action = topclass_binding_A_B_action
    nested_class_A = ::Class.new
    nested_class_A.name( :NestedClass_A )
    _bindings_module = bindings_module
    nested_class_A.class_eval do
      include _bindings_module
      attr_text :b, _nested_class_A_B, & _topclass_binding_A_B_action
    end
    nested_class_A
  end
  let( :nested_class_A_B ) do
    _nested_class_A_B_C = nested_class_A_B_C
    _topclass_binding_A_B_C_action = topclass_binding_A_B_C_action
    nested_class_A_B = ::Class.new
    nested_class_A_B.name( :NestedClass_A_B )
    _bindings_module = bindings_module
    nested_class_A_B.class_eval do
      include _bindings_module
      attr_text :c, _nested_class_A_B_C, & _topclass_binding_A_B_C_action
    end
    nested_class_A_B
  end
  let( :nested_class_A_B_C ) do
    nested_class_A_B_C = ::Class.new
    nested_class_A_B_C.name( :NestedClass_A_B_C )
    _bindings_module = bindings_module
    nested_class_A_B_C.class_eval do
      include _bindings_module
      attr_text :content
    end
    nested_class_A_B_C
  end

  let( :module_instance ) do
    _nested_class_A = nested_class_A
    _topclass_binding_A_action = topclass_binding_A_action
    module_instance = ::Module.new
    module_instance.name( :ModuleInstance )
    _bindings_module = bindings_module
    module_instance.module_eval do
      include _bindings_module
      attr_text :a, _nested_class_A, & _topclass_binding_A_action
      attr_alias :a_alias, :a
    end
    module_instance
  end
  let( :sub_module_instance ) do
    _module_instance = module_instance
    sub_module_instance = ::Module.new 
    sub_module_instance.name( :SubModuleInstance )
    _subclass_binding_A_action = subclass_binding_A_action
    _subclass_binding_A_B_action = subclass_binding_A_B_action
    _subclass_binding_A_B_C_action = subclass_binding_A_B_C_action
    sub_module_instance.module_eval do
      include _module_instance
      attr_binding :binding_one, :binding_two
      attr_text :content
      a.configure( & _subclass_binding_A_action )
      a.b.configure( & _subclass_binding_A_B_action )
      a.b.c.configure( & _subclass_binding_A_B_C_action )
    end
    sub_module_instance
  end
  let( :class_instance ) do
    _sub_module_instance = sub_module_instance
    class_instance = ::Class.new 
    class_instance.name( :SingletonInstance )
    class_instance.class_eval do
      include _sub_module_instance
    end
    class_instance
  end
  let( :subclass ) do
    subclass = ::Class.new( class_instance )
    subclass.name( :SubclassInstance )
    subclass
  end

  let( :instance_of_class ) do
    object = class_instance.new
    object.name( :InstanceOfClass )
    object
  end
  let( :instance_of_subclass ) do
    instance_of_subclass = subclass.new
    instance_of_subclass.name( :InstanceOfSubclass )
    instance_of_subclass
  end

  let( :multiple_container_class ) do
    multiple_container_class = ::Class.new
    multiple_container_class.name( :MultipleContainerClass )
    _nested_class_A_B_C = nested_class_A_B_C
    _bindings_module = bindings_module
    multiple_container_class.module_eval do
      include _bindings_module
      attr_texts :multiple_binding, _nested_class_A_B_C
    end
    multiple_container_class
  end
  let( :instance_of_multiple_container_class ) { multiple_container_class.new }

  let( :topclass_binding_A_block_state ) { ::BlockState.new }
  let( :topclass_binding_A_B_block_state ) { ::BlockState.new }
  let( :topclass_binding_A_B_C_block_state ) { ::BlockState.new }
  let( :subclass_binding_A_block_state ) { ::BlockState.new }
  let( :subclass_binding_A_B_block_state ) { ::BlockState.new }
  let( :subclass_binding_A_B_C_block_state ) { ::BlockState.new }
  
  let( :topclass_binding_A_action ) { _block_state = topclass_binding_A_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :topclass_binding_A_B_action ) { _block_state = topclass_binding_A_B_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :topclass_binding_A_B_C_action ) { _block_state = topclass_binding_A_B_C_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :subclass_binding_A_action ) { _block_state = subclass_binding_A_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :subclass_binding_A_B_action ) { _block_state = subclass_binding_A_B_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :subclass_binding_A_B_C_action ) { _block_state = subclass_binding_A_B_C_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }

  let( :topclass_configuration_proc ) { topclass_binding_A_action }
  let( :subclass_configuration_proc ) { subclass_binding_A_action }

  let( :binding_name ) { topclass_class_binding_A.«name» }
  
  let( :topclass_bound_container ) { topclass_bound_container_class }
  let( :subclass_bound_container ) { subclass_bound_container }

  let( :topclass_bound_container_class ) { top_singleton_instance }
  let( :subclass_bound_container_class ) { sub_singleton_instance }
  
  let( :nested_container_class_A ) { nested_class_A }
  let( :nested_container_class_B ) { nested_class_A_B }
  let( :nested_container_class_C ) { nested_class_A_B_C }

  let( :topclass_class_binding ) { topclass_class_binding_A }
  let( :subclass_class_binding ) { subclass_class_binding_A }

  let( :topclass_class_binding_A_name ) { :a }
  let( :topclass_class_binding_A_B_name ) { :b }
  let( :topclass_class_binding_A_B_C_name ) { :c }

  let( :topclass_class_binding_A ) { top_singleton_instance.a }
  let( :topclass_class_binding_A_B ) { top_singleton_instance.a.b }
  let( :topclass_class_binding_A_B_C ) { top_singleton_instance.a.b.c }

  let( :subclass_class_binding_A ) { sub_singleton_instance.a }
  let( :subclass_class_binding_A_B ) { sub_singleton_instance.a.b }
  let( :subclass_class_binding_A_B_C ) { sub_singleton_instance.a.b.c }
  
  let( :data_binding ) { data_container.a.b.c }
  
  let( :data_container ) do
    data_container = class_instance.new
    data_container.content.value = :content_value
    data_container.binding_one.value = :binding_one_value
    data_container.binding_two.value = :binding_two_value
    data_container.a.b.c.content.value = :c_content_value
    data_container
  end
  
  let( :data_hash ) do
    { :binding_one => :binding_one_value,
      :binding_two => :binding_two_value,
      :content => :content_value,
      :a => { :b => { :c => :c_content_value } } }
  end
  
  let( :data_object ) do
    data_object = data_object_class.new
    data_object.binding_one = :binding_one_value
    data_object.binding_two = :binding_two_value
    data_object.content = :content_value
    data_object.a.b.c = :c_content_value
    data_object
  end

  let( :data_object2 ) do
    data_object2 = data_object_class.new
    data_object2.binding_one = :binding_one_value2
    data_object2.binding_two = :binding_two_value2
    data_object2.content = :content_value2
    data_object2.a.b.c = :c_content_value2
    data_object2
  end

  let( :data_object3 ) do
    data_object3 = data_object_class.new
    data_object3.binding_one = :binding_one_value3
    data_object3.binding_two = :binding_two_value3
    data_object3.content = :content_value3
    data_object3.a.b.c = :c_content_value3
    data_object3
  end
  
  let( :data_object_class ) do
    data_object_class = ::Class.new
    data_object_class.name( :DataObject )
    _data_object_a_class = data_object_a_class
    data_object_class.module_eval do
      attr_accessor :content, :binding_one, :binding_two, :a
      define_method( :initialize ) do
        @a = _data_object_a_class.new
      end
    end
    data_object_class
  end

  let( :data_object_a_class ) do
    data_object_a_class = ::Class.new
    data_object_a_class.name( :DataObject_A )
    _data_object_b_class = data_object_b_class
    data_object_a_class.module_eval do
      attr_accessor :b
      define_method( :initialize ) do
        @b = _data_object_b_class.new
      end
    end
    data_object_a_class
  end

  let( :data_object_b_class ) do
    data_object_b_class = ::Class.new
    data_object_b_class.name( :DataObject_B )
    data_object_b_class.module_eval do
      attr_accessor :c
    end
    data_object_b_class
  end

  let( :multiple_data_objects ) { [ data_object.a.b.c, data_object2.a.b.c, data_object3.a.b.c ] }

end
