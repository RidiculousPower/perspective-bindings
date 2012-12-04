
require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingBase::NestedClassBinding do

  before :all do
    class ::Perspective::Bindings::BindingBase::NestedClassBinding::BoundContainerMock
      def self.__root__
        return self
      end
      def self.__root_string__
        return to_s
      end
    end
    class ::Perspective::Bindings::BindingBase::NestedClassBinding::ClassBindingMock
      include ::Perspective::Bindings::BindingBase::ClassBinding
    end
    class ::Perspective::Bindings::BindingBase::NestedClassBinding::BoundContainerMockSub < ::Perspective::Bindings::BindingBase::NestedClassBinding::BoundContainerMock
    end
    class ::Perspective::Bindings::BindingBase::NestedClassBinding::NestedClassBindingMock
      include ::Perspective::Bindings::BindingBase::NestedClassBinding
    end
    @configuration_proc = ::Proc.new { puts 'config!' }
    @bound_container = ::Perspective::Bindings::BindingBase::NestedClassBinding::BoundContainerMock
    @bound_container_two = ::Perspective::Bindings::BindingBase::NestedClassBinding::BoundContainerMockSub
    @configuration_proc_two = ::Proc.new { puts 'config2!' }
  end
  
  before :each do
    @class_binding = ::Perspective::Bindings::BindingBase::NestedClassBinding::ClassBindingMock.new( @bound_container, :binding_name, & @configuration_proc )
    @nested_class_binding = ::Perspective::Bindings::BindingBase::NestedClassBinding::NestedClassBindingMock.new( @class_binding, :nested_binding_name, & @configuration_proc )
    @class_binding_with_ancestor = ::Perspective::Bindings::BindingBase::NestedClassBinding::ClassBindingMock.new( @bound_container_two, :binding_name, @class_binding, & @configuration_proc_two )
    @nested_class_binding_with_ancestor = ::Perspective::Bindings::BindingBase::NestedClassBinding::NestedClassBindingMock.new( @class_binding_with_ancestor, :nested_binding_name, @nested_class_binding, & @configuration_proc )
  end

  ##############
  #  __root__  #
  ##############
  
  it 'has a root container, which for a nested class binding is the top class binding bound container' do
    @nested_class_binding.__root__.should == @bound_container
  end

  it 'has a root container, which for a nested class binding with an ancestor is the top class binding bound container' do
    @nested_class_binding_with_ancestor.__root__.should == @bound_container_two
  end

  ###############
  #  __route__  #
  ###############

  it 'it has a route, which for a nested class binding is the route from the top class binding bound container' do
    @nested_class_binding.__route__.should == [ :binding_name ]
  end

  it 'it has a route, which for a nested class binding with an ancestor is the route from the top class binding bound container' do
    @nested_class_binding_with_ancestor.__route__.should == [ :binding_name ]
  end

  #########################
  #  __route_with_name__  #
  #########################

  it 'it has a route with name, which for a non-nested class binding is the name' do
    @nested_class_binding.__route_with_name__.should == [ :binding_name, :nested_binding_name ]
  end

  it 'it has a route with name, which for a non-nested class binding with an ancestor is the name' do
    @nested_class_binding_with_ancestor.__route_with_name__.should == [ :binding_name, :nested_binding_name ]
  end

  ######################
  #  __nested_route__  #
  ######################

  it 'can calculate the nested route under root' do
    @class_binding.__route_with_name__ = [ ]
    @nested_class_binding.__route_with_name__ = [ :nested, :in, :self, :other_binding_name ]
    @nested_class_binding.__nested_route__( @class_binding ).should == [ :nested, :in, :self ]
  end
  
  it 'can calculate the nested route under a nested binding' do
    @class_binding.__route_with_name__ = [ :route, :to, :binding, :binding_name ]
    @nested_class_binding.__route_with_name__ = [ :route, :to, :binding, :binding_name, :nested, :in, :self, :other_binding_name ]
    @nested_class_binding.__nested_route__( @class_binding ).should == [ :nested, :in, :self ]
  end
  
  it 'can calculate the nested route under self' do
    @class_binding.__route_with_name__ = [ :route, :to, :binding, :binding_name ]
    @nested_class_binding.__route_with_name__ = [ :route, :to, :binding, :binding_name, :other_binding_name ]
    @nested_class_binding.__nested_route__( @class_binding ).should == [ ]
  end
  
  it 'can calculate the nested route under self as root' do
    @class_binding.__route_with_name__ = [ ]
    @nested_class_binding.__route_with_name__ = [ :binding_name ]
    @nested_class_binding.__nested_route__( @class_binding ).should == [ ]
  end

end
