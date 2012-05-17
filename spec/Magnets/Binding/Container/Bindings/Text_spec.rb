
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance::Bindings::Text do

  before :all do
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock
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

  ###############
  #  attr_text  #
  ###############

  it 'can define texts' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_text :some_text => ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock::View, & config_proc

      binding_instance = __binding_configuration__( :some_text )

      binding_instance.required?.should == false
      respond_to?( :some_text ).should == true
      method_defined?( :some_text ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock::View

      has_binding?( :some_text ).should == true

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock.new
    Proc.new { instance.some_text = [ Object ] }.should raise_error
    Proc.new { instance.some_text = Object }.should raise_error
    instance.some_text = 'text'
    instance.some_text = :text

    instance.class.__binding_configuration__( :some_text ).render_value_valid?( instance.some_text )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock

      attr_unbind :some_text

    end

  end

  ################
  #  attr_texts  #
  ################

  it 'can define required texts' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock

      attr_texts :some_texts

      has_binding?( :some_texts ).should == true
      binding_instance = __binding_configuration__( :some_texts )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock.new
    Proc.new { instance.some_texts = [ :object, 32 ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_texts = Class }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    instance.some_texts = 'text'
    instance.some_texts = :text
    instance.some_texts = [ 'text', :text ]
    Proc.new { instance.some_texts = [ Object, :text ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )

    instance.class.__binding_configuration__( :some_texts ).render_value_valid?( instance.some_texts )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock

      attr_unbind :some_texts

    end

  end  

  ########################
  #  attr_required_text  #
  ########################

  it 'can define required texts' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock

      attr_required_text :some_required_text

      has_binding?( :some_required_text ).should == true
      binding_instance = __binding_configuration__( :some_required_text )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock.new
    Proc.new { instance.some_required_text = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_text = 'text'
    instance.some_required_text = :text
    instance.some_required_text = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Binding::Exception::BindingRequired )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock

      attr_unbind :some_required_text

    end

  end  

  #########################
  #  attr_required_texts  #
  #########################

  it 'can define required texts' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock

      attr_required_texts :some_required_texts

      has_binding?( :some_required_texts ).should == true
      binding_instance = __binding_configuration__( :some_required_texts )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock.new
    Proc.new { instance.some_required_texts = [ 42, :other ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_texts = [ Object, 42 ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_texts = Object }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_texts = 'text'
    instance.some_required_texts = :text
    instance.some_required_texts = [ 'text', :text ]
    instance.some_required_texts = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Binding::Exception::BindingRequired )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Text::Mock

      attr_unbind :some_required_texts

    end

  end  

end
