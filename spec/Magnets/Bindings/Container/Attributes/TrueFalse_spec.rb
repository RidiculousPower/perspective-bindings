
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Types::TrueFalse do


  before :all do
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      include ::Magnets::Bindings::Container
      class Container
        include ::Magnets::Bindings::Container
        attr_accessor :content
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

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_true_false :some_true_false => ::Magnets::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_true_false )

      binding_instance.required?.should == false
      respond_to?( :some_true_false ).should == true
      method_defined?( :some_true_false ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Magnets::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_true_false ).should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_true_false = [ Object ] }.should raise_error
    Proc.new { instance.some_true_false = Object }.should raise_error
    instance.some_true_false = true
    instance.some_true_false = false

  end

  ######################
  #  attr_true_falses  #
  ######################

  it 'can define required true_falses' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_true_falses :some_true_falses

      has_binding?( :some_true_falses ).should == true
      binding_instance = __binding__( :some_true_falses )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_true_falses = [ :object, 32, false ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_true_falses = Class }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_true_falses = true
    instance.some_true_falses = false
    instance.some_true_falses = [ true, true, false ]
    Proc.new { instance.some_true_falses = [ Object, :true_false, true ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

  end  

  ##############################
  #  attr_required_true_false  #
  ##############################

  it 'can define required true_falses' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_true_false :some_required_true_false

      has_binding?( :some_required_true_false ).should == true
      binding_instance = __binding__( :some_required_true_false )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_true_false = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_true_false = true
    instance.some_required_true_false = false
    instance.some_required_true_false = nil

  end  

  ###############################
  #  attr_required_true_falses  #
  ###############################

  it 'can define required true_falses' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_true_falses :some_required_true_falses

      has_binding?( :some_required_true_falses ).should == true
      binding_instance = __binding__( :some_required_true_falses )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_true_falses = [ 42, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_true_falses = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_true_falses = Object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_true_falses = true
    instance.some_required_true_falses = false
    instance.some_required_true_falses = [ true, false ]
    instance.some_required_true_falses = nil

  end  

end
