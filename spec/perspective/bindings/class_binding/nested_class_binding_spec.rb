
require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::ClassBinding::NestedClassBinding do

  before :all do
    
    class ::Perspective::Bindings::ClassBinding::NestedClassBindingMock < ::Perspective::Bindings::ClassBinding
      include ::Perspective::Bindings::ClassBinding::NestedClassBinding
    end
    
    class ::Perspective::Bindings::ClassBinding::ContainerMock
      include ::CascadingConfiguration::Setting
      attr_configuration :__route__, :__route_with_name__
      def self.__root__
        return self
      end
      def self.__root_string__
        return '[' << self.to_s << ']'
      end
      def self.__bindings__
        return @__bindings__ ||= {}
      end
    end
    class ::Perspective::Bindings::ClassBinding::ContainerMock1
      def self.__bindings__
      end
      module Controller
        module ClassBindingMethods
        end
        module InstanceBindingMethods
        end
      end
    end
    class ::Perspective::Bindings::ClassBinding::ContainerMock2
      def self.__bindings__
      end
      module Controller
        module ClassBindingMethods
        end
        module InstanceBindingMethods
        end
      end
    end
    class ::Perspective::Bindings::ClassBinding::ContainerMock3
      def self.__bindings__
      end
      module Controller
        module ClassBindingMethods
        end
        module InstanceBindingMethods
        end
      end
    end
    class ::Perspective::Bindings::ClassBinding::ContainerMock4
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

  ###########################################
  #  initialize                             #
  #  __initialize_ancestor_configuration__  #
  #  __initialize_defaults__                #
  #  binding_name_validates?                #
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

    nesting_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::ClassBinding::ContainerMock, :nesting_binding_name )

    # no container class
    instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name )
    instance.__name__.should == :binding_name
    instance.__container_class__.should == nil
    instance.__route__.should == [ :nesting_binding_name ]
    instance.__route_string__.should == 'nesting_binding_name::binding_name'

    # with container class
    container_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name, ::Perspective::Bindings::ClassBinding::ContainerMock1 )
    container_instance.__name__.should == :binding_name
    container_instance.__container_class__.should == ::Perspective::Bindings::ClassBinding::ContainerMock1
    instance.__route__.should == [ :nesting_binding_name ]
    container_instance.__route_string__.should == 'nesting_binding_name::binding_name'

    # with ancestor
    ancestor_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, nil, nil, container_instance )
    ancestor_instance.__name__.should == :binding_name
    ancestor_instance.__container_class__.should == ::Perspective::Bindings::ClassBinding::ContainerMock1
    instance.__route__.should == [ :nesting_binding_name ]
    ancestor_instance.__route_string__.should == 'nesting_binding_name::binding_name'

    # with container class and ancestor
    container_ancestor_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, nil, nil, container_instance )
    container_ancestor_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, nil, ::Perspective::Bindings::ClassBinding::ContainerMock2, ancestor_instance )
    container_ancestor_instance.__name__.should == :binding_name
    container_ancestor_instance.__container_class__.should == ::Perspective::Bindings::ClassBinding::ContainerMock2
    instance.__route__.should == [ :nesting_binding_name ]
    container_ancestor_instance.__route_string__.should == 'nesting_binding_name::binding_name'

    # with base route
    nesting_instance.__route_with_name__ = [ :path, :to, :binding ]
    baseroute_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name, nil, nil )
    baseroute_instance.__name__.should == :binding_name
    baseroute_instance.__container_class__.should == nil
    baseroute_instance.__route__.should == [ :path, :to, :binding ]
    baseroute_instance.__route_string__.should == 'path::to::binding::binding_name'

    # with container class and base route
    nesting_instance.__route_with_name__ = [ :a, :path, :to, :binding ]
    container_baseroute_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name, ::Perspective::Bindings::ClassBinding::ContainerMock3 )    
    container_baseroute_instance.__name__.should == :binding_name
    container_baseroute_instance.__container_class__.should == ::Perspective::Bindings::ClassBinding::ContainerMock3
    container_baseroute_instance.__route__.should == [ :a, :path, :to, :binding ]
    container_baseroute_instance.__route_string__.should == 'a::path::to::binding::binding_name'

    # with ancestor and base route
    nesting_instance.__route_with_name__ = [ :another, :path, :to, :binding ]
    ancestor_baseroute_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, nil, nil, container_baseroute_instance )
    ancestor_baseroute_instance.__name__.should == :binding_name
    ancestor_baseroute_instance.__container_class__.should == ::Perspective::Bindings::ClassBinding::ContainerMock3
    ancestor_baseroute_instance.__route__.should == [ :another, :path, :to, :binding ]
    ancestor_baseroute_instance.__route_string__.should == 'another::path::to::binding::binding_name'

    # with container class, ancestor and base route
    nesting_instance.__route_with_name__ = [ :some, :other, :path, :to, :binding ]
    container_ancestor_baseroute_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, nil, ::Perspective::Bindings::ClassBinding::ContainerMock4, ancestor_baseroute_instance )
    container_ancestor_baseroute_instance.__name__.should == :binding_name
    container_ancestor_baseroute_instance.__container_class__.should == ::Perspective::Bindings::ClassBinding::ContainerMock4
    container_ancestor_baseroute_instance.__route__.should == [ :some, :other, :path, :to, :binding ]
    container_ancestor_baseroute_instance.__route_string__.should == 'some::other::path::to::binding::binding_name'

  end

  ######################
  #  nested_route      #
  #  __nested_route__  #
  ######################

  it 'it can calculate the nested route from one container to another nested inside it' do

    ::Perspective::Bindings::ClassBinding::NestedClassBinding.instance_method( :nested_route ).should == ::Perspective::Bindings::ClassBinding::NestedClassBinding.instance_method( :__nested_route__ )

    nesting_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::ClassBinding::ContainerMock, :nesting_binding_name )

    instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name )
    nested_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name )

    instance.__route_with_name__ = [ :route, :to, :binding, :binding_name ]
    nested_instance.__route_with_name__ = [ :route, :to, :binding, :binding_name, :nested, :in, :self, :other_binding_name ]
    nested_instance.__nested_route__( instance ).should == [ :nested, :in, :self ]

    instance.__route_with_name__ = [ ]
    nested_instance.__route_with_name__ = [ :nested, :in, :self, :other_binding_name ]
    nested_instance.__nested_route__( instance ).should == [ :nested, :in, :self ]

    instance.__route_with_name__ = [ :route, :to, :binding, :binding_name ]
    nested_instance.__route_with_name__ = [ :route, :to, :binding, :binding_name, :other_binding_name ]
    nested_instance.__nested_route__( instance ).should == [ ]

    instance.__route_with_name__ = [ ]
    nested_instance.__route_with_name__ = [ :binding_name ]
    nested_instance.__nested_route__( instance ).should == [ ]

  end

  ###################
  #  required?      #
  #  optional?      #
  #  required=      #
  #  __required__=  #
  ###################

  it 'can mark itself as optional or required' do

    nesting_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::ClassBinding::ContainerMock, :nesting_binding_name )

    instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name )
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
    nesting_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::ClassBinding::ContainerMock, :nesting_binding_name )
    instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name )
    instance.__configuration_procs__.is_a?( ::Array ).should == true
  end

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  it 'can add a block to the configuration procs' do
    nesting_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::ClassBinding::ContainerMock, :nesting_binding_name )
    instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name )
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
    nesting_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::ClassBinding::ContainerMock, :nesting_binding_name )
    instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :binding_name )
    some_binding_instance = ::Perspective::Bindings::ClassBinding::NestedClassBindingMock.new( nesting_instance, :some_binding )
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :some_binding ] = some_binding_instance
    instance.__binding__( :some_binding ).should == some_binding_instance
    instance.has_binding?( :some_binding ).should == true
  end

end
