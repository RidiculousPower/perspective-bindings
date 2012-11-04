
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::TextOrNumber do

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

  #########################
  #  attr_text_or_number  #
  #########################

  it 'can define texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_text_or_number :some_text_or_number => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_text_or_number )

      binding_instance.__required__?.should == false
      respond_to?( :some_text_or_number ).should == true
      method_defined?( :some_text_or_number ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      __has_binding__?( :some_text_or_number ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_text_or_number.__value__ = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_text_or_number.__value__ = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_text_or_number.__value__ = 'text'
    instance.some_text_or_number.__value__ = :text
    instance.some_text_or_number.__value__ = 42
    instance.some_text_or_number.__value__ = 42.0
    instance.some_text_or_number.__value__ = Rational( 1, 2 )
    instance.some_text_or_number.__value__ = Complex( 1, 2 )

  end

  ##########################
  #  attr_text_or_numbers  #
  ##########################

  it 'can define required texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_text_or_numbers :some_text_or_numbers

      __has_binding__?( :some_text_or_numbers ).should == true
      binding_instance = __binding__( :some_text_or_numbers )
      binding_instance.__required__?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_text_or_numbers.__value__ = [ :object, Class ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_text_or_numbers.__value__ = Class }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_text_or_numbers.__value__ = 'text'
    instance.some_text_or_numbers.__value__ = :text
    instance.some_text_or_numbers.__value__ = [ 'text', :text, 12, 37.0 ]
    instance.some_text_or_numbers.__value__ = 42
    instance.some_text_or_numbers.__value__ = 42.0
    instance.some_text_or_numbers.__value__ = Rational( 1, 2 )
    instance.some_text_or_numbers.__value__ = Complex( 1, 2 )
    
    Proc.new { instance.some_text_or_numbers.__value__ = [ Object, :text ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  ##################################
  #  attr_required_text_or_number  #
  ##################################

  it 'can define required texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_text_or_number :some_required_text_or_number

      __has_binding__?( :some_required_text_or_number ).should == true
      binding_instance = __binding__( :some_required_text_or_number )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_text_or_number.__value__ = [ Class, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_text_or_number.__value__ = 'text'
    instance.some_required_text_or_number.__value__ = :text
    instance.some_required_text_or_number.__value__ = 42
    instance.some_required_text_or_number.__value__ = 42.0
    instance.some_required_text_or_number.__value__ = Rational( 1, 2 )
    instance.some_required_text_or_number.__value__ = Complex( 1, 2 )
    instance.some_required_text_or_number.__value__ = nil
    
  end  

  ###################################
  #  attr_required_text_or_numbers  #
  ###################################

  it 'can define required texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_text_or_numbers :some_required_text_or_numbers

      __has_binding__?( :some_required_text_or_numbers ).should == true
      binding_instance = __binding__( :some_required_text_or_numbers )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_text_or_numbers.__value__ = [ Class, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_text_or_numbers.__value__ = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_text_or_numbers.__value__ = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_text_or_numbers.__value__ = 'text'
    instance.some_required_text_or_numbers.__value__ = :text
    instance.some_required_text_or_numbers.__value__ = [ 'text', :text, 42, 23.0 ]
    instance.some_required_text_or_numbers.__value__ = 42
    instance.some_required_text_or_numbers.__value__ = 42.0
    instance.some_required_text_or_numbers.__value__ = Rational( 1, 2 )
    instance.some_required_text_or_numbers.__value__ = Complex( 1, 2 )
    instance.some_required_text_or_numbers.__value__ = nil

  end  

end
