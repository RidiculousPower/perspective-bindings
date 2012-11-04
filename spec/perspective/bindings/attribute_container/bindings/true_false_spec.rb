
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::TrueFalse do


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

  #####################
  #  attr_true_false  #
  #####################

  it 'can define true_falses' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_true_false :some_true_false => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_true_false )

      binding_instance.__required__?.should == false
      respond_to?( :some_true_false ).should == true
      method_defined?( :some_true_false ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      __has_binding__?( :some_true_false ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_true_false.__value__ = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_true_false.__value__ = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_true_false.__value__ = true
    instance.some_true_false.__value__ = false

  end

  ######################
  #  attr_true_falses  #
  ######################

  it 'can define required true_falses' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_true_falses :some_true_falses

      __has_binding__?( :some_true_falses ).should == true
      binding_instance = __binding__( :some_true_falses )
      binding_instance.__required__?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_true_falses.__value__ = [ :object, 32, false ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_true_falses.__value__ = Class }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_true_falses.__value__ = true
    instance.some_true_falses.__value__ = false
    instance.some_true_falses.__value__ = [ true, true, false ]
    Proc.new { instance.some_true_falses.__value__ = [ Object, :true_false, true ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  ##############################
  #  attr_required_true_false  #
  ##############################

  it 'can define required true_falses' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_true_false :some_required_true_false

      __has_binding__?( :some_required_true_false ).should == true
      binding_instance = __binding__( :some_required_true_false )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_true_false.__value__ = [ 42, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_true_false.__value__ = true
    instance.some_required_true_false.__value__ = false
    instance.some_required_true_false.__value__ = nil

  end  

  ###############################
  #  attr_required_true_falses  #
  ###############################

  it 'can define required true_falses' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_true_falses :some_required_true_falses

      __has_binding__?( :some_required_true_falses ).should == true
      binding_instance = __binding__( :some_required_true_falses )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_true_falses.__value__ = [ 42, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_true_falses.__value__ = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_true_falses.__value__ = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_true_falses.__value__ = true
    instance.some_required_true_falses.__value__ = false
    instance.some_required_true_falses.__value__ = [ true, false ]
    instance.some_required_true_falses.__value__ = nil

  end  

end
