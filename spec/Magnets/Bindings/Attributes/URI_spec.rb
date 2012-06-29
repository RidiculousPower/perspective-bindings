
require_relative '../../../../lib/magnets/bindings.rb'

describe ::Magnets::Bindings::Attributes::URI do

  ##########################
  #  binding_value_valid?  #
  ##########################
  
  it 'can ensure class instances are valid binding objects' do
    class ::Magnets::Bindings::Attributes::URI::Mock
      include ::Magnets::Bindings::Attributes::URI
    end
    ::Magnets::Bindings::Attributes::URI::Mock.new.instance_eval do
      # class
      binding_value_valid?( Object ).should == false
      # module
      binding_value_valid?( Kernel ).should == false
      # file
      binding_value_valid?( File.new( __FILE__ ) ).should == false
      # integer
      binding_value_valid?( 42 ).should == false
      # float
      binding_value_valid?( 42.0 ).should == false
      # complex
      binding_value_valid?( Complex( 1, 2 ) ).should == false
      # rational
      binding_value_valid?( Rational( 1, 2 ) ).should == false
      # [ number ] - integer, float, complex, rational
      # regexp
      binding_value_valid?( /some_regexp/ ).should == false
      # text
      binding_value_valid?( 'string' ).should == true
      binding_value_valid?( :symbol ).should == false
      # true_false
      binding_value_valid?( true ).should == false
      binding_value_valid?( false ).should == false
      # uri
      binding_value_valid?( 'http://some.uri' ).should == true
      binding_value_valid?( URI.parse( 'http://some.uri' ) ).should == true
      # multiple
      binding_value_valid?( [ Object ] ).should == false
    end
  end
  
end
