
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp do

  before :all do
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock
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

  #################
  #  attr_regexp  #
  #################

  it 'can define regexps' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_regexp :some_regexp => ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock::View, & config_proc

      binding_instance = __binding_configuration__( :some_regexp )

      binding_instance.required?.should == false
      respond_to?( :some_regexp ).should == true
      method_defined?( :some_regexp ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock::View

      has_binding?( :some_regexp ).should == true

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_regexp = [ Object ] }.should raise_error
    Proc.new { instance.some_regexp = Object }.should raise_error
    instance.some_regexp = /regexp/

    instance.class.__binding_configuration__( :some_regexp ).render_value_valid?( instance.some_regexp )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_regexp

    end

  end

  ##################
  #  attr_regexps  #
  ##################

  it 'can define required regexps' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock

      attr_regexps :some_regexps

      has_binding?( :some_regexps ).should == true
      binding_instance = __binding_configuration__( :some_regexps )
      binding_instance.required?.should == false

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_regexps = [ :object, 32 ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_regexps = Class }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    instance.some_regexps = /regexp/
    instance.some_regexps = [ /regexp/, /other/ ]
    Proc.new { instance.some_regexps = [ Object, :regexp ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )

    instance.class.__binding_configuration__( :some_regexps ).render_value_valid?( instance.some_regexps )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_regexps

    end

  end  

  ##########################
  #  attr_required_regexp  #
  ##########################

  it 'can define required regexps' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock

      attr_required_regexp :some_required_regexp

      has_binding?( :some_required_regexp ).should == true
      binding_instance = __binding_configuration__( :some_required_regexp )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_required_regexp = [ 42, :some_other_value ] }.should raise_error
    instance.some_required_regexp = /regexp/
    instance.some_required_regexp = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Binding::Exception::BindingRequired )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_required_regexp

    end

  end  

  ###########################
  #  attr_required_regexps  #
  ###########################

  it 'can define required regexps' do

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock

      attr_required_regexps :some_required_regexps

      has_binding?( :some_required_regexps ).should == true
      binding_instance = __binding_configuration__( :some_required_regexps )
      binding_instance.required?.should == true

    end

    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock.new
    Proc.new { instance.some_required_regexps = [ 42, :other ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_regexps = [ Object, 42 ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_regexps = Object }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_regexps = /regexp/
    instance.some_required_regexps = [ /regexp/, /other/ ]
    instance.some_required_regexps = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Binding::Exception::BindingRequired )

    class ::Magnets::Binding::Container::ClassInstance::Bindings::Regexp::Mock

      attr_unbind :some_required_regexps

    end

  end  

end
