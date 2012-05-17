
require_relative '../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance::Rename do

  before :all do
    class ::Magnets::Binding::Container::ClassInstance::Rename::Mock
      include ::Magnets::Binding::ObjectInstance
      extend ::Magnets::Binding::Container::ClassInstance::Bindings
      extend ::Magnets::Binding::Container::ClassInstance::Bindings::Binding
      extend ::Magnets::Binding::Container::ClassInstance::Rename
    end
    class ::Magnets::Binding::Container::ClassInstance::Rename::OtherMock
      include ::Magnets::Binding::ObjectInstance
      extend ::Magnets::Binding::Container::ClassInstance::Bindings
      extend ::Magnets::Binding::Container::ClassInstance::Bindings::Binding
      extend ::Magnets::Binding::Container::ClassInstance::Rename
    end
  end

  #################
  #  attr_rename  #
  #################
  
  it 'can define binding aliases' do
    
    class ::Magnets::Binding::Container::ClassInstance::Rename::Mock
      
      attr_binding :some_binding

      has_binding?( :some_binding ).should == true
      has_binding?( :some_binding_view ).should == true
      
      attr_rename :some_binding, :another_name

      has_binding?( :some_binding ).should == false
      has_binding?( :some_binding_view ).should == false

      respond_to?( :some_binding ).should == false
      method_defined?( :some_binding ).should == false
      method_defined?( :some_binding= ).should == false
      respond_to?( :some_binding_view ).should == false
      method_defined?( :some_binding_view ).should == false
      method_defined?( :some_binding_view= ).should == false
      
      has_binding?( :another_name ).should == true
      has_binding?( :another_name_view ).should == true

      respond_to?( :another_name ).should == true
      method_defined?( :another_name ).should == true
      method_defined?( :another_name= ).should == true
      respond_to?( :another_name_view ).should == true
      method_defined?( :another_name_view ).should == true
      method_defined?( :another_name_view= ).should == true

      attr_unbind :another_name
      
    end

  end

end
