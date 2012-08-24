
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

      binding_instance.required?.should == false
      respond_to?( :some_true_false ).should == true
      method_defined?( :some_true_false ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_true_false ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_true_false.value = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_true_false.value = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_true_false.value = true
    instance.some_true_false.value = false

  end

  ######################
  #  attr_true_falses  #
  ######################

  it 'can define required true_falses' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_true_falses :some_true_falses

      has_binding?( :some_true_falses ).should == true
      binding_instance = __binding__( :some_true_falses )
      binding_instance.required?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_true_falses.value = [ :object, 32, false ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_true_falses.value = Class }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_true_falses.value = true
    instance.some_true_falses.value = false
    instance.some_true_falses.value = [ true, true, false ]
    Proc.new { instance.some_true_falses.value = [ Object, :true_false, true ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  ##############################
  #  attr_required_true_false  #
  ##############################

  it 'can define required true_falses' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_true_false :some_required_true_false

      has_binding?( :some_required_true_false ).should == true
      binding_instance = __binding__( :some_required_true_false )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_true_false.value = [ 42, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_true_false.value = true
    instance.some_required_true_false.value = false
    instance.some_required_true_false.value = nil

  end  

  ###############################
  #  attr_required_true_falses  #
  ###############################

  it 'can define required true_falses' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_true_falses :some_required_true_falses

      has_binding?( :some_required_true_falses ).should == true
      binding_instance = __binding__( :some_required_true_falses )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_true_falses.value = [ 42, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_true_falses.value = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_true_falses.value = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_true_falses.value = true
    instance.some_required_true_falses.value = false
    instance.some_required_true_falses.value = [ true, false ]
    instance.some_required_true_falses.value = nil

  end  

end
