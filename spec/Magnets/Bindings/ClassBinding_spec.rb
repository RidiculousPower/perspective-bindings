
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassBinding do

  before :all do
    class ::Magnets::Bindings::ClassBinding::ContainerMock
      include ::CascadingConfiguration::Setting
      attr_configuration :__route__
    end
    class ::Magnets::Bindings::ClassBinding::ContainerMock1
      def self.__bindings__
      end
      module ClassBindingMethods
      end
    end
    class ::Magnets::Bindings::ClassBinding::ContainerMock2
      def self.__bindings__
      end
      module ClassBindingMethods
      end
    end
    class ::Magnets::Bindings::ClassBinding::ContainerMock3
      def self.__bindings__
      end
      module ClassBindingMethods
      end
    end
    class ::Magnets::Bindings::ClassBinding::ContainerMock4
      def self.__bindings__
      end
      module ClassBindingMethods
      end
    end
  end

  ###########################################
  #  initialize                             #
  #  __initialize_ancestor_configuration__  #
  #  __initialize_defaults__                #
  #  binding_name_validates?( binding_name )              #
  #  __validate_container_class__           #
  #  __initialize_route__                   #
  #  name                                   #
  #  __name__                               #
  #  container_class                        #
  #  __container_class__                    #
  #  route                                  #
  #  __route__                              #
  #  route_string                           #
  #  __route_string__                       #
  ###########################################

  it 'can initialize, validate parameters, establish its route, register ancestor' do

    ::Magnets::Bindings::ClassBinding.module_eval do
      instance_method( :name ).should == instance_method( :__name__ )
      instance_method( :container_class ).should == instance_method( :__container_class__ )
      instance_method( :route ).should == instance_method( :__route__ )
      instance_method( :route_string ).should == instance_method( :__route_string__ )
    end

    # no container class
    instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name )
    instance.__name__.should == :binding_name
    instance.__container_class__.should == nil
    instance.__route__.should == nil
    instance.__route_string__.should == 'binding_name'

    # with container class
    container_instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name, ::Magnets::Bindings::ClassBinding::ContainerMock1 )
    container_instance.__name__.should == :binding_name
    container_instance.__container_class__.should == ::Magnets::Bindings::ClassBinding::ContainerMock1
    container_instance.__route__.should == nil
    container_instance.__route_string__.should == 'binding_name'

    # with ancestor
    ancestor_instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, nil, nil, container_instance )
    ancestor_instance.__name__.should == :binding_name
    ancestor_instance.__container_class__.should == ::Magnets::Bindings::ClassBinding::ContainerMock1
    ancestor_instance.__route__.should == nil
    ancestor_instance.__route_string__.should == 'binding_name'

    # with container class and ancestor
    container_ancestor_instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, nil, ::Magnets::Bindings::ClassBinding::ContainerMock2, ancestor_instance )
    container_ancestor_instance.__name__.should == :binding_name
    container_ancestor_instance.__container_class__.should == ::Magnets::Bindings::ClassBinding::ContainerMock2
    container_ancestor_instance.__route__.should == nil
    container_ancestor_instance.__route_string__.should == 'binding_name'

  end

  ###################
  #  required?      #
  #  optional?      #
  #  required=      #
  #  __required__=  #
  ###################

  it 'can mark itself as optional or required' do
    ::Magnets::Bindings::ClassBinding.instance_method( :required= ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__required__= )
    instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name )
    instance.required?.should == false
    instance.optional?.should == true
    instance.__required__ = true
    instance.required?.should == true
    instance.optional?.should == false
  end

  #############################
  #  configuration_procs      #
  #  __configuration_procs__  #
  #############################

  it 'keeps track of configuration procs in an inheriting compositing array' do
    ::Magnets::Bindings::ClassBinding.instance_method( :configuration_procs ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__configuration_procs__ )
    instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name )
    instance.__configuration_procs__.is_a?( ::Array ).should == true
  end

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  it 'can add a block to the configuration procs' do
    ::Magnets::Bindings::ClassBinding.instance_method( :configure ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__configure__ )
    instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name )
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
  #  has_binding?  #
  ##################

  it 'can return sub-bindings that define containers nested inside this binding container class' do
    ::Magnets::Bindings::ClassBinding.instance_method( :bindings ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__bindings__ )
    ::Magnets::Bindings::ClassBinding.instance_method( :binding ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__binding__ )
    instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name )
    some_binding_instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :some_binding )
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :some_binding ] = some_binding_instance
    instance.__binding__( :some_binding ).should == some_binding_instance
    instance.has_binding?( :some_binding ).should == true
  end

end
