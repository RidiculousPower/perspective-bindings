
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance do
  
  it 'is a module cluster' do
    
    class ::Magnets::Bindings::ClassInstance::Mock
      
      extend ::Magnets::Bindings::ClassInstance
      
      is_a?( ::Magnets::Bindings::ClassInstance::Alias ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Order ).should == true
      is_a?( ::Magnets::Bindings::ClassInstance::Bindings ).should == true
      
    end

  end

end
