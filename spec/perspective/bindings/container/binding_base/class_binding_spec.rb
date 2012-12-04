
require_relative '../../../../lib/perspective/view.rb'

describe ::Perspective::View::Bindings::BindingBase::ClassBinding do

  before :all do
    class ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock
      include ::CascadingConfiguration::Setting
      attr_configuration :__route__
      def self.__root__
        return self
      end
      def self.__root_string__
        return '[' << self.to_s << ']'
      end
    end
    class ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock1
      def self.__bindings__
      end
      module Controller
        module ClassBindingMethods
        end
        module InstanceBindingMethods
        end
      end
    end
    class ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock2
      def self.__bindings__
      end
      module Controller
        module ClassBindingMethods
        end
        module InstanceBindingMethods
        end
      end
    end
    class ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock3
      def self.__bindings__
      end
      module Controller
        module ClassBindingMethods
        end
        module InstanceBindingMethods
        end
      end
    end
    class ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock4
      def self.__bindings__
      end
      module Controller
        module ClassBindingMethods
        end
        module InstanceBindingMethods
        end
      end
    end
  end

  before :all do
    class ::Perspective::View::Bindings::BindingBase::ClassBinding::Mock
      include ::Perspective::Bindings::Container
    end
    class ::Perspective::View::Bindings::BindingBase::ClassBinding::MockView
      include ::Perspective::Bindings::Container
    end
  end
  
  ##################################
  #  initialize                    #
  #  __initialize_defaults__       #
  #  __binding_name_validates__?   #
  #  __validate_container_class__  #
  #  __initialize_route__          #
  #  __name__                      #
  #  __container_class__           #
  #  __route__                     #
  #  __route_string__              #
  ##################################

  it 'can initialize, validate parameters, establish its route, register ancestor' do

    # no container class
    instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock, :binding_name )
    instance.__name__.should == :binding_name
    instance.__container_class__.should == nil
    instance.__route__.should == nil
    instance.__route_string__.should == 'binding_name'

    # with container class
    container_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock, :binding_name, ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock1 )
    container_instance.__name__.should == :binding_name
    container_instance.__container_class__.should == ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock1
    container_instance.__route__.should == nil
    container_instance.__route_string__.should == 'binding_name'

    # with ancestor
    ancestor_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock, nil, nil, container_instance )
    ancestor_instance.__name__.should == :binding_name
    ancestor_instance.__container_class__.should == ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock1
    ancestor_instance.__route__.should == nil
    ancestor_instance.__route_string__.should == 'binding_name'

    # with container class and ancestor
    container_ancestor_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock, nil, ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock2, ancestor_instance )
    container_ancestor_instance.__name__.should == :binding_name
    container_ancestor_instance.__container_class__.should == ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock2
    container_ancestor_instance.__route__.should == nil
    container_ancestor_instance.__route_string__.should == 'binding_name'

  end

  ###################
  #  __required__?  #
  #  __optional__?  #
  #  __required__=  #
  ###################

  it 'can mark itself as optional or required' do
    instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock, :binding_name )
    instance.__required__?.should == false
    instance.__optional__?.should == true
    instance.__required__ = true
    instance.__required__?.should == true
    instance.__optional__?.should == false
  end

  #############################
  #  configuration_procs      #
  #  __configuration_procs__  #
  #############################

  it 'keeps track of configuration procs in an inheriting compositing array' do
    ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :configuration_procs ).should == ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :__configuration_procs__ )
    instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock, :binding_name )
    instance.__configuration_procs__.is_a?( ::Array ).should == true
  end

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  it 'can add a block to the configuration procs' do
    ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :configure ).should == ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :__configure__ )
    instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock, :binding_name )
    config_proc = Proc.new do
      puts 'something'
    end
    instance.__configure__( & config_proc )
    instance.__configuration_procs__[ 0 ].should == config_proc
  end

  ##################
  #  bindings      #
  #  __bindings__  #
  #  binding       #
  #  __binding__   #
  #  __has_binding__?  #
  ##################

  it 'can return sub-bindings that define containers nested inside this binding container class' do
    instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock, :binding_name )
    some_binding_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::ClassBinding::ContainerMock, :some_binding )
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :some_binding ] = some_binding_instance
    instance.__binding__( :some_binding ).should == some_binding_instance
    instance.__has_binding__?( :some_binding ).should == true
  end
  
  ####################
  #  view_class      #
  #  __view_class__  #
  ####################
  
  it 'can refer to its container class as a view' do
    ::Perspective::View::Bindings::BindingBase::ClassBinding.instance_method( :__view_class__ ).should == ::Perspective::View::Bindings::BindingBase::ClassBinding.instance_method( :__container_class__ )
    ::Perspective::View::Bindings::BindingBase::ClassBinding.instance_method( :view_class ).should == ::Perspective::View::Bindings::BindingBase::ClassBinding.instance_method( :__view_class__ )
  end

  ##################################
  #  __validate_container_class__  #
  #  __validate_view_class__       #
  ##################################

  it 'adds a method to validate the view class' do
    instance = ::Perspective::Bindings::BindingTypeContainer::AbstractView::Text.new( ::Perspective::View::Bindings::BindingBase::ClassBinding::Mock, :binding_name )
    
    called_validate_view = false
    instance.define_singleton_method( :__validate_view_class__ ) do |view_class|
      called_validate_view = true
    end
    instance.is_a?( ::Perspective::View::Bindings::BindingBase::ClassBinding ).should == true
    instance.__validate_container_class__( ::Perspective::View::Bindings::BindingBase::ClassBinding::MockView )
    called_validate_view.should == true
  end

end
