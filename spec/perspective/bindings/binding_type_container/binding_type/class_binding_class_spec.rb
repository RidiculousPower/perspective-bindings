
require_relative '../../../../../lib/perspective/bindings.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../binding_base/class_binding.rb'

describe ::Perspective::Bindings::BindingTypeContainer::BindingType::ClassBindingClass do

  before :all do
    ::Perspective::Bindings::BindingTypes.define_container_type( :test_container ) do
      define_binding_type( :class_binding_test_binding )
    end
  end

  it_behaves_like :class_binding do
    let( :class_binding_class ) do
      ::Perspective::Bindings::BindingTypes::TestContainer::ClassBindingTestBinding::ClassBinding
    end
  end
  
end

