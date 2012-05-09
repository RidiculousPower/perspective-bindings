
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::Mixed do
  
  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance::Bindings
      extend ::Magnets::Bindings::ClassInstance::Bindings::Mixed
      class View
        include ::Magnets::Bindings::ObjectInstance
        extend ::Magnets::Bindings::ClassInstance::Bindings
        extend ::Magnets::Bindings::ClassInstance::Bindings::Mixed
        attr_reader :to_html_node
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  ################
  #  attr_mixed  #
  ################

  it 'can define mixeds' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_mixed :some_mixed, ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock::View, :text, :number, & config_proc
      binding_instance = __binding_configuration__( :some_mixed )
      binding_instance.__name__.should == :some_mixed
      binding_instance.text_permitted?.should == true
      binding_instance.number_permitted?.should == true

      binding_instance.class_permitted?.should == false
      binding_instance.module_permitted?.should == false
      binding_instance.integer_permitted?.should == false
      binding_instance.float_permitted?.should == false
      binding_instance.complex_permitted?.should == false
      binding_instance.rational_permitted?.should == false
      binding_instance.regexp_permitted?.should == false
      binding_instance.true_false_permitted?.should == false
      binding_instance.file_permitted?.should == false
      binding_instance.view_permitted?.should == false
      binding_instance.object_permitted?.should == false

      binding_instance.required?.should == false
      respond_to?( :some_mixed ).should == true
      method_defined?( :some_mixed ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock::View

      has_binding?( :some_mixed ).should == true

      attr_mixed :some_mixed_no_view, :text, :number, & config_proc

      binding_instance = __binding_configuration__( :some_mixed_no_view )
      binding_instance.__name__.should == :some_mixed_no_view
      binding_instance.text_permitted?.should == true
      binding_instance.number_permitted?.should == true

      binding_instance.class_permitted?.should == false
      binding_instance.module_permitted?.should == false
      binding_instance.integer_permitted?.should == false
      binding_instance.float_permitted?.should == false
      binding_instance.complex_permitted?.should == false
      binding_instance.rational_permitted?.should == false
      binding_instance.regexp_permitted?.should == false
      binding_instance.true_false_permitted?.should == false
      binding_instance.file_permitted?.should == false
      binding_instance.view_permitted?.should == false
      binding_instance.object_permitted?.should == false

      binding_instance.required?.should == false
      respond_to?( :some_mixed_no_view ).should == true
      method_defined?( :some_mixed_no_view ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == nil

      has_binding?( :some_mixed_no_view ).should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock.new
    Proc.new { instance.some_mixed = [ Object ] }.should raise_error
    Proc.new { instance.some_mixed = Class }.should raise_error
    instance.some_mixed = 42
    instance.some_mixed = 'string'
    instance.some_mixed = :symbol
    instance.some_mixed = nil

    instance.class.__binding_configuration__( :some_mixed ).__ensure_render_value_valid__( instance.some_mixed )

    class ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_unbind :some_mixed, :some_mixed_no_view

    end

  end

  #################
  #  attr_mixeds  #
  #################

  it 'can define required mixeds' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_mixeds :some_mixeds, :text, :number

      has_binding?( :some_mixeds ).should == true
      binding_instance = __binding_configuration__( :some_mixeds )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock.new
    Proc.new { instance.some_mixeds = [ Object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_mixeds = Object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_mixeds = 42
    instance.some_mixeds = [ 42, :symbol, 'string' ]
    Proc.new { instance.some_mixeds = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.__binding_configuration__( :some_mixeds ).__ensure_render_value_valid__( instance.some_mixeds )

    class ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_unbind :some_mixeds

    end

  end  

  #########################
  #  attr_required_mixed  #
  #########################

  it 'can define required mixeds' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_required_mixed :some_required_mixed, :text, :number

      has_binding?( :some_required_mixed ).should == true
      binding_instance = __binding_configuration__( :some_required_mixed )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock.new
    Proc.new { instance.some_required_mixed = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_mixed = 42
    instance.some_required_mixed = 'string'
    instance.some_required_mixed = :symbol
    instance.some_required_mixed = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_mixed ).__ensure_render_value_valid__( instance.some_required_mixed ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_unbind :some_required_mixed

    end

  end  

  ##########################
  #  attr_required_mixeds  #
  ##########################

  it 'can define required mixeds' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_required_mixeds :some_required_mixeds, :text, :number

      has_binding?( :some_required_mixeds ).should == true
      binding_instance = __binding_configuration__( :some_required_mixeds )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock.new
    Proc.new { instance.some_required_mixeds = [ 42, Object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_mixeds = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_mixeds = Object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_mixeds = [ 42, 42 ]
    instance.some_required_mixeds = 42
    instance.some_required_mixeds = 'string'
    instance.some_required_mixeds = :symbol
    instance.some_required_mixeds = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_mixeds ).__ensure_render_value_valid__( instance.some_required_mixeds ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_unbind :some_required_mixeds

    end

  end  
  

end
