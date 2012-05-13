
require_relative '../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Binding::Definition::TrueFalse do

  ####################################
  #  __ensure_binding_value_valid__  #
  ####################################
  
  it 'can ensure class instances are valid binding objects' do
    class ::Magnets::Bindings::Binding::Definition::TrueFalse::Mock
      include ::Magnets::Bindings::Binding::Definition::TrueFalse
    end
    ::Magnets::Bindings::Binding::Definition::TrueFalse::Mock.new.instance_eval do
      # class
      __ensure_binding_value_valid__( Object ).should == false
      # module
      __ensure_binding_value_valid__( Kernel ).should == false
      # file
      __ensure_binding_value_valid__( File.new( __FILE__ ) ).should == false
      # integer
      __ensure_binding_value_valid__( 42 ).should == false
      # float
      __ensure_binding_value_valid__( 42.0 ).should == false
      # complex
      __ensure_binding_value_valid__( Complex( 1, 2 ) ).should == false
      # rational
      __ensure_binding_value_valid__( Rational( 1, 2 ) ).should == false
      # [ number ] - integer, float, complex, rational
      # regexp
      __ensure_binding_value_valid__( /some_regexp/ ).should == false
      # text
      __ensure_binding_value_valid__( 'string' ).should == false
      __ensure_binding_value_valid__( :symbol ).should == false
      # true_false
      __ensure_binding_value_valid__( true ).should == true
      __ensure_binding_value_valid__( false ).should == true
      # uri
      __ensure_binding_value_valid__( 'http://some.uri' ).should == false
      __ensure_binding_value_valid__( URI.parse( 'http://some.uri' ) ).should == false
      # multiple
      __ensure_binding_value_valid__( [ Object ] ).should == false
    end
  end
  
end