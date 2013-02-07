
require_relative '../../../../../lib/perspective/bindings.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../binding_base/class_binding.rb'

describe ::Perspective::Bindings::BindingTypes::PropertyBindings::ClassBindingBase do

  before :all do
    # test with a generic binding we create
    ::Perspective::Bindings::BindingTypes::PropertyBindings.define_binding_type( :class_binding_test_binding )
  end

  setup_class_binding_tests

  it_behaves_like :class_binding do
    let( :class_binding_class ) do
      ::Perspective::Bindings::BindingTypes::PropertyBindings::ClassBindingTestBinding::ClassBinding
    end
  end

end
