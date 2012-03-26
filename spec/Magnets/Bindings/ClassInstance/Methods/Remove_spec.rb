
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Remove do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Remove::Mock
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Remove
      def self.binding_name
      end
      def binding_name
      end
      def binding_name=
      end
    end
  end
  
	############################
	#  remove_binding_methods  #
	############################

  it 'can remove the methods defined for a binding' do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Methods::Remove::Mock
      respond_to?( :binding_name ).should == true
      instance_methods.include?( :binding_name ).should == true
      instance_methods.include?( :binding_name= ).should == true
      remove_binding_methods( :binding_name )
      respond_to?( :binding_name ).should == false
      instance_methods.include?( :binding_name ).should == false
      instance_methods.include?( :binding_name= ).should == false
    end
  end
  
end
