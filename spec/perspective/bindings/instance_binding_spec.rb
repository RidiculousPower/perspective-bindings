
require_relative '../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::InstanceBinding do

  before :all do

    class ::Perspective::Bindings::InstanceBinding::BoundContainerMock

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

    class ::Perspective::Bindings::InstanceBinding::ContainerMock

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
      def __initialize_for_parent_binding__( parent )
      end

      module Controller
        module ClassBindingMethods
        end
        module InstanceBindingMethods
        end
      end
      
      include ::Perspective::Bindings::Attributes::Text
      
    end

  end
  
  ########################
  #  initialize          #
  #  parent_binding      #
  #  __parent_binding__  #
  #  name                #
  #  __name__            #
  #  container           #
  #  __container__       #
  #  route               #
  #  __route__           #
  #  route_string        #
  #  __route_string__    #
  ########################

  it 'can initialize as a child of a class binding' do
    ::Perspective::Bindings::InstanceBinding.instance_method( :parent_binding ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__parent_binding__ )
    ::Perspective::Bindings::InstanceBinding.instance_method( :name ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__name__ )
    ::Perspective::Bindings::InstanceBinding.instance_method( :container ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__container__ )
    ::Perspective::Bindings::InstanceBinding.instance_method( :route ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__route__ )
    ::Perspective::Bindings::InstanceBinding.instance_method( :route_string ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__route_string__ )
    class_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::InstanceBinding::ContainerMock )
    instance = ::Perspective::Bindings::InstanceBinding.new( class_instance, ::Perspective::Bindings::InstanceBinding::BoundContainerMock.new )
    instance.__parent_binding__.should == class_instance
    instance.__name__.should == class_instance.__name__
    instance.__container__.class.should == class_instance.__container_class__
    instance.__route__.should == class_instance.__route__
    instance.__route_string__.should == class_instance.__route_string__
  end

  #########################
  #  required?            #
  #  optional?            #
  #  required=            #
  #  __required__=        #
  #########################

  it 'can be optional or required and report valid for rendering (which is presently required only but could be other checks later)' do
    
    ::Perspective::Bindings::InstanceBinding.instance_method( :required= ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__required__= )
    
    class_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::InstanceBinding::ContainerMock )
    instance = ::Perspective::Bindings::InstanceBinding.new( class_instance, ::Perspective::Bindings::InstanceBinding::BoundContainerMock.new )

    instance.required?.should == false
    instance.optional?.should == true
    instance.__required__ = true
    instance.required?.should == true
    instance.optional?.should == false
    
    class_instance.__required__ = true
    instance = ::Perspective::Bindings::InstanceBinding.new( class_instance, ::Perspective::Bindings::InstanceBinding::BoundContainerMock.new )
    instance.required?.should == true
    instance.optional?.should == false
    instance.__required__ = false
    instance.required?.should == false
    instance.optional?.should == true

  end

  ##################
  #  bindings      #
  #  __bindings__  #
  #  binding       #
  #  __binding__   #
  #  has_binding?  #
  ##################

  it 'can return sub-bindings that define containers nested inside this binding container class' do
    ::Perspective::Bindings::InstanceBinding.instance_method( :bindings ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__bindings__ )
    ::Perspective::Bindings::InstanceBinding.instance_method( :binding ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__binding__ )
    
    class_instance = ::Perspective::Bindings::AttributeContainer::Bindings::Text.new( ::Perspective::Bindings::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::InstanceBinding::ContainerMock )
    instance = ::Perspective::Bindings::AttributeContainer::Bindings::Text::InstanceBinding.new( class_instance, ::Perspective::Bindings::InstanceBinding::BoundContainerMock.new )

    nesting_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::InstanceBinding::BoundContainerMock, :nesting_binding_name )

    some_binding_instance = ::Perspective::Bindings::AttributeContainer::Bindings::Text::NestedClassBinding.new( nesting_instance, :some_binding )
    class_instance.__bindings__[ :some_binding ] = some_binding_instance
    
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :some_binding ].is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
    instance.__binding__( :some_binding ).parent_binding.should == some_binding_instance
    instance.has_binding?( :some_binding ).should == true
  end

  ##########################
  #  value                 #
  #  __value__             #
  #  value=                #
  #  __value__=            #
  #  binding_value_valid?  #
  ##########################

  it 'can report whether a binding value is valid for assignment to this binding and accept and return a value, performing this check and raising an exception if it fails and finally translate this value to a string for final output' do

    ::Perspective::Bindings::InstanceBinding.instance_method( :value ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__value__ )
    ::Perspective::Bindings::InstanceBinding.instance_method( :value= ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :__value__= )

    class_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::InstanceBinding::ContainerMock )
    instance = ::Perspective::Bindings::InstanceBinding.new( class_instance, ::Perspective::Bindings::InstanceBinding::BoundContainerMock.new )
    instance.__value__.should == nil
    instance.binding_value_valid?( :some_value ).should == false
    Proc.new { instance.__value__ = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.extend( ::Perspective::Bindings::Attributes::Text )
    instance.binding_value_valid?( :some_value ).should == true
    instance.__value__ = :some_value
    instance.__value__.should == :some_value
    instance.__container__.content.should == instance.__value__
    instance.__value__ = nil
    instance.__required__ = true
    Proc.new { instance.__value__ = 42 }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )

    instance.__permits_multiple__ = true
    instance.extend( ::Perspective::Bindings::Attributes::Text )

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
    
    second_class_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::InstanceBinding::BoundContainerMock, :other_binding_name, ::Perspective::Bindings::InstanceBinding::ContainerMock )
    second_instance = ::Perspective::Bindings::InstanceBinding.new( second_class_instance, ::Perspective::Bindings::InstanceBinding::BoundContainerMock.new )
    second_instance.extend( ::Perspective::Bindings::Attributes::Text )
    second_instance.__value__ = :some_value
    instance.__value__ = second_instance
    instance.__value__.should == :some_value
    
  end

  ##########################
  #  binding_value_valid?  #
  ##########################
  
  it 'can ensure class instances are valid binding objects' do
    class_instance = ::Perspective::Bindings::ClassBinding.new( ::Perspective::Bindings::InstanceBinding::BoundContainerMock, :binding_name, ::Perspective::Bindings::InstanceBinding::ContainerMock )
    class_instance.__permits_multiple__ = true
    ::Perspective::Bindings::InstanceBinding.new( class_instance, ::Perspective::Bindings::InstanceBinding::BoundContainerMock.new ).instance_eval do
      extend ::Perspective::Bindings::Attributes::Class
      extend ::Perspective::Bindings::Attributes::Integer
      extend ::Perspective::Bindings::Attributes::Float
      # class
      binding_value_valid?( Object ).should == true
      # module
      binding_value_valid?( Kernel ).should == false
      # file
      binding_value_valid?( File.new( __FILE__ ) ).should == false
      # integer
      binding_value_valid?( 42 ).should == true
      # float
      binding_value_valid?( 42.0 ).should == true
      # complex
      binding_value_valid?( Complex( 1, 2 ) ).should == false
      # rational
      binding_value_valid?( Rational( 1, 2 ) ).should == false
      # [ number ] - integer, float, complex, rational
      # regexp
      binding_value_valid?( /some_regexp/ ).should == false
      # text
      binding_value_valid?( 'string' ).should == false
      binding_value_valid?( :symbol ).should == false
      # true_false
      binding_value_valid?( true ).should == false
      binding_value_valid?( false ).should == false
      # uri
      binding_value_valid?( 'http://some.uri' ).should == false
      binding_value_valid?( URI.parse( 'http://some.uri' ) ).should == false
      # multiple
      self.permits_multiple?.should == true
      binding_value_valid?( [ Object, 12, 42.0 ] ).should == true
    end
  end

end
