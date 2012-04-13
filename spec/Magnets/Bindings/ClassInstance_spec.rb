
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance do
  
  it 'is a module cluster' do
    
    class ::Magnets::Bindings::ClassInstance::Mock
      
      extend ::Magnets::Bindings::ClassInstance
      
      is_a?( ::Magnets::Bindings::ClassInstance::Alias ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Order ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Binding ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Class ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Complex ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::File ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Float ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Integer ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Mixed ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Module ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Number ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Rational ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Regexp ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::Text ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::TrueFalse ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings::View ).should == true
      
    end

  end

end
