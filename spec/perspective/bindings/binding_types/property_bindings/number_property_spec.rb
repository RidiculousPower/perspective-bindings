
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingTypeContainer::Bindings::Number do

  before :all do
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      include ::Perspective::Bindings::Container
      class Container
        include ::Perspective::Bindings::Container
        attr_binding :content
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  #################
  #  attr_number  #
  #################

  it 'can define numbers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_number :some_number => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_number )

      binding_instance.__required__?.should == false
      respond_to?( :some_number ).should == true
      method_defined?( :some_number ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      __has_binding__?( :some_number ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_number.__value__ = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_number.__value__ = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_number.__value__ = 42
    instance.some_number.__value__ = 42.0
    instance.some_number.__value__ = Complex( 1, 2 )
    instance.some_number.__value__ = Rational( 2, 3 )

  end

  ##################
  #  attr_numbers  #
  ##################

  it 'can define required numbers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_numbers :some_numbers

      __has_binding__?( :some_numbers ).should == true
      binding_instance = __binding__( :some_numbers )
      binding_instance.__required__?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_numbers.__value__ = [ :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_numbers.__value__ = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_numbers.__value__ = 42
    instance.some_numbers.__value__ = 42.0
    instance.some_numbers.__value__ = Complex( 1, 2 )
    instance.some_numbers.__value__ = Rational( 2, 3 )
    instance.some_numbers.__value__ = [ 42, 42.0, Complex( 1, 2 ), Rational( 2, 3 ) ]
    Proc.new { instance.some_numbers.__value__ = [ Rational( 2, 3 ), 42, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  ##########################
  #  attr_required_number  #
  ##########################

  it 'can define required numbers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_number :some_required_number

      __has_binding__?( :some_required_number ).should == true
      binding_instance = __binding__( :some_required_number )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_number.__value__ = [ 42, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_number.__value__ = 42
    instance.some_required_number.__value__ = 42.0
    instance.some_required_number.__value__ = Complex( 1, 2 )
    instance.some_required_number.__value__ = Rational( 2, 3 )
    instance.some_required_number.__value__ = nil

  end  

  ###########################
  #  attr_required_numbers  #
  ###########################

  it 'can define required numbers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_numbers :some_required_numbers

      __has_binding__?( :some_required_numbers ).should == true
      binding_instance = __binding__( :some_required_numbers )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_numbers.__value__ = [ 42, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_numbers.__value__ = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_numbers.__value__ = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_numbers.__value__ = 42
    instance.some_required_numbers.__value__ = 42.0
    instance.some_required_numbers.__value__ = Complex( 1, 2 )
    instance.some_required_numbers.__value__ = Rational( 2, 3 )
    instance.some_required_numbers.__value__ = [ 42, 42.0, Complex( 1, 2 ), Rational( 2, 3 ) ]
    instance.some_required_numbers.__value__ = nil

  end  

end
