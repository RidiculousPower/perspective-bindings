
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::Regexp do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance::Bindings
      extend ::Magnets::Bindings::ClassInstance::Bindings::Regexp
      class View
        include ::Magnets::Bindings::ObjectInstance
        extend ::Magnets::Bindings::ClassInstance::Bindings
        extend ::Magnets::Bindings::ClassInstance::Bindings::Regexp
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

    class ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_regexp :some_regexp => ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock::View, & config_proc

      binding_instance = __binding_configuration__( :some_regexp )

      binding_instance.required?.should == false
      respond_to?( :some_regexp ).should == true
      method_defined?( :some_regexp ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock::View

      has_binding?( :some_regexp ).should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_regexp = [ Object ] }.should raise_error
    Proc.new { instance.some_regexp = Object }.should raise_error
    instance.some_regexp = /regexp/

    instance.class.__binding_configuration__( :some_regexp ).ensure_binding_render_value_valid( instance.some_regexp )

    class ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_regexp

    end

  end

  ##################
  #  attr_regexps  #
  ##################

  it 'can define required regexps' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_regexps :some_regexps

      has_binding?( :some_regexps ).should == true
      binding_instance = __binding_configuration__( :some_regexps )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_regexps = [ :object, 32 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_regexps = Class }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_regexps = /regexp/
    instance.some_regexps = [ /regexp/, /other/ ]
    Proc.new { instance.some_regexps = [ Object, :regexp ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.__binding_configuration__( :some_regexps ).ensure_binding_render_value_valid( instance.some_regexps )

    class ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_regexps

    end

  end  

  ##########################
  #  attr_required_regexp  #
  ##########################

  it 'can define required regexps' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_required_regexp :some_required_regexp

      has_binding?( :some_required_regexp ).should == true
      binding_instance = __binding_configuration__( :some_required_regexp )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_required_regexp = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_regexp = /regexp/
    instance.some_required_regexp = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_regexp ).ensure_binding_render_value_valid( instance.some_required_regexp ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_required_regexp

    end

  end  

  ###########################
  #  attr_required_regexps  #
  ###########################

  it 'can define required regexps' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_required_regexps :some_required_regexps

      has_binding?( :some_required_regexps ).should == true
      binding_instance = __binding_configuration__( :some_required_regexps )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_required_regexps = [ 42, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_regexps = [ Object, 42 ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_regexps = Object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_regexps = /regexp/
    instance.some_required_regexps = [ /regexp/, /other/ ]
    instance.some_required_regexps = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_regexps ).ensure_binding_render_value_valid( instance.some_required_regexps ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_required_regexps

    end

  end  

end
