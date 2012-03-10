
require_relative '../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Order do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Order::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Binding
      extend ::Rmagnets::Bindings::ClassInstance::Order
    end
  end

	################
  #  attr_order  #
  ################

  it 'can order bindings in sequence' do
    
    class ::Rmagnets::Bindings::ClassInstance::Order::Mock
    
      attr_binding :first_binding, :second_binding

    end
    
    Proc.new { ::Rmagnets::Bindings::ClassInstance::Order::Mock.attr_order :first_binding, :third_binding }.should raise_error( ::Rmagnets::Bindings::Exception::NoBindingError )

    class ::Rmagnets::Bindings::ClassInstance::Order::Mock

      attr_binding :third_binding
      
    end

    class ::Rmagnets::Bindings::ClassInstance::Order::Mock
      
      attr_order :first_binding, :third_binding
      
      attr_order.should == [ :first_binding, :third_binding ]

      attr_order.insert( 1, :second_binding )

      attr_order.should == [ :first_binding, :second_binding, :third_binding ]

      attr_order :third_binding

      attr_order.should == [ :third_binding ]
      
      attr_order.clear
      attr_unbind :first_binding, :second_binding, :third_binding
    
    end
    
  end

end
