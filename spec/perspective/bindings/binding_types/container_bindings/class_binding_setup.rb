
require_relative '../../binding_base/class_binding_setup.rb'

def setup_container_class_binding_tests

  setup_base_class_binding_tests

  let( :mock_container_class_implementation ) do
    _mock_container_module = mock_container_module
    ::Class.new do
      include( _mock_container_module )
      extend( _mock_container_module )
      include ::CascadingConfiguration::Setting
      include ::CascadingConfiguration::Hash
      include ::CascadingConfiguration::Array
      def initialize( *args )
      end
      alias_singleton_method( :new_nested_instance, :new )
      class_binding_methods = ::Module.new.name( :ClassBindingMethods )
      self::Controller.const_set( :ClassBindingMethods, class_binding_methods )
      instance_binding_methods = ::Module.new.name( :ClassBindingMethods )
      self::Controller.const_set( :InstanceBindingMethods, instance_binding_methods )
      attr_hash :«bindings, :«binding_aliases
      attr_configuration :«name, :«route, :«route_with_name, :«route_string, :«route_print_string, :permits_multiple?, :required?
      def «autobind( *args )
        @called_autobind = true
      end
      def called_autobind?
        return @called_autobind
      end
      def initialize_for_index( *args )
      end
    end
  end
  
  let( :mock_container_class ) { mock_container_class_implementation }
  
  let( :nested_container_class_A ) { ::Class.new( mock_container_class ) }
  let( :nested_container_class_B ) { ::Class.new( mock_container_class ) }
  let( :nested_container_class_C ) { ::Class.new( mock_container_class ) }
  
  let( :topclass_class_binding ) { topclass_class_binding_A }
  let( :subclass_class_binding ) { subclass_class_binding_A }
  
  let( :topclass_class_binding_A_name ) { :a }
  let( :topclass_class_binding_A_B_name ) { :b }
  let( :topclass_class_binding_A_B_C_name ) { :c }

  let( :topclass_binding_A_block_state ) { topclass_block_state }
  let( :topclass_binding_A_B_block_state ) { ::BlockState.new }
  let( :topclass_binding_A_B_C_block_state ) { ::BlockState.new }
  let( :subclass_binding_A_block_state ) { subclass_block_state }
  let( :subclass_binding_A_B_block_state ) { ::BlockState.new }
  let( :subclass_binding_A_B_C_block_state ) { ::BlockState.new }
  
  let( :topclass_binding_A_action ) { _block_state = topclass_binding_A_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :topclass_binding_A_B_action ) { _block_state = topclass_binding_A_B_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :topclass_binding_A_B_C_action ) { _block_state = topclass_binding_A_B_C_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :subclass_binding_A_action ) { _block_state = subclass_binding_A_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :subclass_binding_A_B_action ) { _block_state = subclass_binding_A_B_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :subclass_binding_A_B_C_action ) { _block_state = subclass_binding_A_B_C_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  
  let( :topclass_class_binding_A ) { class_binding_class.new( topclass_bound_container_class, topclass_class_binding_A_name, nested_container_class_A, & topclass_binding_A_action ) }
  let( :topclass_class_binding_A_B ) { class_binding_class.new( topclass_class_binding_A, topclass_class_binding_A_B_name, nested_container_class_B, & topclass_binding_A_B_action ) }
  let( :topclass_class_binding_A_B_C ) { class_binding_class.new( topclass_class_binding_A_B, topclass_class_binding_A_B_C_name, nested_container_class_C, & topclass_binding_A_B_C_action ) }
  
  let( :subclass_class_binding_A ) { class_binding_class.new( subclass_bound_container_class, topclass_class_binding_A, & subclass_binding_A_action ) }
  let( :subclass_class_binding_A_B ) { class_binding_class.new( subclass_class_binding_A, topclass_class_binding_A_B, & subclass_binding_A_B_action ) }
  let( :subclass_class_binding_A_B_C ) { class_binding_class.new( subclass_class_binding_A_B, topclass_class_binding_A_B_C, & subclass_binding_A_B_C_action ) }

end
