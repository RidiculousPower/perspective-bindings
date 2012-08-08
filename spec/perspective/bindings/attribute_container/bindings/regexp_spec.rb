
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::Regexp do

  before :all do
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      include ::Perspective::Bindings::Container
      class Container
        include ::Perspective::Bindings::Container
        attr_accessor :content
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  #################
  #  attr_regexp  #
  #################

  it 'can define regexps' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_regexp :some_regexp => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_regexp )

      binding_instance.required?.should == false
      respond_to?( :some_regexp ).should == true
      method_defined?( :some_regexp ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_regexp ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_regexp = [ Object ] }.should raise_error
    Proc.new { instance.some_regexp = Object }.should raise_error
    instance.some_regexp = /regexp/

  end

  ##################
  #  attr_regexps  #
  ##################

  it 'can define required regexps' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_regexps :some_regexps

      has_binding?( :some_regexps ).should == true
      binding_instance = __binding__( :some_regexps )
      binding_instance.required?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_regexps = [ :object, 32 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_regexps = Class }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_regexps = /regexp/
    instance.some_regexps = [ /regexp/, /other/ ]
    Proc.new { instance.some_regexps = [ Object, :regexp ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  ##########################
  #  attr_required_regexp  #
  ##########################

  it 'can define required regexps' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_regexp :some_required_regexp

      has_binding?( :some_required_regexp ).should == true
      binding_instance = __binding__( :some_required_regexp )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_regexp = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_regexp = /regexp/
    instance.some_required_regexp = nil

  end  

  ###########################
  #  attr_required_regexps  #
  ###########################

  it 'can define required regexps' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_regexps :some_required_regexps

      has_binding?( :some_required_regexps ).should == true
      binding_instance = __binding__( :some_required_regexps )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_regexps = [ 42, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_regexps = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_regexps = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_regexps = /regexp/
    instance.some_required_regexps = [ /regexp/, /other/ ]
    instance.some_required_regexps = nil

  end  

end
