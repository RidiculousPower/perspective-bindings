require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingBase::NestedInstanceBinding do

  before :all do
    class ::Perspective::Bindings::BindingBase::NestedInstanceBinding::BoundContainerMock
      def self.__root__
        return self
      end
      def self.__root_string__
        return to_s
      end
      def __root__
        return self
      end
      def __root_string__
        return to_s
      end
    end
    class ::Perspective::Bindings::BindingBase::NestedInstanceBinding::ClassBindingMock
      include ::Perspective::Bindings::BindingBase::ClassBinding
    end
    class ::Perspective::Bindings::BindingBase::NestedInstanceBinding::NestedClassBindingMock
      include ::Perspective::Bindings::BindingBase::NestedClassBinding
    end
    class ::Perspective::Bindings::BindingBase::NestedInstanceBinding::InstanceBindingMock
      include ::Perspective::Bindings::BindingBase::InstanceBinding
    end
    class ::Perspective::Bindings::BindingBase::NestedInstanceBinding::NestedInstanceBindingMock
      include ::Perspective::Bindings::BindingBase::NestedInstanceBinding
    end
    @configuration_proc = ::Proc.new { puts 'config!' }
    @bound_container = ::Perspective::Bindings::BindingBase::NestedInstanceBinding::BoundContainerMock
    @bound_container_instance = @bound_container.new
  end
  
  before :each do
    @class_binding = ::Perspective::Bindings::BindingBase::NestedInstanceBinding::ClassBindingMock.new( @bound_container, :binding_name, & @configuration_proc )
    @instance_binding = ::Perspective::Bindings::BindingBase::NestedInstanceBinding::InstanceBindingMock.new( @class_binding, @bound_container_instance )
    @nested_class_binding = ::Perspective::Bindings::BindingBase::NestedInstanceBinding::NestedClassBindingMock.new( @class_binding, :nested_binding_name, & @configuration_proc )
    @nested_instance_binding = ::Perspective::Bindings::BindingBase::NestedInstanceBinding::NestedInstanceBindingMock.new( @nested_class_binding, @instance_binding )
  end

  ######################
  #  __nested_route__  #
  ######################
  
  it 'can calculate the nested route under root' do
    @class_binding.__route_with_name__ = [ ]
    @nested_class_binding.__route_with_name__ = [ :nested, :in, :self, :other_binding_name ]
    @nested_instance_binding.__nested_route__( @instance_binding ).should == [ :nested, :in, :self ]
  end
  
  it 'can calculate the nested route under a nested binding' do
    @class_binding.__route_with_name__ = [ :route, :to, :binding, :binding_name ]
    @nested_class_binding.__route_with_name__ = [ :route, :to, :binding, :binding_name, :nested, :in, :self, :other_binding_name ]
    @nested_instance_binding.__nested_route__( @instance_binding ).should == [ :nested, :in, :self ]
  end
  
  it 'can calculate the nested route under self' do
    @class_binding.__route_with_name__ = [ :route, :to, :binding, :binding_name ]
    @nested_class_binding.__route_with_name__ = [ :route, :to, :binding, :binding_name, :other_binding_name ]
    @nested_instance_binding.__nested_route__( @instance_binding ).should == [ ]
  end
  
  it 'can calculate the nested route under self as root' do
    @class_binding.__route_with_name__ = [ ]
    @nested_class_binding.__route_with_name__ = [ :binding_name ]
    @nested_instance_binding.__nested_route__( @instance_binding ).should == [ ]
  end
  
end
