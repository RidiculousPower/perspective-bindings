
require_relative '../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Alias do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Order::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Binding
      extend ::Rmagnets::Bindings::ClassInstance::Alias
    end
    class ::Rmagnets::Bindings::ClassInstance::Order::OtherMock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Binding
      extend ::Rmagnets::Bindings::ClassInstance::Alias
    end
  end

  ################
  #  attr_alias  #
  ################
  
  it 'can define binding aliases' do
    
    class ::Rmagnets::Bindings::ClassInstance::Order::Mock
      
      attr_binding :yet_another_binding

    end
    
    Proc.new { Rmagnets::Bindings::ClassInstance::Order::Mock.attr_alias :yet_another_binding, :aliased_binding_name }.should raise_error( ::Rmagnets::Bindings::Exception::NoBindingError )

    class ::Rmagnets::Bindings::ClassInstance::Order::OtherMock
      
      attr_binding :some_other_binding

      has_binding?( :some_other_binding ).should == true
      respond_to?( :some_other_binding ).should == true
      some_other_binding.is_a?( ::Rmagnets::Bindings::Binding::Router ).should == true

    end
    
    class ::Rmagnets::Bindings::ClassInstance::Order::Mock
      
      attr_alias :aliased_binding_name, :yet_another_binding
      attr_binding :another_binding, ::Rmagnets::Bindings::ClassInstance::Order::OtherMock
      attr_alias :some_other_binding, another_binding.some_other_binding
      
      has_binding?( :aliased_binding_name ).should == true
      binding_configuration( :aliased_binding_name ).required?.should == false

      has_binding?( :some_other_binding ).should == true
      binding_configuration( :some_other_binding ).required?.should == false
      respond_to?( :some_other_binding ).should == true
      instance_methods.include?( :some_other_binding ).should == true
      instance_methods.include?( :some_other_binding= ).should == true

      some_other_binding.is_a?( ::Rmagnets::Bindings::Binding::Router ).should == true
      some_other_binding.should == another_binding.some_other_binding

      attr_unbind :yet_another_binding, :some_other_binding, :another_binding
      
    end
    
    class ::Rmagnets::Bindings::ClassInstance::Order::OtherMock
      
      attr_unbind :some_other_binding

    end
    
  end

end
