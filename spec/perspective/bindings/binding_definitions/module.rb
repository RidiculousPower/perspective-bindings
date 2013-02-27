
require_relative 'binding_definition_test_setup.rb'

shared_examples_for :module_container_binding do

  ##############################
  #  __binding_value_valid__?  #
  ##############################

  context '#__binding_value_valid__?' do
    subject { binding_definition_instance.__binding_value_valid__?( value ) }
    context 'when class' do
      let( :value ) { Object }
      it( 'should be false' ) { should be false }
    end
    context 'when module' do
      let( :value ) { Kernel }
      it( 'should be true' ) { should be true }
    end
    context 'when file' do
      let( :value ) { File.new( __FILE__ ) }
      it( 'should be false' ) { should be false }
    end
    context 'when integer' do
      let( :value ) { 42 }
      it( 'should be false' ) { should be false }
    end
    context 'when float' do
      let( :value ) { 42.0 }
      it( 'should be false' ) { should be false }
    end
    context 'when complex' do
      let( :value ) { Complex( 1, 2 ) }
      it( 'should be false' ) { should be false }
    end
    context 'when rational' do
      let( :value ) { Rational( 1, 2 ) }
      it( 'should be false' ) { should be false }
    end
    context 'when regexp' do
      let( :value ) { /some_regexp/ }
      it( 'should be false' ) { should be false }
    end
    context 'when text' do
      context 'when symbol' do
        let( :value ) { :symbol }
        it( 'should be false' ) { should be false }
      end
      context 'when string' do
        let( :value ) { 'string' }
        it( 'should be false' ) { should be false }
      end
    end
    context 'when true_or_false' do
      context 'when true' do
        let( :value ) { true }
        it( 'should be false' ) { should be false }
      end
      context 'when false' do
        let( :value ) { false }
        it( 'should be false' ) { should be false }
      end
    end
    context 'when uri' do
      context 'when string' do
        let( :value ) { 'http://some.uri' }
        it( 'should be false' ) { should be false }
      end
      context 'when URI instance' do
        let( :value ) { URI.parse( 'http://some.uri' ) }
        it( 'should be false' ) { should be false }
      end
    end
  end
  
end

