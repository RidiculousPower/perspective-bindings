
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Number do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Number
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Number
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

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_number :some_number => ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock::View, & config_proc

      binding_instance = binding_configuration( :some_number )

      binding_instance.required?.should == false
      respond_to?( :some_number ).should == true
      instance_methods.include?( :some_number ).should == true

      binding_instance.configuration_procs[ 0 ].instance_variable_get( :@configuration_proc ).should == config_proc
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock::View

      has_binding?( :some_number ).should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock.new
    Proc.new { instance.some_number = [ Object ] }.should raise_error
    Proc.new { instance.some_number = :some_value }.should raise_error
    instance.some_number = 42
    instance.some_number = 42.0
    instance.some_number = Complex( 1, 2 )
    instance.some_number = Rational( 2, 3 )

    instance.class.binding_configuration( :some_number ).ensure_binding_render_value_valid( instance.some_number )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_unbind :some_number

    end

  end

  ##################
  #  attr_numbers  #
  ##################

  it 'can define required numbers' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_numbers :some_numbers

      has_binding?( :some_numbers ).should == true
      binding_instance = binding_configuration( :some_numbers )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock.new
    Proc.new { instance.some_numbers = [ :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_numbers = :object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_numbers = 42
    instance.some_numbers = 42.0
    instance.some_numbers = Complex( 1, 2 )
    instance.some_numbers = Rational( 2, 3 )
    instance.some_numbers = [ 42, 42.0, Complex( 1, 2 ), Rational( 2, 3 ) ]
    Proc.new { instance.some_numbers = [ Rational( 2, 3 ), 42, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.binding_configuration( :some_numbers ).ensure_binding_render_value_valid( instance.some_numbers )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_unbind :some_numbers

    end

  end  

  ##########################
  #  attr_required_number  #
  ##########################

  it 'can define required numbers' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_required_number :some_required_number

      has_binding?( :some_required_number ).should == true
      binding_instance = binding_configuration( :some_required_number )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock.new
    Proc.new { instance.some_required_number = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_number = 42
    instance.some_required_number = 42.0
    instance.some_required_number = Complex( 1, 2 )
    instance.some_required_number = Rational( 2, 3 )
    instance.some_required_number = nil
    Proc.new { instance.class.binding_configuration( :some_required_number ).ensure_binding_render_value_valid( instance.some_required_number ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_unbind :some_required_number

    end

  end  

  ###########################
  #  attr_required_numbers  #
  ###########################

  it 'can define required numbers' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_required_numbers :some_required_numbers

      has_binding?( :some_required_numbers ).should == true
      binding_instance = binding_configuration( :some_required_numbers )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock.new
    Proc.new { instance.some_required_numbers = [ 42, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_numbers = [ Object, 42 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_numbers = :other }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_numbers = 42
    instance.some_required_numbers = 42.0
    instance.some_required_numbers = Complex( 1, 2 )
    instance.some_required_numbers = Rational( 2, 3 )
    instance.some_required_numbers = [ 42, 42.0, Complex( 1, 2 ), Rational( 2, 3 ) ]
    instance.some_required_numbers = nil
    Proc.new { instance.class.binding_configuration( :some_required_numbers ).ensure_binding_render_value_valid( instance.some_required_numbers ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Number::Mock

      attr_unbind :some_required_numbers

    end

  end  

end
