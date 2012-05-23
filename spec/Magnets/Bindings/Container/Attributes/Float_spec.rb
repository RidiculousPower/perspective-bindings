
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Types::Float do

  before :all do
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      include ::Magnets::Bindings::Container
      class Container
        include ::Magnets::Bindings::Container
        attr_accessor :content
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

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_float :some_float => ::Magnets::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_float )

      binding_instance.required?.should == false
      respond_to?( :some_float ).should == true
      method_defined?( :some_float ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Magnets::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_float ).should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_float = [ Object ] }.should raise_error
    Proc.new { instance.some_float = :some_value }.should raise_error
    instance.some_float = 42.0

  end

  #################
  #  attr_floats  #
  #################

  it 'can define required floats' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_floats :some_floats

      has_binding?( :some_floats ).should == true
      binding_instance = __binding__( :some_floats )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_floats = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_floats = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_floats = 42.0
    instance.some_floats = [ 42.0, 42.0 ]
    Proc.new { instance.some_floats = [ Object, 42.0 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

  end  

  #########################
  #  attr_required_float  #
  #########################

  it 'can define required floats' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_float :some_required_float

      has_binding?( :some_required_float ).should == true
      binding_instance = __binding__( :some_required_float )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_float = [ 42.0, :some_other_value ] }.should raise_error
    instance.some_required_float = 42.0
    instance.some_required_float = nil

  end  

  ##########################
  #  attr_required_floats  #
  ##########################

  it 'can define required floats' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_floats :some_required_floats

      has_binding?( :some_required_floats ).should == true
      binding_instance = __binding__( :some_required_floats )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_floats = [ 42.0, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_floats = [ Object, 42.0 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_floats = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_floats = [ 42.0, 42.0 ]
    instance.some_required_floats = 42.0
    instance.some_required_floats = nil

  end  

end
