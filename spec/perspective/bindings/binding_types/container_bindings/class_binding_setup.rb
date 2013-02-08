
def setup_container_class_binding_tests

  let( :mock_container_class ) do
    _mock_container_module = mock_container_module
    ::Class.new do
      extend( _mock_container_module )
      include ::CascadingConfiguration::Hash
      class_binding_methods = ::Module.new.name( :ClassBindingMethods )
      self::Controller.const_set( :ClassBindingMethods, class_binding_methods )
      attr_hash :__bindings__
    end
  end
  
  let( :nested_container_class_A ) { ::Class.new( mock_container_class ) }
  let( :nested_container_class_B ) { ::Class.new( mock_container_class ) }
  let( :nested_container_class_C ) { ::Class.new( mock_container_class ) }
  
  let( :topclass_class_binding ) { topclass_class_binding_A }
  let( :subclass_class_binding ) { subclass_class_binding_A }
  
  let( :topclass_class_binding_A_name ) { :a }
  let( :topclass_class_binding_A_B_name ) { :b }
  let( :topclass_class_binding_A_B_C_name ) { :c }
  
  let( :topclass_class_binding_A ) { class_binding_class.new( topclass_bound_container_class, topclass_class_binding_A_name, nested_container_class_A ) }
  let( :topclass_class_binding_A_B ) { class_binding_class.new( topclass_class_binding_A, topclass_class_binding_A_B_name, nested_container_class_B ) }
  let( :topclass_class_binding_A_B_C ) { class_binding_class.new( topclass_class_binding_A_B, topclass_class_binding_A_B_C_name, nested_container_class_C ) }
  
  let( :subclass_class_binding_A ) { class_binding_class.new( subclass_bound_container_class, topclass_class_binding_A ) }
  let( :subclass_class_binding_A_B ) { class_binding_class.new( subclass_class_binding_A, topclass_class_binding_A_B ) }
  let( :subclass_class_binding_A_B_C ) { class_binding_class.new( subclass_class_binding_A_B, topclass_class_binding_A_B_C ) }

end
