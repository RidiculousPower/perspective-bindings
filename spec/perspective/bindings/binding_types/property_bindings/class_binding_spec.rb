# -*- encoding : utf-8 -*-

require_relative '../../../../../lib/perspective/bindings.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../binding_base/class_binding.rb'

describe ::Perspective::BindingTypes::PropertyBindings::ClassBinding do

  before :all do
    # test with a generic binding we create
    ::Perspective::BindingTypes::PropertyBindings.define_binding_type( :class_binding_test_binding )
  end

  setup_base_class_binding_tests

  it_behaves_like :base_class_binding do
    let( :class_binding_class ) do
      ::Perspective::BindingTypes::PropertyBindings::ClassBindingTestBinding::ClassBinding
    end
  end

end
