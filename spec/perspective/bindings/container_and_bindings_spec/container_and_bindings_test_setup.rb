# -*- encoding : utf-8 -*-

require_relative '../../../support/named_class_and_module.rb'

########################################
#  setup_container_and_bindings_tests  #
########################################

def setup_block_actions
  
  top_block_state_A_B_C = ::BlockState.new
  top_block_state_A_B   = ::BlockState.new
  top_block_state_A     = ::BlockState.new
  sub_block_state_A_B_C = ::BlockState.new
  sub_block_state_A_B   = ::BlockState.new
  sub_block_state_A     = ::BlockState.new

  top_action_A_B_C = ::Proc.new { top_block_state_A_B_C.block_ran! }
  top_action_A_B   = ::Proc.new { top_block_state_A_B.block_ran! }
  top_action_A     = ::Proc.new { top_block_state_A.block_ran! }
  sub_action_A_B_C = ::Proc.new { sub_block_state_A_B_C.block_ran! }
  sub_action_A_B   = ::Proc.new { sub_block_state_A_B.block_ran! }
  sub_action_A     = ::Proc.new { sub_block_state_A.block_ran! }
  
  let( :topclass_binding_A_block_state ) { top_block_state_A }
  let( :topclass_binding_A_B_block_state ) { top_block_state_A_B }
  let( :topclass_binding_A_B_C_block_state ) { top_block_state_A_B_C }
  let( :subclass_binding_A_block_state ) { sub_block_state_A }
  let( :subclass_binding_A_B_block_state ) { sub_block_state_A_B }
  let( :subclass_binding_A_B_C_block_state ) { sub_block_state_A_B_C }
  
  let( :topclass_binding_A_action ) { top_action_A }
  let( :topclass_binding_A_B_action ) { top_action_A_B }
  let( :topclass_binding_A_B_C_action ) { top_action_A_B_C }
  let( :subclass_binding_A_action ) { sub_action_A }
  let( :subclass_binding_A_B_action ) { sub_action_A_B }
  let( :subclass_binding_A_B_C_action ) { sub_action_A }
  
  return top_block_state_A_B_C, top_block_state_A_B, top_block_state_A,
         sub_block_state_A_B_C, sub_block_state_A_B, sub_block_state_A,
         top_action_A_B_C,      top_action_A_B,      top_action_A,
         sub_action_A_B_C,      sub_action_A_B,      sub_action_A
         
end

