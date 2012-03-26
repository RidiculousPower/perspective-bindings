
require_relative '../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance do
  
  it 'is a module cluster' do
    
    class ::Rmagnets::Bindings::ClassInstance::Mock
      
      extend ::Rmagnets::Bindings::ClassInstance
      
      is_a?( ::Rmagnets::Bindings::ClassInstance::Alias ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Order ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Binding ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Class ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Complex ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::File ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Float ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Integer ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Module ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Number ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Rational ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Text ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse ).should == true
      is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::View ).should == true
      
    end

  end

end
