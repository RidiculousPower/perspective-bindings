
require_relative '../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Rename do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Rename::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Binding
      extend ::Rmagnets::Bindings::ClassInstance::Rename
    end
    class ::Rmagnets::Bindings::ClassInstance::Rename::OtherMock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Binding
      extend ::Rmagnets::Bindings::ClassInstance::Rename
    end
  end

  #################
  #  attr_rename  #
  #################
  
  it 'can define binding aliases' do
    
    class ::Rmagnets::Bindings::ClassInstance::Rename::Mock
      
      attr_binding :some_binding

      has_binding?( :some_binding ).should == true
      has_binding?( :some_binding_view ).should == true
      
      attr_rename :some_binding, :another_name

      has_binding?( :some_binding ).should == false
      has_binding?( :some_binding_view ).should == false

      respond_to?( :some_binding ).should == false
      instance_methods.include?( :some_binding ).should == false
      instance_methods.include?( :some_binding= ).should == false
      respond_to?( :some_binding_view ).should == false
      instance_methods.include?( :some_binding_view ).should == false
      instance_methods.include?( :some_binding_view= ).should == false
      
      has_binding?( :another_name ).should == true
      has_binding?( :another_name_view ).should == true

      respond_to?( :another_name ).should == true
      instance_methods.include?( :another_name ).should == true
      instance_methods.include?( :another_name= ).should == true
      respond_to?( :another_name_view ).should == true
      instance_methods.include?( :another_name_view ).should == true
      instance_methods.include?( :another_name_view= ).should == true

      attr_unbind :another_name
      
    end

  end

end
