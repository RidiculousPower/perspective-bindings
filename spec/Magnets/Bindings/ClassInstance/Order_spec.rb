
require_relative '../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Order do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Order::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance::Bindings
      extend ::Magnets::Bindings::ClassInstance::Bindings::Binding
      extend ::Magnets::Bindings::ClassInstance::Order
    end
  end

	################
  #  attr_order  #
  ################

  it 'can order bindings in sequence' do
    
    class ::Magnets::Bindings::ClassInstance::Order::Mock
    
      attr_binding :first_binding, :second_binding

    end
    
    Proc.new { ::Magnets::Bindings::ClassInstance::Order::Mock.attr_order :first_binding, :third_binding }.should raise_error( ::Magnets::Bindings::Exception::NoBindingError )

    class ::Magnets::Bindings::ClassInstance::Order::Mock

      attr_binding :third_binding
      
    end

    class ::Magnets::Bindings::ClassInstance::Order::Mock
      
      attr_order :first_binding, :third_binding
      
      __binding_order__.should == [ :first_binding, :third_binding ]

      __binding_order__.insert( 1, :second_binding )

      __binding_order__.should == [ :first_binding, :second_binding, :third_binding ]

      attr_order :third_binding

      __binding_order__.should == [ :third_binding ]
      
      __binding_order__.clear
      attr_unbind :first_binding, :second_binding, :third_binding
    
    end
    
  end

end
