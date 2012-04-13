
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::View do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::View::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance::Bindings
      extend ::Magnets::Bindings::ClassInstance::Bindings::View
      class View
        include ::Magnets::Bindings::ObjectInstance
        extend ::Magnets::Bindings::ClassInstance::Bindings
        extend ::Magnets::Bindings::ClassInstance::Bindings::View
        def to_html_node
        end
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  ###############
  #  attr_view  #
  ###############

  it 'can define views' do

    class ::Magnets::Bindings::ClassInstance::Bindings::View::Mock

      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end

      attr_view :some_view => ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View, & config_proc

      binding_instance = __binding_configuration__( :some_view )

      binding_instance.required?.should == false
      respond_to?( :some_view ).should == true
      method_defined?( :some_view ).should == true

      has_binding?( :some_view_view ).should == false
      respond_to?( :some_view_view ).should == false
      method_defined?( :some_view_view ).should == false

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View

      has_binding?( :some_view ).should == true

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::View::Mock.new
    Proc.new { instance.some_view = [ Object, ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ] }.should raise_error
    Proc.new { instance.some_view = Class }.should raise_error
    instance.some_view = ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new

    instance.class.__binding_configuration__( :some_view ).ensure_binding_render_value_valid( instance.some_view )

    class ::Magnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_unbind :some_view

    end

  end

  ################
  #  attr_views  #
  ################

  it 'can define required views' do

    class ::Magnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_views :some_views

      has_binding?( :some_views ).should == true
      binding_instance = __binding_configuration__( :some_views )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

      has_binding?( :some_views_view ).should == false
      respond_to?( :some_views_view ).should == false
      method_defined?( :some_views_view ).should == false

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::View::Mock.new
    Proc.new { instance.some_views = [ Class ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_views = Object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_views = ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new
    instance.some_views = [ ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new, ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ]
    Proc.new { instance.some_views = [ Object, ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.__binding_configuration__( :some_views ).ensure_binding_render_value_valid( instance.some_views )

    class ::Magnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_unbind :some_views

    end

  end  

  ########################
  #  attr_required_view  #
  ########################

  it 'can define required views' do

    class ::Magnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_required_view :some_required_view

      has_binding?( :some_required_view ).should == true
      binding_instance = __binding_configuration__( :some_required_view )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

      has_binding?( :some_required_view_view ).should == false
      respond_to?( :some_required_view_view ).should == false
      method_defined?( :some_required_view_view ).should == false

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::View::Mock.new
    Proc.new { instance.some_required_view = [ ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new, :some_other_value ] }.should raise_error
    instance.some_required_view = ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new
    instance.some_required_view = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_view ).ensure_binding_render_value_valid( instance.some_required_view ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_unbind :some_required_view

    end

  end  

  #########################
  #  attr_required_views  #
  #########################

  it 'can define required views' do

    class ::Magnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_required_views :some_required_views

      has_binding?( :some_required_views ).should == true
      binding_instance = __binding_configuration__( :some_required_views )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

      has_binding?( :some_required_views_view ).should == false
      respond_to?( :some_required_views_view ).should == false
      method_defined?( :some_required_views_view ).should == false

    end

    instance = ::Magnets::Bindings::ClassInstance::Bindings::View::Mock.new
    Proc.new { instance.some_required_views = [ ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new, Class ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_views = [ Object, ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_views = Object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_views = [ ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new, ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ]
    instance.some_required_views = ::Magnets::Bindings::ClassInstance::Bindings::View::Mock::View.new
    instance.some_required_views = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_views ).ensure_binding_render_value_valid( instance.some_required_views ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )

    class ::Magnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_unbind :some_required_views

    end

  end  

end
