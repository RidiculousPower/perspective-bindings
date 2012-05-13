
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::Integer do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock
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

  ##################
  #  attr_integer  #
  ##################

  it 'can define integers' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_integer :some_integer => ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock::View, & config_proc

      binding_instance = __binding_configuration__( :some_integer )

      binding_instance.required?.should == false
      respond_to?( :some_integer ).should == true
      method_defined?( :some_integer ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock::View

      has_binding?( :some_integer ).should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock.new
    Proc.new { instance.some_integer = [ Object ] }.should raise_error
    Proc.new { instance.some_integer = :some_value }.should raise_error
    instance.some_integer = 42

    instance.class.__binding_configuration__( :some_integer ).__ensure_render_value_valid__( instance.some_integer )

    class ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_unbind :some_integer

    end

  end

  ###################
  #  attr_integers  #
  ###################

  it 'can define required integers' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_integers :some_integers

      has_binding?( :some_integers ).should == true
      binding_instance = __binding_configuration__( :some_integers )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock.new
    Proc.new { instance.some_integers = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_integers = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_integers = 42
    instance.some_integers = [ 42, 42 ]
    Proc.new { instance.some_integers = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.__binding_configuration__( :some_integers ).__ensure_render_value_valid__( instance.some_integers )

    class ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_unbind :some_integers

    end

  end  

  ###########################
  #  attr_required_integer  #
  ###########################

  it 'can define required integers' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_required_integer :some_required_integer

      has_binding?( :some_required_integer ).should == true
      binding_instance = __binding_configuration__( :some_required_integer )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock.new
    Proc.new { instance.some_required_integer = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_integer = 42
    instance.some_required_integer = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_unbind :some_required_integer

    end

  end  

  ############################
  #  attr_required_integers  #
  ############################

  it 'can define required integers' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_required_integers :some_required_integers

      has_binding?( :some_required_integers ).should == true
      binding_instance = __binding_configuration__( :some_required_integers )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock.new
    Proc.new { instance.some_required_integers = [ 42, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_integers = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_integers = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_integers = [ 42, 42 ]
    instance.some_required_integers = 42
    instance.some_required_integers = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::Integer::Mock

      attr_unbind :some_required_integers

    end

  end  

end
