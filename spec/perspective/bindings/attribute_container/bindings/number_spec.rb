
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::Number do

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

      binding_instance.required?.should == false
      respond_to?( :some_number ).should == true
      method_defined?( :some_number ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_number ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_number.value = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_number.value = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_number.value = 42
    instance.some_number.value = 42.0
    instance.some_number.value = Complex( 1, 2 )
    instance.some_number.value = Rational( 2, 3 )

  end

  ##################
  #  attr_numbers  #
  ##################

  it 'can define required numbers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_numbers :some_numbers

      has_binding?( :some_numbers ).should == true
      binding_instance = __binding__( :some_numbers )
      binding_instance.required?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_numbers.value = [ :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_numbers.value = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_numbers.value = 42
    instance.some_numbers.value = 42.0
    instance.some_numbers.value = Complex( 1, 2 )
    instance.some_numbers.value = Rational( 2, 3 )
    instance.some_numbers.value = [ 42, 42.0, Complex( 1, 2 ), Rational( 2, 3 ) ]
    Proc.new { instance.some_numbers.value = [ Rational( 2, 3 ), 42, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  ##########################
  #  attr_required_number  #
  ##########################

  it 'can define required numbers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_number :some_required_number

      has_binding?( :some_required_number ).should == true
      binding_instance = __binding__( :some_required_number )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_number.value = [ 42, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_number.value = 42
    instance.some_required_number.value = 42.0
    instance.some_required_number.value = Complex( 1, 2 )
    instance.some_required_number.value = Rational( 2, 3 )
    instance.some_required_number.value = nil

  end  

  ###########################
  #  attr_required_numbers  #
  ###########################

  it 'can define required numbers' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_numbers :some_required_numbers

      has_binding?( :some_required_numbers ).should == true
      binding_instance = __binding__( :some_required_numbers )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_numbers.value = [ 42, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_numbers.value = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_numbers.value = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_numbers.value = 42
    instance.some_required_numbers.value = 42.0
    instance.some_required_numbers.value = Complex( 1, 2 )
    instance.some_required_numbers.value = Rational( 2, 3 )
    instance.some_required_numbers.value = [ 42, 42.0, Complex( 1, 2 ), Rational( 2, 3 ) ]
    instance.some_required_numbers.value = nil

  end  

end
