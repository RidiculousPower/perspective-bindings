
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance::Bindings::Float do

  before :all do
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock
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

  ################
  #  attr_float  #
  ################

  it 'can define floats' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_float :some_float => ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock::View, & config_proc

      binding_instance = __binding_configuration__( :some_float )

      binding_instance.required?.should == false
      respond_to?( :some_float ).should == true
      method_defined?( :some_float ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock::View

      has_binding?( :some_float ).should == true

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock.new
    Proc.new { instance.some_float = [ Object ] }.should raise_error
    Proc.new { instance.some_float = :some_value }.should raise_error
    instance.some_float = 42.0

    instance.class.__binding_configuration__( :some_float ).render_value_valid?( instance.some_float )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock

      attr_unbind :some_float

    end

  end

  #################
  #  attr_floats  #
  #################

  it 'can define required floats' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock

      attr_floats :some_floats

      has_binding?( :some_floats ).should == true
      binding_instance = __binding_configuration__( :some_floats )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock.new
    Proc.new { instance.some_floats = [ :object ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_floats = :object }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    instance.some_floats = 42.0
    instance.some_floats = [ 42.0, 42.0 ]
    Proc.new { instance.some_floats = [ Object, 42.0 ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )

    instance.class.__binding_configuration__( :some_floats ).render_value_valid?( instance.some_floats )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock

      attr_unbind :some_floats

    end

  end  

  #########################
  #  attr_required_float  #
  #########################

  it 'can define required floats' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock

      attr_required_float :some_required_float

      has_binding?( :some_required_float ).should == true
      binding_instance = __binding_configuration__( :some_required_float )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock.new
    Proc.new { instance.some_required_float = [ 42.0, :some_other_value ] }.should raise_error
    instance.some_required_float = 42.0
    instance.some_required_float = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Binding::Exception::BindingRequired )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock

      attr_unbind :some_required_float

    end

  end  

  ##########################
  #  attr_required_floats  #
  ##########################

  it 'can define required floats' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock

      attr_required_floats :some_required_floats

      has_binding?( :some_required_floats ).should == true
      binding_instance = __binding_configuration__( :some_required_floats )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock.new
    Proc.new { instance.some_required_floats = [ 42.0, :other ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_floats = [ Object, 42.0 ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_floats = :other }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_floats = [ 42.0, 42.0 ]
    instance.some_required_floats = 42.0
    instance.some_required_floats = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Binding::Exception::BindingRequired )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Float::Mock

      attr_unbind :some_required_floats

    end

  end  

end
