
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance::Methods::Alias do

  before :all do
    class ::Magnets::Binding::Container::ClassInstance::Order::Mock
      include ::Magnets::Bindings
      attr_reader :to_html_node
    end
    class ::Magnets::Binding::Container::ClassInstance::Order::OtherMock
      include ::Magnets::Bindings
      attr_reader :to_html_node
    end
  end

  ################
  #  attr_alias  #
  ################
  
  it 'can define binding aliases' do
    
    class ::Magnets::Binding::Container::ClassInstance::Order::Mock
      
      attr_binding :yet_another_binding

    end
    
    Proc.new { ::Magnets::Binding::Container::ClassInstance::Order::Mock.attr_alias :yet_another_binding, :aliased_binding_name }.should raise_error( ::Magnets::Binding::Exception::NoBindingError )

    class ::Magnets::Binding::Container::ClassInstance::Order::OtherMock
      
      attr_binding :some_other_binding

      has_binding?( :some_other_binding ).should == true
      respond_to?( :some_other_binding ).should == true
      some_other_binding.is_a?( ::Magnets::Binding ).should == true

    end
    
    class ::Magnets::Binding::Container::ClassInstance::Order::Mock
      
      attr_alias :aliased_binding_name, :yet_another_binding
      attr_binding :another_binding, ::Magnets::Binding::Container::ClassInstance::Order::OtherMock
      attr_alias :some_other_binding, another_binding.some_other_binding

      has_binding?( :aliased_binding_name ).should == true
      __binding_configuration__( :aliased_binding_name ).required?.should == false

      has_binding?( :some_other_binding ).should == true
      __binding_configuration__( :some_other_binding ).required?.should == false
      respond_to?( :some_other_binding ).should == true
      method_defined?( :some_other_binding ).should == true
      method_defined?( :some_other_binding= ).should == true

      some_other_binding.is_a?( ::Magnets::Binding ).should == true
      some_other_binding.should == another_binding.some_other_binding

      attr_unbind :yet_another_binding, :some_other_binding, :another_binding
      
    end
    
    class ::Magnets::Binding::Container::ClassInstance::Order::OtherMock
      
      attr_unbind :some_other_binding

    end
    
  end

end
