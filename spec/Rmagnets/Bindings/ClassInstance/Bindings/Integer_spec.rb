
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Integer do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Integer
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Integer
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  ##################
  #  attr_integer  #
  ##################

  it 'can define integers' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_integer :some_integer => ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock::View, & config_proc

      binding_instance = binding_configuration( :some_integer )

      binding_instance.required?.should == false
      respond_to?( :some_integer ).should == true
      instance_methods.include?( :some_integer ).should == true

      binding_instance.configuration_procs[ 0 ][ 0 ].should == config_proc
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock::View

      has_binding?( :some_integer ).should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock.new
    Proc.new { instance.some_integer = [ Object ] }.should raise_error
    Proc.new { instance.some_integer = :some_value }.should raise_error
    instance.some_integer = 42

    instance.class.binding_configuration( :some_integer ).ensure_binding_render_value_valid( instance.some_integer )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_unbind :some_integer

    end

  end

  ###################
  #  attr_integers  #
  ###################

  it 'can define required integers' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_integers :some_integers

      has_binding?( :some_integers ).should == true
      binding_instance = binding_configuration( :some_integers )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock.new
    Proc.new { instance.some_integers = [ :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_integers = :object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_integers = 42
    instance.some_integers = [ 42, 42 ]
    Proc.new { instance.some_integers = [ Object, 42 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.binding_configuration( :some_integers ).ensure_binding_render_value_valid( instance.some_integers )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_unbind :some_integers

    end

  end  

  ###########################
  #  attr_required_integer  #
  ###########################

  it 'can define required integers' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_required_integer :some_required_integer

      has_binding?( :some_required_integer ).should == true
      binding_instance = binding_configuration( :some_required_integer )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock.new
    Proc.new { instance.some_required_integer = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_integer = 42
    instance.some_required_integer = nil
    Proc.new { instance.class.binding_configuration( :some_required_integer ).ensure_binding_render_value_valid( instance.some_required_integer ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_unbind :some_required_integer

    end

  end  

  ############################
  #  attr_required_integers  #
  ############################

  it 'can define required integers' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_required_integers :some_required_integers

      has_binding?( :some_required_integers ).should == true
      binding_instance = binding_configuration( :some_required_integers )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock.new
    Proc.new { instance.some_required_integers = [ 42, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_integers = [ Object, 42 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_integers = :other }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_integers = [ 42, 42 ]
    instance.some_required_integers = 42
    instance.some_required_integers = nil
    Proc.new { instance.class.binding_configuration( :some_required_integers ).ensure_binding_render_value_valid( instance.some_required_integers ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_unbind :some_required_integers

    end

  end  

end
