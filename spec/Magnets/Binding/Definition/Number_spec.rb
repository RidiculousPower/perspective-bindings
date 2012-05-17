
require_relative '../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Definition::Number do

  ##########################
  #  binding_value_valid?  #
  ##########################
  
  it 'can ensure class instances are valid binding objects' do
    class ::Magnets::Binding::Definition::Number::Mock
      include ::Magnets::Binding::Definition::Number
    end
    ::Magnets::Binding::Definition::Number::Mock.new.instance_eval do
      # class
      binding_value_valid?( Object ).should == false
      # module
      binding_value_valid?( Kernel ).should == false
      # file
      binding_value_valid?( File.new( __FILE__ ) ).should == false
      # integer
      binding_value_valid?( 42 ).should == true
      # float
      binding_value_valid?( 42.0 ).should == true
      # complex
      binding_value_valid?( Complex( 1, 2 ) ).should == true
      # rational
      binding_value_valid?( Rational( 1, 2 ) ).should == true
      # [ number ] - integer, float, complex, rational
      # regexp
      binding_value_valid?( /some_regexp/ ).should == false
      # text
      binding_value_valid?( 'string' ).should == false
      binding_value_valid?( :symbol ).should == false
      # true_false
      binding_value_valid?( true ).should == false
      binding_value_valid?( false ).should == false
      # uri
      binding_value_valid?( 'http://some.uri' ).should == false
      binding_value_valid?( URI.parse( 'http://some.uri' ) ).should == false
      # multiple
      binding_value_valid?( [ Object ] ).should == false
    end
  end
  
end
