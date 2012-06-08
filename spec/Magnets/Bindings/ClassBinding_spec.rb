
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassBinding do

  before :all do
    class ::Magnets::Bindings::ClassBinding::ContainerMock
      def self.__bindings__
        return @__bindings__ ||= { }
      end
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

    ::Magnets::Bindings::ClassBinding.instance_method( :name ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__name__ )
    ::Magnets::Bindings::ClassBinding.instance_method( :container_class ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__container_class__ )
    ::Magnets::Bindings::ClassBinding.instance_method( :route ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__route__ )
    ::Magnets::Bindings::ClassBinding.instance_method( :route_string ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__route_string__ )

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

    # with base route
    baseroute_instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name, nil, nil, [ :path, :to, :binding ] )
    baseroute_instance.__name__.should == :binding_name
    baseroute_instance.__container_class__.should == nil
    baseroute_instance.__route__.should == [ :path, :to, :binding ]
    baseroute_instance.__route_string__.should == 'path-to-binding-binding_name'

    # with container class and base route
    container_baseroute_instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name, ::Magnets::Bindings::ClassBinding::ContainerMock3, nil, [ :a, :path, :to, :binding ] )    
    container_baseroute_instance.__name__.should == :binding_name
    container_baseroute_instance.__container_class__.should == ::Magnets::Bindings::ClassBinding::ContainerMock3
    container_baseroute_instance.__route__.should == [ :a, :path, :to, :binding ]
    container_baseroute_instance.__route_string__.should == 'a-path-to-binding-binding_name'

    # with ancestor and base route
    ancestor_baseroute_instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, nil, nil, container_baseroute_instance, [ :another, :path, :to, :binding ] )
    ancestor_baseroute_instance.__name__.should == :binding_name
    ancestor_baseroute_instance.__container_class__.should == ::Magnets::Bindings::ClassBinding::ContainerMock3
    ancestor_baseroute_instance.__route__.should == [ :another, :path, :to, :binding ]
    ancestor_baseroute_instance.__route_string__.should == 'another-path-to-binding-binding_name'

    # with container class, ancestor and base route
    container_ancestor_baseroute_instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, nil, ::Magnets::Bindings::ClassBinding::ContainerMock4, ancestor_baseroute_instance, [ :some, :other, :path, :to, :binding ] )
    container_ancestor_baseroute_instance.__name__.should == :binding_name
    container_ancestor_baseroute_instance.__container_class__.should == ::Magnets::Bindings::ClassBinding::ContainerMock4
    container_ancestor_baseroute_instance.__route__.should == [ :some, :other, :path, :to, :binding ]
    container_ancestor_baseroute_instance.__route_string__.should == 'some-other-path-to-binding-binding_name'

  end

  ######################
  #  nested_route      #
  #  __nested_route__  #
  ######################

  it 'it can calculate the nested route from one container to another nested inside it' do

    ::Magnets::Bindings::ClassBinding.instance_method( :nested_route ).should == ::Magnets::Bindings::ClassBinding.instance_method( :__nested_route__ )

    instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name )
    nested_instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name )

    instance.__route__ = [ :route, :to, :binding ]
    nested_instance.__route__ = [ :route, :to, :binding, :binding_name, :nested, :in, :self ]
    instance.__nested_route__( nested_instance ).should == [ :nested, :in, :self ]

    instance.__route__ = [ ]
    nested_instance.__route__ = [ :binding_name, :nested, :in, :self ]
    instance.__nested_route__( nested_instance ).should == [ :nested, :in, :self ]

    instance.__route__ = [ :route, :to, :binding ]
    nested_instance.__route__ = [ :route, :to, :binding, :binding_name ]
    instance.__nested_route__( nested_instance ).should == [ ]

    instance.__route__ = [ ]
    nested_instance.__route__ = [ :binding_name ]
    instance.__nested_route__( nested_instance ).should == [ ]

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

  #############################################
  #  __duplicate_as_inheriting_sub_binding__  #
  #############################################

  it 'can duplicate itself for use in a nested context' do
    instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name )
    inheriting_instance = instance.__duplicate_as_inheriting_sub_binding__
    inheriting_instance.__name__.should == instance.__name__
    inheriting_instance.__route__.should == instance.__route__
    instance = ::Magnets::Bindings::ClassBinding.new( ::Magnets::Bindings::ClassBinding::ContainerMock, :binding_name )
    inheriting_instance = instance.__duplicate_as_inheriting_sub_binding__( [ :some, :other, :route ] )
    inheriting_instance.__name__.should == instance.__name__
    inheriting_instance.__route__.should == [ :some, :other, :route ]
  end
      
end
