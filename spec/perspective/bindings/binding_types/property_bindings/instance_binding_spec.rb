
require_relative '../../../../../lib/perspective/bindings.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../binding_base/instance_binding.rb'

describe ::Perspective::Bindings::BindingTypes::PropertyBindings::InstanceBindingBase do

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

  #########################
  #  respond_to_missing?  #
  #########################
  
  context '#respond_to_missing?' do
    it 'should not have any keys in non-forwarding-methods' do
      instance_binding_class::NonForwardingMethodsArray.each do |this_key|
        topclass_instance_binding.respond_to_missing?( this_key, true ).should be false
      end
    end
  end
  
  ####################
  #  method_missing  #
  ####################
	
  context '#method_missing' do
  	it 'forwards almost all methods to its value' do
      topclass_instance_binding.respond_to_missing?( :some_other_method, true ).should == true
    end
  end

end
