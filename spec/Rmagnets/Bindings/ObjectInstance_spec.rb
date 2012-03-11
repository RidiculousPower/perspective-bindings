
require_relative '../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ObjectInstance do

  ################
  #  initialize  #
  ################
  
  it 'can define binding aliases' do
    
    module ::Rmagnets::Bindings::ObjectInstance::Mock
      
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance

      attr_binding :some_binding
      
      class MockClass
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance
        include ::Rmagnets::Bindings::ObjectInstance::Mock
      end
      
      binding_configuration( :some_binding ).should_not == MockClass.binding_configuration( :some_binding )

      class MockClass2 < MockClass
        binding_configuration( :some_binding ).should_not == MockClass.binding_configuration( :some_binding )
      end

      binding_configuration( :some_binding ).should_not == MockClass2.binding_configuration( :some_binding )

      class MockClass
        attr_unbind :some_binding

        attr_binding :other_binding

        attr_accessor :binding_configured
        attr_binding :binding_to_configure do
          @binding_configured = true
          other_binding
          self.other_binding = :another_value
        end
        
        attr_rename :other_binding, :another_name

      end

      attr_unbind :some_binding
      
      
    end
    
    instance = ::Rmagnets::Bindings::ObjectInstance::Mock::MockClass.new
    instance.binding_configured.should == true

    class ::Rmagnets::Bindings::ObjectInstance::Mock::MockClass

      attr_unbind :binding_to_configure

    end
    
  end

end
