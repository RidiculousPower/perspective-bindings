
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::View do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::View
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::View
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

    class ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock

      config_proc = Proc.new do
        puts 'do some live configuration here'
      end

      attr_view :some_view => ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View, & config_proc

      binding_instance = binding_configuration( :some_view )

      binding_instance.required?.should == false
      respond_to?( :some_view ).should == true
      instance_methods.include?( :some_view ).should == true

      binding_instance.configuration_procs.should == [ config_proc ]
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View

      has_binding?( :some_view ).should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock.new
    Proc.new { instance.some_view = [ Object, ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ] }.should raise_error
    Proc.new { instance.some_view = :some_value }.should raise_error
    instance.some_view = ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new

    instance.class.binding_configuration( :some_view ).ensure_binding_render_value_valid( instance.some_view )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_unbind :some_view

    end

  end

  ################
  #  attr_views  #
  ################

  it 'can define required views' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_views :some_views

      has_binding?( :some_views ).should == true
      binding_instance = binding_configuration( :some_views )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock.new
    Proc.new { instance.some_views = [ :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_views = :object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_views = ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new
    instance.some_views = [ ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new, ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ]
    Proc.new { instance.some_views = [ Object, ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )

    instance.class.binding_configuration( :some_views ).ensure_binding_render_value_valid( instance.some_views )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_unbind :some_views

    end

  end  

  ########################
  #  attr_required_view  #
  ########################

  it 'can define required views' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_required_view :some_required_view

      has_binding?( :some_required_view ).should == true
      binding_instance = binding_configuration( :some_required_view )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock.new
    Proc.new { instance.some_required_view = [ ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new, :some_other_value ] }.should raise_error
    instance.some_required_view = ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new
    instance.some_required_view = nil
    Proc.new { instance.class.binding_configuration( :some_required_view ).ensure_binding_render_value_valid( instance.some_required_view ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_unbind :some_required_view

    end

  end  

  #########################
  #  attr_required_views  #
  #########################

  it 'can define required views' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_required_views :some_required_views

      has_binding?( :some_required_views ).should == true
      binding_instance = binding_configuration( :some_required_views )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end

    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock.new
    Proc.new { instance.some_required_views = [ ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_views = [ Object, ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_views = :other }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_views = [ ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new, ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new ]
    instance.some_required_views = ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock::View.new
    instance.some_required_views = nil
    Proc.new { instance.class.binding_configuration( :some_required_views ).ensure_binding_render_value_valid( instance.some_required_views ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::ClassInstance::Bindings::View::Mock

      attr_unbind :some_required_views

    end

  end  

end
