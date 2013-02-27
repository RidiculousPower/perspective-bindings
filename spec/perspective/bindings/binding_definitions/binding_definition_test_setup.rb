
require_relative '../../../support/named_class_and_module.rb'

def setup_binding_definition_tests

  let( :binding_definition_class ) do
    binding_definition_class = ::Class.new
    binding_definition_class.name( :BindingDefinitionClass )
    _binding_definition_module = binding_definition_module
    binding_definition_class.class_eval { include _binding_definition_module }
    binding_definition_class
  end
  
  let( :binding_definition_instance ) { binding_definition_class.new } 
  
end
