
require_relative '../../../../../lib/perspective/bindings.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../binding_base/instance_binding.rb'

describe ::Perspective::Bindings::BindingTypes::PropertyBindings::InstanceBinding do

  before :all do
    # test with a generic binding we create
    ::Perspective::Bindings::BindingTypes::PropertyBindings.define_binding_type( :instance_binding_test_binding )
  end

  setup_instance_binding_tests

  let( :class_binding_class ) do
    ::Perspective::Bindings::BindingTypes::PropertyBindings::InstanceBindingTestBinding::ClassBinding
  end
  let( :instance_binding_class ) do
    ::Perspective::Bindings::BindingTypes::PropertyBindings::InstanceBindingTestBinding::InstanceBinding
  end
  
  it_behaves_like :base_instance_binding

end
