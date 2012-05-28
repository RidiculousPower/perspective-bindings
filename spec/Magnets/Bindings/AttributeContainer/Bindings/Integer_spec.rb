
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::AttributeContainer::Bindings::Integer do

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

  ##################
  #  attr_integer  #
  ##################

  it 'can define integers' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_integer :some_integer => ::Magnets::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_integer )

      binding_instance.required?.should == false
      respond_to?( :some_integer ).should == true
      method_defined?( :some_integer ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Magnets::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_integer ).should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_integer = [ Object ] }.should raise_error
    Proc.new { instance.some_integer = :some_value }.should raise_error
    instance.some_integer = 42

  end

  ###################
  #  attr_integers  #
  ###################

  it 'can define required integers' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_integers :some_integers

      has_binding?( :some_integers ).should == true
      binding_instance = __binding__( :some_integers )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_integers = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_integers = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_integers = 42
    instance.some_integers = [ 42, 42 ]
    Proc.new { instance.some_integers = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

  end  

  ###########################
  #  attr_required_integer  #
  ###########################

  it 'can define required integers' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_integer :some_required_integer

      has_binding?( :some_required_integer ).should == true
      binding_instance = __binding__( :some_required_integer )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_integer = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_integer = 42
    instance.some_required_integer = nil

  end  

  ############################
  #  attr_required_integers  #
  ############################

  it 'can define required integers' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_integers :some_required_integers

      has_binding?( :some_required_integers ).should == true
      binding_instance = __binding__( :some_required_integers )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_integers = [ 42, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_integers = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_integers = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_integers = [ 42, 42 ]
    instance.some_required_integers = 42
    instance.some_required_integers = nil

  end  

end
