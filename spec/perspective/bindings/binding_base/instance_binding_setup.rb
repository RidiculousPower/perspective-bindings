
require_relative 'class_binding_setup.rb'

def setup_instance_binding_tests

  setup_base_class_binding_tests

  let( :topclass_instance_binding ) { instance_binding_class.new( topclass_class_binding, topclass_bound_container_instance ) }
  let( :subclass_instance_binding ) { instance_binding_class.new( subclass_class_binding, subclass_bound_container_instance ) }

  let( :topclass_bound_container_instance ) { topclass_bound_container_class.new }
  let( :subclass_bound_container_instance ) { subclass_bound_container_class.new }

end
