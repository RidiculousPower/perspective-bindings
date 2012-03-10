
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp
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

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      config_proc = Proc.new do
        puts 'do some live configuration here'
      end

      attr_regexp :some_regexp => ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock::View, & config_proc

      binding_instance = binding_configuration( :some_regexp )

      binding_instance.required?.should == false
      respond_to?( :some_regexp ).should == true
      instance_methods.include?( :some_regexp ).should == true

      binding_instance.configuration_procs.should == [ config_proc ]
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock::View

      has_binding?( :some_regexp ).should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_regexp = [ Object ] }.should raise_error
    Proc.new { instance.some_regexp = Object }.should raise_error
    instance.some_regexp = /regexp/

    instance.class.binding_configuration( :some_regexp ).ensure_binding_render_value_valid( instance.some_regexp )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_regexp

    end

  end

  ##################
  #  attr_regexps  #
  ##################

  it 'can define required regexps' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_regexps :some_regexps

      has_binding?( :some_regexps ).should == true
      binding_instance = binding_configuration( :some_regexps )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_regexps = [ :object, 32 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_regexps = Class }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_regexps = /regexp/
    instance.some_regexps = [ /regexp/, /other/ ]
    Proc.new { instance.some_regexps = [ Object, :regexp ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.binding_configuration( :some_regexps ).ensure_binding_render_value_valid( instance.some_regexps )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_regexps

    end

  end  

  ##########################
  #  attr_required_regexp  #
  ##########################

  it 'can define required regexps' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_required_regexp :some_required_regexp

      has_binding?( :some_required_regexp ).should == true
      binding_instance = binding_configuration( :some_required_regexp )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_required_regexp = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_regexp = /regexp/
    instance.some_required_regexp = nil
    Proc.new { instance.class.binding_configuration( :some_required_regexp ).ensure_binding_render_value_valid( instance.some_required_regexp ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_required_regexp

    end

  end  

  ###########################
  #  attr_required_regexps  #
  ###########################

  it 'can define required regexps' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_required_regexps :some_required_regexps

      has_binding?( :some_required_regexps ).should == true
      binding_instance = binding_configuration( :some_required_regexps )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_required_regexps = [ 42, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_regexps = [ Object, 42 ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_regexps = Object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_regexps = /regexp/
    instance.some_required_regexps = [ /regexp/, /other/ ]
    instance.some_required_regexps = nil
    Proc.new { instance.class.binding_configuration( :some_required_regexps ).ensure_binding_render_value_valid( instance.some_required_regexps ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_required_regexps

    end

  end  

end
