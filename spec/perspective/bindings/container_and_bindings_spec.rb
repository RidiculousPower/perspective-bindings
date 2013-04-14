# -*- encoding : utf-8 -*-

require_relative 'container_and_bindings_spec/container_and_bindings_test_setup.rb'
require_relative 'container_and_bindings_spec/container_and_bindings.rb'

describe ::Perspective::Bindings::Container do
  
  setup_container_and_bindings_tests( ::Perspective::Bindings::Container )

  let( :top_singleton_instance ) { class_instance }
  let( :sub_singleton_instance ) { subclass }

  let( :binding_name ) { topclass_instance_binding_A.«name» }

  let( :topclass_binding ) { topclass_class_binding }
  let( :subclass_binding ) { subclass_class_binding }

  let( :topclass_bound_container ) { topclass_bound_container_class }
  let( :subclass_bound_container ) { subclass_bound_container_class }
  let( :topclass_bound_container_class ) { top_singleton_instance }
  let( :subclass_bound_container_class ) { sub_singleton_instance }

  let( :topclass_bound_container_instance ) { instance_of_class }
  let( :topclass_nested_container_instance_A ) { instance_of_class.•a.«container» }
  let( :topclass_nested_container_instance_B ) { instance_of_class.a.•b.«container» }

  let( :subclass_bound_container_instance ) { instance_of_subclass }
  let( :subclass_nested_container_instance_A ) { instance_of_subclass.•a.«container» }
  let( :subclass_nested_container_instance_B ) { instance_of_subclass.a.•b.«container» }

  let( :topclass_class_binding ) { topclass_class_binding_A }

  let( :topclass_instance_binding ) { topclass_instance_binding_A }
  let( :subclass_instance_binding ) { subclass_instance_binding_A }

  let( :topclass_instance_binding_A ) { instance_of_class.a }
  let( :topclass_instance_binding_A_B ) { instance_of_class.a.b }
  let( :topclass_instance_binding_A_B_C ) { instance_of_class.a.b.•c }

  let( :subclass_instance_binding_A ) { instance_of_subclass.a }
  let( :subclass_instance_binding_A_B ) { instance_of_subclass.a.b }
  let( :subclass_instance_binding_A_B_C ) { instance_of_subclass.a.b.•c }

  it_behaves_like :base_instance_binding
  it_behaves_like :container_instance_binding
  
  it_behaves_like :container_and_bindings
  
end
