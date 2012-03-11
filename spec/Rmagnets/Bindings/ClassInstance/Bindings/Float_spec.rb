
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Float do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Float
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Float
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  ################
  #  attr_float  #
  ################

  it 'can define floats' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_float :some_float => ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock::View, & config_proc

      binding_instance = binding_configuration( :some_float )

      binding_instance.required?.should == false
      respond_to?( :some_float ).should == true
      instance_methods.include?( :some_float ).should == true

      binding_instance.configuration_procs[ 0 ].instance_variable_get( :@configuration_proc ).should == config_proc
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock::View

      has_binding?( :some_float ).should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock.new
    Proc.new { instance.some_float = [ Object ] }.should raise_error
    Proc.new { instance.some_float = :some_value }.should raise_error
    instance.some_float = 42.0

    instance.class.binding_configuration( :some_float ).ensure_binding_render_value_valid( instance.some_float )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock

      attr_unbind :some_float

    end

  end

  #################
  #  attr_floats  #
  #################

  it 'can define required floats' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock

      attr_floats :some_floats

      has_binding?( :some_floats ).should == true
      binding_instance = binding_configuration( :some_floats )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock.new
    Proc.new { instance.some_floats = [ :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_floats = :object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_floats = 42.0
    instance.some_floats = [ 42.0, 42.0 ]
    Proc.new { instance.some_floats = [ Object, 42.0 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.binding_configuration( :some_floats ).ensure_binding_render_value_valid( instance.some_floats )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock

      attr_unbind :some_floats

    end

  end  

  #########################
  #  attr_required_float  #
  #########################

  it 'can define required floats' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock

      attr_required_float :some_required_float

      has_binding?( :some_required_float ).should == true
      binding_instance = binding_configuration( :some_required_float )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock.new
    Proc.new { instance.some_required_float = [ 42.0, :some_other_value ] }.should raise_error
    instance.some_required_float = 42.0
    instance.some_required_float = nil
    Proc.new { instance.class.binding_configuration( :some_required_float ).ensure_binding_render_value_valid( instance.some_required_float ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock

      attr_unbind :some_required_float

    end

  end  

  ##########################
  #  attr_required_floats  #
  ##########################

  it 'can define required floats' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock

      attr_required_floats :some_required_floats

      has_binding?( :some_required_floats ).should == true
      binding_instance = binding_configuration( :some_required_floats )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock.new
    Proc.new { instance.some_required_floats = [ 42.0, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_floats = [ Object, 42.0 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_floats = :other }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_floats = [ 42.0, 42.0 ]
    instance.some_required_floats = 42.0
    instance.some_required_floats = nil
    Proc.new { instance.class.binding_configuration( :some_required_floats ).ensure_binding_render_value_valid( instance.some_required_floats ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Float::Mock

      attr_unbind :some_required_floats

    end

  end  

end
