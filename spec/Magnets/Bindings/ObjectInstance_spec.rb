
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ObjectInstance do

  ################
  #  initialize  #
  ################
  
  it 'can define binding aliases' do
    
    module ::Magnets::Bindings::ObjectInstance::Mock
      
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance

      attr_binding :some_binding
      
      __binding_configurations__[ :some_binding ].should_not == nil
      class MockClass
        extend ::Magnets::Bindings::ClassInstance
        include ::Magnets::Bindings::ObjectInstance::Mock
        __binding_configurations__[ :some_binding ].should_not == nil
        __binding_configurations__[ :some_binding ].should_not == ::Magnets::Bindings::ObjectInstance::Mock.__binding_configuration__( :some_binding )
      end

      __binding_configuration__( :some_binding ).should_not == nil
      MockClass.__binding_configuration__( :some_binding ).should_not == nil
      __binding_configuration__( :some_binding ).should_not == MockClass.__binding_configuration__( :some_binding )

      class MockClass2 < MockClass
        __binding_configuration__( :some_binding ).should_not == nil
        __binding_configuration__( :some_binding ).should_not == MockClass.__binding_configuration__( :some_binding )
      end

      __binding_configuration__( :some_binding ).should_not == MockClass2.__binding_configuration__( :some_binding )

      class MockClass
        attr_unbind :some_binding

        attr_binding :other_binding

        attr_accessor :binding_configured
        attr_binding :binding_to_configure do
          @binding_configured = true
          other_binding
          self.other_binding = :another_value
        end
        
      end

      attr_unbind :some_binding
      
      
    end
    
    instance = ::Magnets::Bindings::ObjectInstance::Mock::MockClass.new
    instance.binding_configured.should == true

    class ::Magnets::Bindings::ObjectInstance::Mock::MockClass

      attr_unbind :binding_to_configure

    end
    
  end

end
