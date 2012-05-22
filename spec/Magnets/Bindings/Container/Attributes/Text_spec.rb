
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Types::Text do

  before :all do
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      include ::Magnets::Bindings::Container
      class Container
        include ::Magnets::Bindings::Container
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

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_text :some_text => ::Magnets::Bindings::Container::ClassInstance::Mock::Container, & config_proc

      binding_instance = __binding__( :some_text )

      binding_instance.required?.should == false
      respond_to?( :some_text ).should == true
      method_defined?( :some_text ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Magnets::Bindings::Container::ClassInstance::Mock::Container

      has_binding?( :some_text ).should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_text = [ Object ] }.should raise_error
    Proc.new { instance.some_text = Object }.should raise_error
    instance.some_text = 'text'
    instance.some_text = :text

    instance.__binding__( :some_text ).render_value_valid?.should == true

  end

  ################
  #  attr_texts  #
  ################

  it 'can define required texts' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_texts :some_texts

      has_binding?( :some_texts ).should == true
      binding_instance = __binding__( :some_texts )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_texts = [ :object, 32 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_texts = Class }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_texts = 'text'
    instance.some_texts = :text
    instance.some_texts = [ 'text', :text ]
    Proc.new { instance.some_texts = [ Object, :text ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.__binding__( :some_texts ).render_value_valid?.should == true

  end  

  ########################
  #  attr_required_text  #
  ########################

  it 'can define required texts' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_text :some_required_text

      has_binding?( :some_required_text ).should == true
      binding_instance = __binding__( :some_required_text )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_text = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_text = 'text'
    instance.some_required_text = :text
    instance.some_required_text = nil

  end  

  #########################
  #  attr_required_texts  #
  #########################

  it 'can define required texts' do

    class ::Magnets::Bindings::Container::ClassInstance::Mock

      attr_required_texts :some_required_texts

      has_binding?( :some_required_texts ).should == true
      binding_instance = __binding__( :some_required_texts )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_texts = [ 42, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_texts = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_texts = Object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_texts = 'text'
    instance.some_required_texts = :text
    instance.some_required_texts = [ 'text', :text ]
    instance.some_required_texts = nil

  end  

end
