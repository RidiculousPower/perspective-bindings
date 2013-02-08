
require_relative '../../../../../lib/perspective/bindings.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../binding_base/class_binding.rb'

require_relative 'class_binding_setup.rb'
require_relative 'class_binding.rb'

describe ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBindingBase do

  before :all do
    # test with a generic binding we create
    ::Perspective::Bindings::BindingTypes::ContainerBindings.define_binding_type( :class_binding_test_binding )
  end

  setup_container_class_binding_tests

  let( :class_binding_class ) do
    ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBindingTestBinding::ClassBinding
  end

  it_behaves_like :container_class_binding
  
end
