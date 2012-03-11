
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse do


  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse
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

    class ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_true_false :some_true_false => ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock::View, & config_proc

      binding_instance = binding_configuration( :some_true_false )

      binding_instance.required?.should == false
      respond_to?( :some_true_false ).should == true
      instance_methods.include?( :some_true_false ).should == true

      binding_instance.configuration_procs[ 0 ][ 0 ].should == config_proc
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock::View

      has_binding?( :some_true_false ).should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock.new
    Proc.new { instance.some_true_false = [ Object ] }.should raise_error
    Proc.new { instance.some_true_false = Object }.should raise_error
    instance.some_true_false = true
    instance.some_true_false = false

    instance.class.binding_configuration( :some_true_false ).ensure_binding_render_value_valid( instance.some_true_false )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock

      attr_unbind :some_true_false

    end

  end

  ######################
  #  attr_true_falses  #
  ######################

  it 'can define required true_falses' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock

      attr_true_falses :some_true_falses

      has_binding?( :some_true_falses ).should == true
      binding_instance = binding_configuration( :some_true_falses )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock.new
    Proc.new { instance.some_true_falses = [ :object, 32, false ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_true_falses = Class }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_true_falses = true
    instance.some_true_falses = false
    instance.some_true_falses = [ true, true, false ]
    Proc.new { instance.some_true_falses = [ Object, :true_false, true ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.binding_configuration( :some_true_falses ).ensure_binding_render_value_valid( instance.some_true_falses )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock

      attr_unbind :some_true_falses

    end

  end  

  ##############################
  #  attr_required_true_false  #
  ##############################

  it 'can define required true_falses' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock

      attr_required_true_false :some_required_true_false

      has_binding?( :some_required_true_false ).should == true
      binding_instance = binding_configuration( :some_required_true_false )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock.new
    Proc.new { instance.some_required_true_false = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_true_false = true
    instance.some_required_true_false = false
    instance.some_required_true_false = nil
    Proc.new { instance.class.binding_configuration( :some_required_true_false ).ensure_binding_render_value_valid( instance.some_required_true_false ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock

      attr_unbind :some_required_true_false

    end

  end  

  ###############################
  #  attr_required_true_falses  #
  ###############################

  it 'can define required true_falses' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock

      attr_required_true_falses :some_required_true_falses

      has_binding?( :some_required_true_falses ).should == true
      binding_instance = binding_configuration( :some_required_true_falses )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock.new
    Proc.new { instance.some_required_true_falses = [ 42, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_true_falses = [ Object, 42 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_true_falses = Object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_true_falses = true
    instance.some_required_true_falses = false
    instance.some_required_true_falses = [ true, false ]
    instance.some_required_true_falses = nil
    Proc.new { instance.class.binding_configuration( :some_required_true_falses ).ensure_binding_render_value_valid( instance.some_required_true_falses ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::TrueFalse::Mock

      attr_unbind :some_required_true_falses

    end

  end  

end
