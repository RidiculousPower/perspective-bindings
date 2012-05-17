
require_relative '../../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance::Methods::Remove do

  before :all do
    class ::Magnets::Binding::Container::ClassInstance::Methods::Remove::Mock
      extend ::Magnets::Binding::Container::ClassInstance::Methods::Remove
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
    class ::Magnets::Binding::Container::ClassInstance::Methods::Remove::Mock
      respond_to?( :binding_name ).should == true
      method_defined?( :binding_name ).should == true
      method_defined?( :binding_name= ).should == true
      remove_binding_methods( :binding_name )
      respond_to?( :binding_name ).should == false
      method_defined?( :binding_name ).should == false
      method_defined?( :binding_name= ).should == false
    end
  end
  
end
