
require_relative '../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Container::ClassInstance::Rename do

  before :all do
    class ::Magnets::Bindings::Container::ClassInstance::Rename::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::Container::ClassInstance::Bindings
      extend ::Magnets::Bindings::Container::ClassInstance
      extend ::Magnets::Bindings::Container::ClassInstance::Rename
    end
    class ::Magnets::Bindings::Container::ClassInstance::Rename::OtherMock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::Container::ClassInstance::Bindings
      extend ::Magnets::Bindings::Container::ClassInstance
      extend ::Magnets::Bindings::Container::ClassInstance::Rename
    end
  end

  #################
  #  attr_rename  #
  #################
  
  it 'can define binding aliases' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Rename::Mock
      
      attr_binding :some_binding

      has_binding?( :some_binding ).should == true
      has_binding?( :some_binding_container ).should == true
      
      attr_rename :some_binding, :another_name

      has_binding?( :some_binding ).should == false
      has_binding?( :some_binding_container ).should == false

      respond_to?( :some_binding ).should == false
      method_defined?( :some_binding ).should == false
      method_defined?( :some_binding= ).should == false
      respond_to?( :some_binding_container ).should == false
      method_defined?( :some_binding_container ).should == false
      method_defined?( :some_binding_container= ).should == false
      
      has_binding?( :another_name ).should == true
      has_binding?( :another_name_container ).should == true

      respond_to?( :another_name ).should == true
      method_defined?( :another_name ).should == true
      method_defined?( :another_name= ).should == true
      respond_to?( :another_name_container ).should == true
      method_defined?( :another_name_container ).should == true
      method_defined?( :another_name_container= ).should == true

    end

  end

end
