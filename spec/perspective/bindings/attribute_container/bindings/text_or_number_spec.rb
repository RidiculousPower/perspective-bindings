
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

      binding_instance.required?.should == false
      respond_to?( :some_text_or_number ).should == true
      method_defined?( :some_text_or_number ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_text_or_number ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_text_or_number.value = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_text_or_number.value = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_text_or_number.value = 'text'
    instance.some_text_or_number.value = :text
    instance.some_text_or_number.value = 42
    instance.some_text_or_number.value = 42.0
    instance.some_text_or_number.value = Rational( 1, 2 )
    instance.some_text_or_number.value = Complex( 1, 2 )

  end

  ##########################
  #  attr_text_or_numbers  #
  ##########################

  it 'can define required texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_text_or_numbers :some_text_or_numbers

      has_binding?( :some_text_or_numbers ).should == true
      binding_instance = __binding__( :some_text_or_numbers )
      binding_instance.required?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_text_or_numbers.value = [ :object, Class ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_text_or_numbers.value = Class }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_text_or_numbers.value = 'text'
    instance.some_text_or_numbers.value = :text
    instance.some_text_or_numbers.value = [ 'text', :text, 12, 37.0 ]
    instance.some_text_or_numbers.value = 42
    instance.some_text_or_numbers.value = 42.0
    instance.some_text_or_numbers.value = Rational( 1, 2 )
    instance.some_text_or_numbers.value = Complex( 1, 2 )
    
    Proc.new { instance.some_text_or_numbers.value = [ Object, :text ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  ##################################
  #  attr_required_text_or_number  #
  ##################################

  it 'can define required texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_text_or_number :some_required_text_or_number

      has_binding?( :some_required_text_or_number ).should == true
      binding_instance = __binding__( :some_required_text_or_number )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_text_or_number.value = [ Class, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_text_or_number.value = 'text'
    instance.some_required_text_or_number.value = :text
    instance.some_required_text_or_number.value = 42
    instance.some_required_text_or_number.value = 42.0
    instance.some_required_text_or_number.value = Rational( 1, 2 )
    instance.some_required_text_or_number.value = Complex( 1, 2 )
    instance.some_required_text_or_number.value = nil
    
  end  

  ###################################
  #  attr_required_text_or_numbers  #
  ###################################

  it 'can define required texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_text_or_numbers :some_required_text_or_numbers

      has_binding?( :some_required_text_or_numbers ).should == true
      binding_instance = __binding__( :some_required_text_or_numbers )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_text_or_numbers.value = [ Class, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_text_or_numbers.value = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_text_or_numbers.value = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_text_or_numbers.value = 'text'
    instance.some_required_text_or_numbers.value = :text
    instance.some_required_text_or_numbers.value = [ 'text', :text, 42, 23.0 ]
    instance.some_required_text_or_numbers.value = 42
    instance.some_required_text_or_numbers.value = 42.0
    instance.some_required_text_or_numbers.value = Rational( 1, 2 )
    instance.some_required_text_or_numbers.value = Complex( 1, 2 )
    instance.some_required_text_or_numbers.value = nil

  end  

end
