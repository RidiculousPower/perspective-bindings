
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::Number do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock
      include ::Magnets::Bindings
      class View
        include ::Magnets::Bindings
        attr_reader :to_html_node
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

    class ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_number :some_number => ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock::View, & config_proc

      binding_instance = __binding_configuration__( :some_number )

      binding_instance.required?.should == false
      respond_to?( :some_number ).should == true
      method_defined?( :some_number ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock::View

      has_binding?( :some_number ).should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock.new
    Proc.new { instance.some_number = [ Object ] }.should raise_error
    Proc.new { instance.some_number = :some_value }.should raise_error
    instance.some_number = 42
    instance.some_number = 42.0
    instance.some_number = Complex( 1, 2 )
    instance.some_number = Rational( 2, 3 )

    instance.class.__binding_configuration__( :some_number ).__ensure_render_value_valid__( instance.some_number )

    class ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_unbind :some_number

    end

  end

  ##################
  #  attr_numbers  #
  ##################

  it 'can define required numbers' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_numbers :some_numbers

      has_binding?( :some_numbers ).should == true
      binding_instance = __binding_configuration__( :some_numbers )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock.new
    Proc.new { instance.some_numbers = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_numbers = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_numbers = 42
    instance.some_numbers = 42.0
    instance.some_numbers = Complex( 1, 2 )
    instance.some_numbers = Rational( 2, 3 )
    instance.some_numbers = [ 42, 42.0, Complex( 1, 2 ), Rational( 2, 3 ) ]
    Proc.new { instance.some_numbers = [ Rational( 2, 3 ), 42, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.__binding_configuration__( :some_numbers ).__ensure_render_value_valid__( instance.some_numbers )

    class ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_unbind :some_numbers

    end

  end  

  ##########################
  #  attr_required_number  #
  ##########################

  it 'can define required numbers' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_required_number :some_required_number

      has_binding?( :some_required_number ).should == true
      binding_instance = __binding_configuration__( :some_required_number )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock.new
    Proc.new { instance.some_required_number = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_number = 42
    instance.some_required_number = 42.0
    instance.some_required_number = Complex( 1, 2 )
    instance.some_required_number = Rational( 2, 3 )
    instance.some_required_number = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_unbind :some_required_number

    end

  end  

  ###########################
  #  attr_required_numbers  #
  ###########################

  it 'can define required numbers' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_required_numbers :some_required_numbers

      has_binding?( :some_required_numbers ).should == true
      binding_instance = __binding_configuration__( :some_required_numbers )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock.new
    Proc.new { instance.some_required_numbers = [ 42, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_numbers = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_numbers = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_numbers = 42
    instance.some_required_numbers = 42.0
    instance.some_required_numbers = Complex( 1, 2 )
    instance.some_required_numbers = Rational( 2, 3 )
    instance.some_required_numbers = [ 42, 42.0, Complex( 1, 2 ), Rational( 2, 3 ) ]
    instance.some_required_numbers = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_unbind :some_required_numbers

    end

  end  

end
