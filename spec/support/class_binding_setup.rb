
def setup_class_binding_tests
  
  let( :mock_container_module ) do
    ::Module.new do
      def __root__ ; return self ; end
      def __root_string__ ; return to_s ; end
    end
  end
  
  let( :base_container ) do
    _mock_container_module = mock_container_module
    ::Class.new { include( _mock_container_module ) }.extend( mock_container_module )
  end
  let( :first_nested_container ) do
    _mock_container_module = mock_container_module
    ::Class.new { include( _mock_container_module ) }.extend( mock_container_module )
  end
  let( :nth_nested_container ) do
    _mock_container_module = mock_container_module
    ::Class.new { include( _mock_container_module ) }.extend( mock_container_module )
  end
  let( :sub_base_container ) { ::Class.new( base_container ) }
  let( :sub_first_nested_container ) { ::Class.new( first_nested_container ) }
  let( :sub_nth_nested_container ) { ::Class.new( nth_nested_container ) }
    
  let( :binding_to_base_name ) { :binding_to_base }
  let( :binding_to_first_nested_name ) { :binding_to_first_nested }
  let( :binding_to_nth_nested_name ) { :binding_to_nth_nested }

  let( :base_proc ) { ::Proc.new { puts 'base_proc!' } }
  let( :first_nested_proc ) { ::Proc.new { puts 'first_nested_proc!' } }
  let( :nth_nested_proc ) { ::Proc.new { puts 'nth_nested_proc!' } }

  let( :class_binding_to_base ) { class_binding_class.new( base_container, binding_to_base_name, & base_proc ) }
  let( :class_binding_to_first_nested ) { class_binding_class.new( class_binding_to_base, binding_to_first_nested_name, & first_nested_proc ) }
  let( :class_binding_to_nth_nested ) { class_binding_class.new( class_binding_to_first_nested, binding_to_nth_nested_name, & nth_nested_proc ) }
  
  let( :subclass_class_binding_to_base ) { class_binding_class.new( sub_base_container, nil, class_binding_to_base ) }
  let( :subclass_class_binding_to_first_nested ) { class_binding_class.new( subclass_class_binding_to_base, nil, class_binding_to_first_nested ) }
  let( :subclass_class_binding_to_nth_nested ) { class_binding_class.new( subclass_class_binding_to_first_nested, nil, class_binding_to_nth_nested ) }
  
end