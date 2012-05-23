
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Types::TextOrNumber do

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

  #########################
  #  attr_text_or_number  #
  #########################

  it 'can define texts' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_text_or_number :some_text_or_number => ::Magnets::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_text_or_number )

      binding_instance.required?.should == false
      respond_to?( :some_text_or_number ).should == true
      method_defined?( :some_text_or_number ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Magnets::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_text_or_number ).should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_text_or_number = [ Object ] }.should raise_error
    Proc.new { instance.some_text_or_number = Object }.should raise_error
    instance.some_text_or_number = 'text'
    instance.some_text_or_number = :text
    instance.some_text_or_number = 42
    instance.some_text_or_number = 42.0
    instance.some_text_or_number = Rational( 1, 2 )
    instance.some_text_or_number = Complex( 1, 2 )

  end

  ##########################
  #  attr_text_or_numbers  #
  ##########################

  it 'can define required texts' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_text_or_numbers :some_text_or_numbers

      has_binding?( :some_text_or_numbers ).should == true
      binding_instance = __binding__( :some_text_or_numbers )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_text_or_numbers = [ :object, Class ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_text_or_numbers = Class }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_text_or_numbers = 'text'
    instance.some_text_or_numbers = :text
    instance.some_text_or_numbers = [ 'text', :text, 12, 37.0 ]
    instance.some_text_or_numbers = 42
    instance.some_text_or_numbers = 42.0
    instance.some_text_or_numbers = Rational( 1, 2 )
    instance.some_text_or_numbers = Complex( 1, 2 )
    
    Proc.new { instance.some_text_or_numbers = [ Object, :text ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

  end  

  ##################################
  #  attr_required_text_or_number  #
  ##################################

  it 'can define required texts' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_text_or_number :some_required_text_or_number

      has_binding?( :some_required_text_or_number ).should == true
      binding_instance = __binding__( :some_required_text_or_number )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_text_or_number = [ Class, :some_other_value ] }.should raise_error
    instance.some_required_text_or_number = 'text'
    instance.some_required_text_or_number = :text
    instance.some_required_text_or_number = 42
    instance.some_required_text_or_number = 42.0
    instance.some_required_text_or_number = Rational( 1, 2 )
    instance.some_required_text_or_number = Complex( 1, 2 )
    instance.some_required_text_or_number = nil
    
  end  

  ###################################
  #  attr_required_text_or_numbers  #
  ###################################

  it 'can define required texts' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_text_or_numbers :some_required_text_or_numbers

      has_binding?( :some_required_text_or_numbers ).should == true
      binding_instance = __binding__( :some_required_text_or_numbers )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_text_or_numbers = [ Class, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_text_or_numbers = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_text_or_numbers = Object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_text_or_numbers = 'text'
    instance.some_required_text_or_numbers = :text
    instance.some_required_text_or_numbers = [ 'text', :text, 42, 23.0 ]
    instance.some_required_text_or_numbers = 42
    instance.some_required_text_or_numbers = 42.0
    instance.some_required_text_or_numbers = Rational( 1, 2 )
    instance.some_required_text_or_numbers = Complex( 1, 2 )
    instance.some_required_text_or_numbers = nil

  end  

end