def setup_container_and_bindings_tests( bindings_module, test_container = nil )

  top_block_state_A_B_C, top_block_state_A_B, top_block_state_A,
  sub_block_state_A_B_C, sub_block_state_A_B, sub_block_state_A,
  top_action_A_B_C,      top_action_A_B,      top_action_A,
  sub_action_A_B_C,      sub_action_A_B,      sub_action_A = setup_block_actions
  
  unless test_container
    test_container = ::Module.new
    bindings_module.const_set( :Test, test_container )
  end

  nested_class_A_B_C = ::Class.new
  nested_class_A_B = ::Class.new
  nested_class_A = ::Class.new
  module_instance = ::Module.new
  sub_module_instance = ::Module.new
  class_instance = ::Class.new
  subclass = ::Class.new( class_instance )
  
  multiple_container_class_instance = ::Class.new

  data_object_class = ::Class.new
  data_object_A_class = ::Class.new
  data_object_B_class = ::Class.new
  
  test_container.class_eval do

    const_set( :NestedClassA, nested_class_A )
    const_set( :NestedClassA_B, nested_class_A_B )
    const_set( :NestedClassA_B_C, nested_class_A_B_C )
    const_set( :ModuleInstance, module_instance )
    const_set( :SubModuleInstance, sub_module_instance )
    const_set( :ClassInstance, class_instance )
    const_set( :Subclass, subclass )

    const_set( :MultipleContainerClass, multiple_container_class_instance )

    const_set( :DataObject, data_object_class )
    const_set( :DataObjectA, data_object_A_class )
    const_set( :DataObjectB, data_object_B_class )

  end

  test_container::NestedClassA_B_C.class_eval do
    include bindings_module
    attr_text :content
    attr_autobind :content
  end
  test_container::NestedClassA_B.class_eval do
    include bindings_module
    attr_text :c, nested_class_A_B_C, & top_action_A_B_C
  end
  test_container::NestedClassA.class_eval do
    include bindings_module
    attr_text :b, nested_class_A_B, & top_action_A_B
  end

  test_container::ModuleInstance.module_eval do
    include bindings_module
    attr_text :a, nested_class_A, & top_action_A
    attr_alias :a_alias, :a
  end
  test_container::SubModuleInstance.module_eval do
    include module_instance
    attr_binding :binding_one, :binding_two
    attr_text :content
    attr_autobind :content
    a.configure( & sub_action_A )
    a.b.configure( & sub_action_A_B )
    a.b.c.configure( & sub_action_A_B_C )
  end
  test_container::ClassInstance.module_eval { include sub_module_instance }

  test_container::MultipleContainerClass.module_eval do
    include bindings_module
    attr_texts :multiple_binding, nested_class_A_B_C
  end

  test_container::DataObject.module_eval do
    attr_accessor :content, :binding_one, :binding_two, :a
    define_method( :initialize ) do
      @a = data_object_A_class.new
    end
  end
  test_container::DataObjectA.module_eval do
    attr_accessor :b
    define_method( :initialize ) do
      @b = data_object_B_class.new
    end
  end
  test_container::DataObjectB.module_eval do
    attr_accessor :c
  end
  
  let( :nested_class_A ) { test_container::NestedClassA }
  let( :nested_class_A_B ) { test_container::NestedClassA_B }
  let( :nested_class_A_B_C ) { test_container::NestedClassA_B_C }

  let( :module_instance ) { test_container::ModuleInstance }
  let( :sub_module_instance ) { test_container::SubModuleInstance }
  let( :class_instance ) { test_container::ClassInstance }
  let( :subclass ) { test_container::Subclass }

  let( :multiple_container_class ) { test_container::MultipleContainerClass }

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

  let( :topclass_configuration_proc ) { topclass_binding_A_action }
  let( :subclass_configuration_proc ) { subclass_binding_A_action }

  let( :binding_name ) { topclass_class_binding_A.«name» }
  
  let( :topclass_bound_container ) { topclass_bound_container_class }
  let( :subclass_bound_container ) { subclass_bound_container_class }

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
  
  data_container = class_instance.new
  data_container.content = :content_value
  data_container.binding_one = :binding_one_value
  data_container.binding_two = :binding_two_value
  data_container.a.b.c = :c_content_value
  let( :data_container ) { data_container }
  let( :data_binding ) { data_container.a.b.•c }
  
  data_hash = { :binding_one => :binding_one_value,
                :binding_two => :binding_two_value,
                :content => :content_value,
                :a => { :b => { :c => :c_content_value } } }
  let( :data_hash ) { data_hash }

  
  let( :data_object_class ) { data_object_class }
  let( :data_object_A_class ) { data_object_A_class }
  let( :data_object_B_class ) { data_object_B_class }

  data_object = data_object_class.new
  data_object.binding_one = :binding_one_value
  data_object.binding_two = :binding_two_value
  data_object.content = :content_value
  data_object.a.b.c = :c_content_value
  let( :data_object ) { data_object }

  data_object2 = data_object_class.new
  data_object2.binding_one = :binding_one_value2
  data_object2.binding_two = :binding_two_value2
  data_object2.content = :content_value2
  data_object2.a.b.c = :c_content_value2
  let( :data_object2 ) { data_object2 }

  data_object3 = data_object_class.new
  data_object3.binding_one = :binding_one_value3
  data_object3.binding_two = :binding_two_value3
  data_object3.content = :content_value3
  data_object3.a.b.c = :c_content_value3
  let( :data_object3 ) { data_object3 }
  
  multiple_data_objects = [ data_object.a.b.c, data_object2.a.b.c, data_object3.a.b.c ]
  let( :multiple_data_objects ) { multiple_data_objects }
  
end
