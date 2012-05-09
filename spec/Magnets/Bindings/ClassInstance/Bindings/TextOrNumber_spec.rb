
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance::Bindings
      extend ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber
      class View
        include ::Magnets::Bindings::ObjectInstance
        extend ::Magnets::Bindings::ClassInstance::Bindings
        extend ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber
        attr_reader :to_html_node
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

    class ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_text_or_number :some_text_or_number => ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock::View, & config_proc

      binding_instance = __binding_configuration__( :some_text_or_number )

      binding_instance.required?.should == false
      respond_to?( :some_text_or_number ).should == true
      method_defined?( :some_text_or_number ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock::View

      has_binding?( :some_text_or_number ).should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock.new
    Proc.new { instance.some_text_or_number = [ Object ] }.should raise_error
    Proc.new { instance.some_text_or_number = Object }.should raise_error
    instance.some_text_or_number = 'text'
    instance.some_text_or_number = :text
    instance.some_text_or_number = 42
    instance.some_text_or_number = 42.0
    instance.some_text_or_number = Rational( 1, 2 )
    instance.some_text_or_number = Complex( 1, 2 )

    instance.class.__binding_configuration__( :some_text_or_number ).__ensure_render_value_valid__( instance.some_text_or_number )

    class ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock

      attr_unbind :some_text_or_number

    end

  end

  ##########################
  #  attr_text_or_numbers  #
  ##########################

  it 'can define required texts' do

    class ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock

      attr_text_or_numbers :some_text_or_numbers

      has_binding?( :some_text_or_numbers ).should == true
      binding_instance = __binding_configuration__( :some_text_or_numbers )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock.new
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

    instance.class.__binding_configuration__( :some_text_or_numbers ).__ensure_render_value_valid__( instance.some_text_or_numbers )

    class ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock

      attr_unbind :some_text_or_numbers

    end

  end  

  ##################################
  #  attr_required_text_or_number  #
  ##################################

  it 'can define required texts' do

    class ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock

      attr_required_text_or_number :some_required_text_or_number

      has_binding?( :some_required_text_or_number ).should == true
      binding_instance = __binding_configuration__( :some_required_text_or_number )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock.new
    Proc.new { instance.some_required_text_or_number = [ Class, :some_other_value ] }.should raise_error
    instance.some_required_text_or_number = 'text'
    instance.some_required_text_or_number = :text
    instance.some_required_text_or_number = 42
    instance.some_required_text_or_number = 42.0
    instance.some_required_text_or_number = Rational( 1, 2 )
    instance.some_required_text_or_number = Complex( 1, 2 )
    instance.some_required_text_or_number = nil
    
    Proc.new { instance.class.__binding_configuration__( :some_required_text_or_number ).__ensure_render_value_valid__( instance.some_required_text_or_number ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock

      attr_unbind :some_required_text_or_number

    end

  end  

  ###################################
  #  attr_required_text_or_numbers  #
  ###################################

  it 'can define required texts' do

    class ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock

      attr_required_text_or_numbers :some_required_text_or_numbers

      has_binding?( :some_required_text_or_numbers ).should == true
      binding_instance = __binding_configuration__( :some_required_text_or_numbers )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock.new
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
    Proc.new { instance.class.__binding_configuration__( :some_required_text_or_numbers ).__ensure_render_value_valid__( instance.some_required_text_or_numbers ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::TextOrNumber::Mock

      attr_unbind :some_required_text_or_numbers

    end

  end  

end
