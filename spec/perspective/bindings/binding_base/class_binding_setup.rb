# -*- encoding : utf-8 -*-

require_relative '../../../support/block_state.rb'

def setup_base_class_binding_tests
  
  let( :mock_container_module ) do
    ::Module.new do
      def «root» ; return self ; end
      def «root_string» ; return to_s ; end
    end
  end

  let( :topclass_bound_container_class ) do
    _mock_container_module = mock_container_module
    ::Class.new { include( _mock_container_module ) }.extend( mock_container_module )
  end
  let( :subclass_bound_container_class ) { ::Class.new( topclass_bound_container_class ) }

  let( :binding_name ) { :test_binding }

  let( :topclass_configuration_proc ) { ::Proc.new { puts 'topclass_proc!' } }
  let( :subclass_configuration_proc ) { ::Proc.new { puts 'subclass_proc!' } }
  
  let( :topclass_block_state ) { ::BlockState.new }
  let( :subclass_block_state ) { ::BlockState.new }
  let( :topclass_block_action ) { _block_state = topclass_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  let( :subclass_block_action ) { _block_state = subclass_block_state ; _block_state.block = ::Proc.new { _block_state.block_ran! } }
  
  let( :topclass_class_binding ) { class_binding_class.new( topclass_bound_container_class, binding_name, & topclass_configuration_proc ) }
  let( :subclass_class_binding ) { class_binding_class.new( subclass_bound_container_class, topclass_class_binding, & subclass_configuration_proc ) }
  
end
