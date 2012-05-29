
require_relative '../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings do
  
  it 'can cascade definitions' do

    module ::Magnets::Bindings::MockModule
      include ::Magnets::Bindings
      attr_binding :some_binding
      attr_text :some_text
      attr_numbers :some_numbers
    end

    class ::Magnets::Bindings::MockClass
      include ::Magnets::Bindings::MockModule
    end

    module ::Magnets::Bindings::MockModule2
      include ::Magnets::Bindings::MockModule
    end

    class ::Magnets::Bindings::MockClass2
      include ::Magnets::Bindings::MockModule2
    end

    ::Magnets::Bindings::MockModule.has_binding?( :some_binding ).should == true
    ::Magnets::Bindings::MockModule.has_binding?( :some_text ).should == true
    ::Magnets::Bindings::MockModule.has_binding?( :some_numbers ).should == true
    
    ::Magnets::Bindings::MockClass.has_binding?( :some_binding ).should == true
    ::Magnets::Bindings::MockClass.has_binding?( :some_text ).should == true
    ::Magnets::Bindings::MockClass.has_binding?( :some_numbers ).should == true

    ::Magnets::Bindings::MockModule2.has_binding?( :some_binding ).should == true
    ::Magnets::Bindings::MockModule2.has_binding?( :some_text ).should == true
    ::Magnets::Bindings::MockModule2.has_binding?( :some_numbers ).should == true

    ::Magnets::Bindings::MockClass2.has_binding?( :some_binding ).should == true
    ::Magnets::Bindings::MockClass2.has_binding?( :some_text ).should == true
    ::Magnets::Bindings::MockClass2.has_binding?( :some_numbers ).should == true
    
  end

end
