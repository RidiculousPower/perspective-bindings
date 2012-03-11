
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Text do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Text
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Text
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

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_text :some_text => ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock::View, & config_proc

      binding_instance = binding_configuration( :some_text )

      binding_instance.required?.should == false
      respond_to?( :some_text ).should == true
      instance_methods.include?( :some_text ).should == true

      binding_instance.configuration_procs[ 0 ].instance_variable_get( :@configuration_proc ).should == config_proc
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock::View

      has_binding?( :some_text ).should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock.new
    Proc.new { instance.some_text = [ Object ] }.should raise_error
    Proc.new { instance.some_text = Object }.should raise_error
    instance.some_text = 'text'
    instance.some_text = :text

    instance.class.binding_configuration( :some_text ).ensure_binding_render_value_valid( instance.some_text )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock

      attr_unbind :some_text

    end

  end

  ################
  #  attr_texts  #
  ################

  it 'can define required texts' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock

      attr_texts :some_texts

      has_binding?( :some_texts ).should == true
      binding_instance = binding_configuration( :some_texts )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock.new
    Proc.new { instance.some_texts = [ :object, 32 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_texts = Class }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_texts = 'text'
    instance.some_texts = :text
    instance.some_texts = [ 'text', :text ]
    Proc.new { instance.some_texts = [ Object, :text ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.binding_configuration( :some_texts ).ensure_binding_render_value_valid( instance.some_texts )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock

      attr_unbind :some_texts

    end

  end  

  ########################
  #  attr_required_text  #
  ########################

  it 'can define required texts' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock

      attr_required_text :some_required_text

      has_binding?( :some_required_text ).should == true
      binding_instance = binding_configuration( :some_required_text )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock.new
    Proc.new { instance.some_required_text = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_text = 'text'
    instance.some_required_text = :text
    instance.some_required_text = nil
    Proc.new { instance.class.binding_configuration( :some_required_text ).ensure_binding_render_value_valid( instance.some_required_text ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock

      attr_unbind :some_required_text

    end

  end  

  #########################
  #  attr_required_texts  #
  #########################

  it 'can define required texts' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock

      attr_required_texts :some_required_texts

      has_binding?( :some_required_texts ).should == true
      binding_instance = binding_configuration( :some_required_texts )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock.new
    Proc.new { instance.some_required_texts = [ 42, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_texts = [ Object, 42 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_texts = Object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_texts = 'text'
    instance.some_required_texts = :text
    instance.some_required_texts = [ 'text', :text ]
    instance.some_required_texts = nil
    Proc.new { instance.class.binding_configuration( :some_required_texts ).ensure_binding_render_value_valid( instance.some_required_texts ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Text::Mock

      attr_unbind :some_required_texts

    end

  end  

end
