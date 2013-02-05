
require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::Container::MultiContainerProxy do

  let( :bound_container ) do
    ::Class.new do
      def self.__root__
        return self
      end
      def self.__root_string__
        return 'root<' << self.to_s << '>'
      end
      def __root__
        return self
      end
      def __root_string__
        return 'root<' << self.to_s << '>'
      end
    end
  end
  let( :bound_container_instance ) { bound_container.new }
  let( :binding_name ) { :binding_name }
  
  let( :class_binding ) do
  end
  let( :binding_container_class ) do
    _bound_container = bound_container
    _binding_name = binding_name
    _bound_container_instance = bound_container_instance
    ::Class.new do
      include ::CascadingConfiguration::Setting
      include ::CascadingConfiguration::Hash
      include ::CascadingConfiguration::Array
      attr_hash :__bindings__, :__binding_aliases__, :__local_aliases_to_bindings__
      attr_array :__configuration_procs__
      attr_setting :__name__
      __name__ = :binding_container_class
      self::Controller.const_set( :ClassBindingMethods, ::Module.new )
      self::Controller.const_set( :InstanceBindingMethods, ::Module.new )
      define_singleton_method( :__bindings__ ) do |*args|
        return @__bindings__ ||= [ __binding__ ]
      end
      define_singleton_method( :__binding__ ) do |*args|
        return @binding ||= ::Perspective::Bindings::BindingTypes::ContainerBindings::Text::
                              ClassBinding.new( _bound_container, _binding_name, self )
      end
      define_singleton_method( :new_nested_instance ) do |parent_binding, *args|
        return new( *args )
      end
      define_method( :__bindings__ ) do |*args|
        return @__bindings__ ||= [ __binding__ ]
      end
      define_method( :__binding__ ) do |*args|
        return @binding ||= ::Perspective::Bindings::BindingTypes::ContainerBindings::Text::
                              InstanceBinding.new( self.class.__binding__, _bound_container_instance )
      end
    end
  end
  let( :multi_container_proxy ) do
    ::Perspective::Bindings::Container::MultiContainerProxy.new( binding_container_class.new.__binding__ )
  end
  
  #before :all do
  #  
  #  class ::Perspective::Bindings::Container::MultiContainerProxy::MockContainer
  #    class View
  #      include ::Perspective::Bindings::Container
  #      attr_text :content
  #    end
  #    include ::Perspective::Bindings::Container
  #    attr_text :some_text, ::Perspective::Bindings::Container::MultiContainerProxy::MockContainer::View
  #  end
  #  
  #end

  #########################
  #  respond_to_missing?  #
  #########################
  
  context '#respond_to_missing?' do
    it 'will respond to any missing method' do
      multi_container_proxy.respond_to_missing?( :any_method, true ).should be true
    end
  end
  
  ####################
  #  method_missing  #
  ####################

  context '#method_missing' do
    before :each do
      multi_container_proxy.instance_eval do
        @__storage_array__ = [ :one, :two, :three ]
      end
    end
    it 'will return an array of results from sending the method to each object in @__storage_array__' do
      multi_container_proxy.to_s.should == [ 'one', 'two', 'three' ]
    end
  end

  ###########
  #  class  #
  ###########

  context '#class' do
    it 'returns its class to avoid confusion - has to be specified explicitly since we proxy everything else' do
      multi_container_proxy.class.should be ::Perspective::Bindings::Container::MultiContainerProxy
    end
  end

  ########################
  #  __parent_binding__  #
  ########################

  context '#__parent_binding__' do
    it 'keeps a reference to its parent binding' do
      multi_container_proxy.__parent_binding__.should be instance_binding
    end
  end

  #########################
  #  __container_class__  #
  #########################

  context '#__container_class__' do
    it 'keeps a reference to its parent binding container class, which is the class of the first existing instance or otherwise of the class specified in the class binding' do
      multi_container_proxy.__container_class__.should be bound_container
    end
  end

  #######################
  #  __storage_array__  # 
  #######################
  
  context '#__storage_array__' do
    it '' do
    end
  end
  
  it 'can be created to contain multiple containers and relay instructions to them' do
    container = ::Perspective::Bindings::Container::MultiContainerProxy::MockContainer.new
    instance = ::Perspective::Bindings::Container::MultiContainerProxy.new( container.__binding__( :some_text ) )
    instance.__parent_binding__.__id__.should == container.__binding__( :some_text ).__id__
    instance.__storage_array__.is_a?( ::Array ).should == true
    instance.__storage_array__.should == [ container.__binding__( :some_text ).__container__ ]
    instance.__container_class__.should == container.__binding__( :some_text ).__container__.class
  end

  
  #####################################
  #  __create_additional_container__  #
  #####################################

  context '#__create_additional_container__' do
    it '' do
    end
  end

  ##################
  #  __autobind__  #
  ##################

  context '#__autobind__' do
    it '' do
    end
  end

  it 'can autobind' do
    container = ::Perspective::Bindings::Container::MultiContainerProxy::MockContainer.new
    instance = ::Perspective::Bindings::Container::MultiContainerProxy.new( container.__binding__( :some_text ) )
    instance.__autobind__( :one , :two , :three, :four )
    instance[ 0 ].content.should == :one
    instance[ 1 ].content.should == :two
    instance[ 2 ].content.should == :three
    instance[ 3 ].content.should == :four
  end

  ##############
  #  autobind  #
  ##############

  context '#autobind' do
    it '' do
    end
  end

  ###############
  #  __count__  #
  ###############

  context '#__count__' do
    it '' do
    end
  end

  ##############
  #  __push__  #
  ##############

  context '#__push__' do
    it '' do
    end
  end

  #############
  #  __pop__  #
  #############

  context '#__pop__' do
    it '' do
    end
  end

  ###############
  #  __shift__  #
  ###############

  context '#__shift__' do
    it '' do
    end
  end

  #################
  #  __unshift__  #
  #################

  context '#__unshift__' do
    it '' do
    end
  end

  #########
  #  []   #
  #  []=  #
  #########

  context '#[], #[]=' do
    it '' do
    end
  end
  
  it 'can return count of views proxied and push/pop/shift/index like an array' do
    container = ::Perspective::Bindings::Container::MultiContainerProxy::MockContainer.new
    instance = ::Perspective::Bindings::Container::MultiContainerProxy.new( container.__binding__( :some_text ) )
    instance.__autobind__( :one, :two, :three, :four )
    instance.__count__.should == 4
    four = instance.__pop__
    instance.__count__.should == 3
    one = instance.__shift__
    instance.__count__.should == 2
    instance.__unshift__( one )
    instance.__count__.should == 3
    instance[ 0 ].should == one
    instance.__push__( four )
    instance.__count__.should == 4
    instance[ 3 ].should == four
  end

end
