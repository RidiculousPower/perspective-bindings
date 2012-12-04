
require_relative '../../../../lib/perspective/view.rb'

describe ::Perspective::View::Bindings::BindingBase::InstanceBinding do

  before :all do

    class ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock

      def self.__bindings__
        return @__bindings__ ||= { }
      end
      def self.__route_with_name__
      end

      def self.__root__
        return self
      end
      def self.__root_string__
        return '[' << self.to_s << ']'
      end

      def __root__
        return self
      end
      def __root_string__
        return '[' << self.to_s << ']'
      end

    end

    class ::Perspective::Bindings::BindingBase::InstanceBinding::ContainerMock
    
      class Nested < self
      
        def self.non_nested_class
          return ::Perspective::Bindings::BindingBase::InstanceBinding::ContainerMock
        end
      
        def initialize( parent, *args )
          super( *args )
        end
                
      end

      instances_identify_as!( ::Perspective::Bindings::Container::ObjectInstance )
      identifies_as!( ::Perspective::Bindings::Container::ObjectInstance )

      def self.__bindings__
      end

      def self.__root__
        return self
      end
      def self.__root_string__
        return '[' << self.to_s << ']'
      end

      def __initialize_for_index__( index )
      end

      def __root__
        return self
      end
      def __root_string__
        return '[' << self.to_s << ']'
      end

      attr_accessor :content, :__parent_binding__

      def __autobind__( data_object, hash = nil )
        @content = data_object
        @__called_autobind__ = true
      end
      def __called_autobind__
        called_autobind = @__called_autobind__
        @__called_autobind__ = true
        return called_autobind
      end

      module Controller
        module ClassBindingMethods
        end
        module InstanceBindingMethods
        end
      end
      
      include ::Perspective::Bindings::BindingDefinitions::Text
      
    end

  end
  
  before :all do
    class ::Perspective::View::Bindings::BindingBase::InstanceBinding::Mock
      include ::Perspective::Bindings::Container
    end
  end

  ########################
  #  initialize          #
  #  __parent_binding__  #
  #  __name__            #
  #  __container__       #
  #  __route__           #
  #  __route_string__    #
  ########################

  it 'can initialize as a child of a class binding' do
    class_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::BindingBase::InstanceBinding::ContainerMock )
    instance = ::Perspective::Bindings::BindingBase::InstanceBinding.new( class_instance, ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock.new )
    instance.__parent_binding__.should == class_instance
    instance.__name__.should == class_instance.__name__
    instance.__container__.class.should == class_instance.__container_class__::Nested
    instance.__route__.should == class_instance.__route__
    instance.__route_string__.should == class_instance.__route_string__
  end

  ###################
  #  __required__?  #
  #  __optional__?  #
  #  __required__=  #
  ###################

  it 'can be optional or required and report valid for rendering (which is presently required only but could be other checks later)' do
    
    class_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::BindingBase::InstanceBinding::ContainerMock )
    instance = ::Perspective::Bindings::BindingBase::InstanceBinding.new( class_instance, ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock.new )

    instance.__required__?.should == false
    instance.__optional__?.should == true
    instance.__required__ = true
    instance.__required__?.should == true
    instance.__optional__?.should == false
    
    class_instance.__required__ = true
    instance = ::Perspective::Bindings::BindingBase::InstanceBinding.new( class_instance, ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock.new )
    instance.__required__?.should == true
    instance.__optional__?.should == false
    instance.__required__ = false
    instance.__required__?.should == false
    instance.__optional__?.should == true

  end

  ######################
  #  __bindings__      #
  #  __binding__       #
  #  __has_binding__?  #
  ######################

  it 'can return sub-bindings that define containers nested inside this binding container class' do
    
    class_instance = ::Perspective::Bindings::BindingTypeContainer::Bindings::Text.new( ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::BindingBase::InstanceBinding::ContainerMock )
    instance = ::Perspective::Bindings::BindingTypeContainer::Bindings::Text::InstanceBinding.new( class_instance, ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock.new )

    nesting_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock, :nesting_binding_name )

    some_binding_instance = ::Perspective::Bindings::BindingTypeContainer::Bindings::Text::NestedClassBinding.new( nesting_instance, :some_binding )
    class_instance.__bindings__[ :some_binding ] = some_binding_instance
    
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :some_binding ].__is_a__?( ::Perspective::Bindings::BindingBase::InstanceBinding ).should == true
    instance.__binding__( :some_binding ).__parent_binding__.should == some_binding_instance
    instance.__has_binding__?( :some_binding ).should == true
  end

  ##############################
  #  __value__                 #
  #  __value__=                #
  #  __binding_value_valid__?  #
  ##############################

  it 'can report whether a binding value is valid for assignment to this binding and accept and return a value, performing this check and raising an exception if it fails and finally translate this value to a string for final output' do

    class_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::BindingBase::InstanceBinding::ContainerMock )
    instance = ::Perspective::Bindings::BindingBase::InstanceBinding.new( class_instance, ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock.new )
    instance.__value__.should == nil
    instance.__binding_value_valid__?( :some_value ).should == false
    Proc.new { instance.__value__ = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.__extend__( ::Perspective::Bindings::BindingDefinitions::Text )
    instance.__binding_value_valid__?( :some_value ).should == true
    instance.__value__ = :some_value
    instance.__value__.should == :some_value
    instance.__container__.content.should == instance.__value__
    instance.__value__ = nil
    instance.__required__ = true
    Proc.new { instance.__value__ = 42 }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

    instance.__permits_multiple__ = true
    instance.__extend__( ::Perspective::Bindings::BindingDefinitions::Text )

    instance.__value__ = [ :one, :two, :three, :four ]
    instance.__value__.should == [ :one, :two, :three, :four ]
    instance.__container__.class.should == ::Perspective::Bindings::Container::MultiContainerProxy
    instance.__container__.__count__.should == 4
    instance.__container__[ 0 ].is_a?( class_instance.__container_class__ ).should == true
    instance.__container__[ 0 ].content.should == :one
    instance.__container__[ 1 ].is_a?( class_instance.__container_class__ ).should == true
    instance.__container__[ 1 ].content.should == :two
    instance.__container__[ 2 ].is_a?( class_instance.__container_class__ ).should == true
    instance.__container__[ 2 ].content.should == :three
    instance.__container__[ 3 ].is_a?( class_instance.__container_class__ ).should == true
    instance.__container__[ 3 ].content.should == :four
    
    second_class_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock, :other_binding_name, ::Perspective::Bindings::BindingBase::InstanceBinding::ContainerMock )
    second_instance = ::Perspective::Bindings::BindingBase::InstanceBinding.new( second_class_instance, ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock.new )
    second_instance.__extend__( ::Perspective::Bindings::BindingDefinitions::Text )
    second_instance.__value__ = :some_value
    instance.__value__ = second_instance
    instance.__value__.should == :some_value
    
  end

  ##############################
  #  __binding_value_valid__?  #
  ##############################
  
  it 'can ensure class instances are valid binding objects' do
    class_instance = ::Perspective::Bindings::BindingBase::ClassBinding.new( ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::BindingBase::InstanceBinding::ContainerMock )
    class_instance.__permits_multiple__ = true
    ::Perspective::Bindings::BindingBase::InstanceBinding.new( class_instance, ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock.new ).__instance_eval__ do
      __extend__ ::Perspective::Bindings::BindingDefinitions::Class
      __extend__ ::Perspective::Bindings::BindingDefinitions::Integer
      __extend__ ::Perspective::Bindings::BindingDefinitions::Float
      # class
      __binding_value_valid__?( Object ).should == true
      # module
      __binding_value_valid__?( Kernel ).should == false
      # file
      __binding_value_valid__?( File.new( __FILE__ ) ).should == false
      # integer
      __binding_value_valid__?( 42 ).should == true
      # float
      __binding_value_valid__?( 42.0 ).should == true
      # complex
      __binding_value_valid__?( Complex( 1, 2 ) ).should == false
      # rational
      __binding_value_valid__?( Rational( 1, 2 ) ).should == false
      # [ number ] - integer, float, complex, rational
      # regexp
      __binding_value_valid__?( /some_regexp/ ).should == false
      # text
      __binding_value_valid__?( 'string' ).should == false
      __binding_value_valid__?( :symbol ).should == false
      # true_false
      __binding_value_valid__?( true ).should == false
      __binding_value_valid__?( false ).should == false
      # uri
      __binding_value_valid__?( 'http://some.uri' ).should == false
      __binding_value_valid__?( URI.parse( 'http://some.uri' ) ).should == false
      # multiple
      __permits_multiple__?.should == true
      __binding_value_valid__?( [ Object, 12, 42.0 ] ).should == true
    end
  end

  ##############
  #  view      #
  #  __view__  #
  ##############
  
  it 'can refer to its container as a view' do
    ::Perspective::Bindings::BindingTypeContainer::AbstractView::InstanceBinding.instance_method( :__view__ ).should == ::Perspective::Bindings::BindingTypeContainer::AbstractView::InstanceBinding.instance_method( :__container__ )
    ::Perspective::Bindings::BindingTypeContainer::AbstractView::InstanceBinding.instance_method( :view ).should == ::Perspective::Bindings::BindingTypeContainer::AbstractView::InstanceBinding.instance_method( :__view__ )
  end

  #############################
  #  __render_value_valid__?  #
	#  __render_value__         #
  #############################

  it 'can report whether the current value is valid for rendering and return a render value' do
    class_instance = ::Perspective::Bindings::BindingTypeContainer::AbstractView::Text.new( ::Perspective::View::Bindings::BindingBase::InstanceBinding::Mock, :binding_name )
    instance = ::Perspective::Bindings::BindingTypeContainer::AbstractView::Text::InstanceBinding.new( class_instance, ::Perspective::View::Bindings::BindingBase::InstanceBinding::Mock.new )
    instance.__value__ = :some_value
    instance.__is_a__?( ::Perspective::View::BindingDefinitions::RenderValueAsString ).should == true
    instance.__render_value_valid__?.should == true
    instance.__render_value__.should == 'some_value'
  end

end
