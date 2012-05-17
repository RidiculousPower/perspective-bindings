
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance::Order do

  before :all do
    class ::Magnets::Binding::Container::ClassInstance::Order::Mock
      include ::Magnets::Binding::ObjectInstance
      extend ::Magnets::Binding::Container::ClassInstance::Bindings
      extend ::Magnets::Binding::Container::ClassInstance::Bindings::Binding
      extend ::Magnets::Binding::Container::ClassInstance::Order
    end
  end

	################
  #  attr_order  #
  ################

  it 'can order bindings in sequence' do
    
    class ::Magnets::Binding::Container::ClassInstance::Order::Mock
    
      attr_binding :first_binding, :second_binding

    end
    
    Proc.new { ::Magnets::Binding::Container::ClassInstance::Order::Mock.attr_order :first_binding, :third_binding }.should raise_error( ::Magnets::Binding::Exception::NoBindingError )

    class ::Magnets::Binding::Container::ClassInstance::Order::Mock

      attr_binding :third_binding
      
    end

    class ::Magnets::Binding::Container::ClassInstance::Order::Mock
      
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
