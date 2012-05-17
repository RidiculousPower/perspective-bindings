
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance do
  
  it 'is a module cluster' do
    
    class ::Magnets::Binding::Container::ClassInstance::Mock
      
      extend ::Magnets::Binding::Container::ClassInstance
      
      is_a?( ::Magnets::Binding::Container::ClassInstance::Alias ).should == true
      is_a?( ::Magnets::Binding::Container::ClassInstance::Order ).should == true
      is_a?( ::Magnets::Binding::Container::ClassInstance::Bindings ).should == true
      
    end

  end

end
