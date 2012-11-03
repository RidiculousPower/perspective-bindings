
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::Float do

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

  ################
  #  attr_float  #
  ################

  it 'can define floats' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_float :some_float => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_float )

      binding_instance.__required__?.should == false
      respond_to?( :some_float ).should == true
      method_defined?( :some_float ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      __has_binding__?( :some_float ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_float.value = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_float.value = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_float.value = 42.0

  end

  #################
  #  attr_floats  #
  #################

  it 'can define required floats' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_floats :some_floats

      __has_binding__?( :some_floats ).should == true
      binding_instance = __binding__( :some_floats )
      binding_instance.__required__?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_floats.value = [ :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_floats.value = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_floats.value = 42.0
    instance.some_floats.value = [ 42.0, 42.0 ]
    Proc.new { instance.some_floats.value = [ Object, 42.0 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  #########################
  #  attr_required_float  #
  #########################

  it 'can define required floats' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_float :some_required_float

      __has_binding__?( :some_required_float ).should == true
      binding_instance = __binding__( :some_required_float )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_float.value = [ 42.0, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_float.value = 42.0
    instance.some_required_float.value = nil

  end  

  ##########################
  #  attr_required_floats  #
  ##########################

  it 'can define required floats' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_floats :some_required_floats

      __has_binding__?( :some_required_floats ).should == true
      binding_instance = __binding__( :some_required_floats )
      binding_instance.__required__?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_floats.value = [ 42.0, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_floats.value = [ Object, 42.0 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_floats.value = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_floats.value = [ 42.0, 42.0 ]
    instance.some_required_floats.value = 42.0
    instance.some_required_floats.value = nil

  end  

end
