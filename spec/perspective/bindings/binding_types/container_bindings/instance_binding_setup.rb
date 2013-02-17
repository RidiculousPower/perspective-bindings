
require_relative 'class_binding_setup.rb'

def setup_container_instance_binding_tests
  
  setup_container_class_binding_tests

  let( :topclass_bound_container_instance ) { topclass_bound_container_class.new }
  let( :topclass_nested_container_instance_A ) { nested_container_class_A.new }
  let( :topclass_nested_container_instance_B ) { nested_container_class_B.new }

  let( :subclass_bound_container_instance ) { subclass_bound_container_class.new }
  let( :subclass_nested_container_instance_A ) { nested_container_class_A.new }
  let( :subclass_nested_container_instance_B ) { nested_container_class_B.new }

  let( :topclass_instance_binding ) { topclass_instance_binding_A }
  let( :subclass_instance_binding ) { subclass_instance_binding_A }

  let( :topclass_instance_binding_A ) { instance_binding_class.new( topclass_class_binding_A, topclass_bound_container_instance ) }
  let( :topclass_instance_binding_A_B ) { instance_binding_class.new( topclass_class_binding_A_B, topclass_nested_container_instance_A ) }
  let( :topclass_instance_binding_A_B_C ) { instance_binding_class.new( topclass_class_binding_A_B_C, topclass_nested_container_instance_B ) }
  
  let( :subclass_instance_binding_A ) { instance_binding_class.new( subclass_class_binding_A, subclass_bound_container_instance ) }
  let( :subclass_instance_binding_A_B ) { instance_binding_class.new( subclass_class_binding_A_B, subclass_nested_container_instance_A ) }
  let( :subclass_instance_binding_A_B_C ) { instance_binding_class.new( subclass_class_binding_A_B_C, subclass_nested_container_instance_B ) }
  
end
