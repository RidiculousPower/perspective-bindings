
require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::Attributes::TrueFalse do

  ##########################
  #  __binding_value_valid__?  #
  ##########################
  
  it 'can ensure class instances are valid binding objects' do
    class ::Perspective::Bindings::Attributes::TrueFalse::Mock
      include ::Perspective::Bindings::Attributes::TrueFalse
    end
    ::Perspective::Bindings::Attributes::TrueFalse::Mock.new.instance_eval do
      # class
      __binding_value_valid__?( Object ).should == false
      # module
      __binding_value_valid__?( Kernel ).should == false
      # file
      __binding_value_valid__?( File.new( __FILE__ ) ).should == false
      # integer
      __binding_value_valid__?( 42 ).should == false
      # float
      __binding_value_valid__?( 42.0 ).should == false
      # complex
      __binding_value_valid__?( Complex( 1, 2 ) ).should == false
      # rational
      __binding_value_valid__?( Rational( 1, 2 ) ).should == false
      # [ number ] - integer, float, complex, rational
      # regexp
      __binding_value_valid__?( /some_regexp/ ).should == false
      # text
      __binding_value_valid__?( 'string' ).should == false
      __binding_value_valid__?( :symbol ).should == false
      # true_false
      __binding_value_valid__?( true ).should == true
      __binding_value_valid__?( false ).should == true
      # uri
      __binding_value_valid__?( 'http://some.uri' ).should == false
      __binding_value_valid__?( URI.parse( 'http://some.uri' ) ).should == false
      # multiple
      __binding_value_valid__?( [ Object ] ).should == false
    end
  end
  
end
