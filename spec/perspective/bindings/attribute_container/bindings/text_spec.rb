
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::Text do

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

  ###############
  #  attr_text  #
  ###############

  it 'can define texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_text :some_text => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_text )

      binding_instance.required?.should == false
      respond_to?( :some_text ).should == true
      method_defined?( :some_text ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_text ).should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_text = [ Object ] }.should raise_error
    Proc.new { instance.some_text = Object }.should raise_error
    instance.some_text = 'text'
    instance.some_text = :text

  end

  ################
  #  attr_texts  #
  ################

  it 'can define required texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_texts :some_texts

      has_binding?( :some_texts ).should == true
      binding_instance = __binding__( :some_texts )
      binding_instance.required?.should == false

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_texts = [ :object, 32 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_texts = Class }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_texts = 'text'
    instance.some_texts = :text
    instance.some_texts = [ 'text', :text ]
    Proc.new { instance.some_texts = [ Object, :text ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

  end  

  ########################
  #  attr_required_text  #
  ########################

  it 'can define required texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_text :some_required_text

      has_binding?( :some_required_text ).should == true
      binding_instance = __binding__( :some_required_text )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_text = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_text = 'text'
    instance.some_required_text = :text
    instance.some_required_text = nil

  end  

  #########################
  #  attr_required_texts  #
  #########################

  it 'can define required texts' do

    class ::Perspective::Bindings::Container::ClassInstance::Mock

      attr_required_texts :some_required_texts

      has_binding?( :some_required_texts ).should == true
      binding_instance = __binding__( :some_required_texts )
      binding_instance.required?.should == true

    end

    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_texts = [ 42, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_texts = [ Object, 42 ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_texts = Object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_texts = 'text'
    instance.some_required_texts = :text
    instance.some_required_texts = [ 'text', :text ]
    instance.some_required_texts = nil

  end  

end
