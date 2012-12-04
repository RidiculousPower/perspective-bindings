
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingTypeContainer::Bindings::Integer do

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

  ##################
  #  attr_integer  #
  ##################

  it 'can define integers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_integer :some_integer => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_integer )

      binding_instance.__required__?.should == false
      respond_to?( :some_integer ).should == true
      method_defined?( :some_integer ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      __has_binding__?( :some_integer ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_integer.__value__ = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_integer.__value__ = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_integer.__value__ = 42

  end

  ###################
  #  attr_integers  #
  ###################

  it 'can define required integers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_integers :some_integers

      __has_binding__?( :some_integers ).should == true
      binding_instance = __binding__( :some_integers )
      binding_instance.__required__?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_integers.__value__ = [ :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_integers.__value__ = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_integers.__value__ = 42
    instance.some_integers.__value__ = [ 42, 42 ]
    Proc.new { instance.some_integers.__value__ = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  ###########################
  #  attr_required_integer  #
  ###########################

  it 'can define required integers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_integer :some_required_integer

      __has_binding__?( :some_required_integer ).should == true
      binding_instance = __binding__( :some_required_integer )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_integer.__value__ = [ 42, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_integer.__value__ = 42
    instance.some_required_integer.__value__ = nil

  end  

  ############################
  #  attr_required_integers  #
  ############################

  it 'can define required integers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_integers :some_required_integers

      __has_binding__?( :some_required_integers ).should == true
      binding_instance = __binding__( :some_required_integers )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_integers.__value__ = [ 42, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_integers.__value__ = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_integers.__value__ = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_integers.__value__ = [ 42, 42 ]
    instance.some_required_integers.__value__ = 42
    instance.some_required_integers.__value__ = nil

  end  

end
