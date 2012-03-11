
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed do
  
  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed
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

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_mixed :some_mixed, ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock::View, :text, :number, & config_proc
      binding_instance = binding_configuration( :some_mixed )
      binding_instance.__binding_name__.should == :some_mixed
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
      instance_methods.include?( :some_mixed ).should == true

      binding_instance.configuration_procs[ 0 ].instance_variable_get( :@configuration_proc ).should == config_proc
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock::View

      has_binding?( :some_mixed ).should == true

      attr_mixed :some_mixed_no_view, :text, :number, & config_proc

      binding_instance = binding_configuration( :some_mixed_no_view )
      binding_instance.__binding_name__.should == :some_mixed_no_view
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
      instance_methods.include?( :some_mixed_no_view ).should == true

      binding_instance.configuration_procs[ 0 ].instance_variable_get( :@configuration_proc ).should == config_proc
      binding_instance.view_class.should == nil

      has_binding?( :some_mixed_no_view ).should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock.new
    Proc.new { instance.some_mixed = [ Object ] }.should raise_error
    Proc.new { instance.some_mixed = Class }.should raise_error
    instance.some_mixed = 42
    instance.some_mixed = 'string'
    instance.some_mixed = :symbol
    instance.some_mixed = nil

    instance.class.binding_configuration( :some_mixed ).ensure_binding_render_value_valid( instance.some_mixed )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_unbind :some_mixed, :some_mixed_no_view

    end

  end

  #################
  #  attr_mixeds  #
  #################

  it 'can define required mixeds' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_mixeds :some_mixeds, :text, :number

      has_binding?( :some_mixeds ).should == true
      binding_instance = binding_configuration( :some_mixeds )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock.new
    Proc.new { instance.some_mixeds = [ Object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_mixeds = Object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_mixeds = 42
    instance.some_mixeds = [ 42, :symbol, 'string' ]
    Proc.new { instance.some_mixeds = [ Object, 42 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.binding_configuration( :some_mixeds ).ensure_binding_render_value_valid( instance.some_mixeds )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_unbind :some_mixeds

    end

  end  

  #########################
  #  attr_required_mixed  #
  #########################

  it 'can define required mixeds' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_required_mixed :some_required_mixed, :text, :number

      has_binding?( :some_required_mixed ).should == true
      binding_instance = binding_configuration( :some_required_mixed )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock.new
    Proc.new { instance.some_required_mixed = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_mixed = 42
    instance.some_required_mixed = 'string'
    instance.some_required_mixed = :symbol
    instance.some_required_mixed = nil
    Proc.new { instance.class.binding_configuration( :some_required_mixed ).ensure_binding_render_value_valid( instance.some_required_mixed ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_unbind :some_required_mixed

    end

  end  

  ##########################
  #  attr_required_mixeds  #
  ##########################

  it 'can define required mixeds' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_required_mixeds :some_required_mixeds, :text, :number

      has_binding?( :some_required_mixeds ).should == true
      binding_instance = binding_configuration( :some_required_mixeds )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock.new
    Proc.new { instance.some_required_mixeds = [ 42, Object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_mixeds = [ Object, 42 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_mixeds = Object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_mixeds = [ 42, 42 ]
    instance.some_required_mixeds = 42
    instance.some_required_mixeds = 'string'
    instance.some_required_mixeds = :symbol
    instance.some_required_mixeds = nil
    Proc.new { instance.class.binding_configuration( :some_required_mixeds ).ensure_binding_render_value_valid( instance.some_required_mixeds ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mixed::Mock

      attr_unbind :some_required_mixeds

    end

  end  
  

end
