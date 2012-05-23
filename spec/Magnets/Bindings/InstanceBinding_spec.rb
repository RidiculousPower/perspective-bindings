
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::InstanceBinding do

  before :all do
    class ::Magnets::Bindings::InstanceBinding::ContainerMock
      def self.__bindings__
      end
      attr_accessor :content, :__parent_binding__
      def __autobind__( data_object )
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
      module ClassBindingMethods
      end
      module InstanceBindingMethods
      end
      
      include ::Magnets::Bindings::Attributes::Text
      
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
    ::Magnets::Bindings::InstanceBinding.instance_method( :parent_binding ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__parent_binding__ )
    ::Magnets::Bindings::InstanceBinding.instance_method( :name ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__name__ )
    ::Magnets::Bindings::InstanceBinding.instance_method( :container ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__container__ )
    ::Magnets::Bindings::InstanceBinding.instance_method( :route ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__route__ )
    ::Magnets::Bindings::InstanceBinding.instance_method( :route_string ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__route_string__ )
    class_instance = ::Magnets::Bindings::ClassBinding.new( :binding_name, ::Magnets::Bindings::InstanceBinding::ContainerMock )
    instance = ::Magnets::Bindings::InstanceBinding.new( class_instance )
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
    
    ::Magnets::Bindings::InstanceBinding.instance_method( :required= ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__required__= )
    
    class_instance = ::Magnets::Bindings::ClassBinding.new( :binding_name, ::Magnets::Bindings::InstanceBinding::ContainerMock )
    instance = ::Magnets::Bindings::InstanceBinding.new( class_instance )

    instance.required?.should == false
    instance.optional?.should == true
    instance.__required__ = true
    instance.required?.should == true
    instance.optional?.should == false
    
    class_instance.__required__ = true
    instance = ::Magnets::Bindings::InstanceBinding.new( class_instance )
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
    ::Magnets::Bindings::InstanceBinding.instance_method( :bindings ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__bindings__ )
    ::Magnets::Bindings::InstanceBinding.instance_method( :binding ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__binding__ )
    class_instance = ::Magnets::Bindings::ClassBinding.new( :binding_name, ::Magnets::Bindings::InstanceBinding::ContainerMock )
    instance = ::Magnets::Bindings::InstanceBinding.new( class_instance )
    # mock reference to InstanceBinding from ClassBinding
    ::Magnets::Bindings::ClassBinding::InstanceBinding = ::Magnets::Bindings::InstanceBinding
    some_binding_instance = ::Magnets::Bindings::ClassBinding.new( :some_binding )
    class_instance.__bindings__[ :some_binding ] = some_binding_instance
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :some_binding ].is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
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

    ::Magnets::Bindings::InstanceBinding.instance_method( :value ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__value__ )
    ::Magnets::Bindings::InstanceBinding.instance_method( :value= ).should == ::Magnets::Bindings::InstanceBinding.instance_method( :__value__= )

    class_instance = ::Magnets::Bindings::ClassBinding.new( :binding_name, ::Magnets::Bindings::InstanceBinding::ContainerMock )
    instance = ::Magnets::Bindings::InstanceBinding.new( class_instance )
    instance.__value__.should == nil
    instance.binding_value_valid?( :some_value ).should == false
    Proc.new { instance.__value__ = :some_value }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.extend( ::Magnets::Bindings::Attributes::Text )
    instance.binding_value_valid?( :some_value ).should == true
    instance.__value__ = :some_value
    instance.__value__.should == :some_value
    instance.__value__ = nil
    instance.__required__ = true
    Proc.new { instance.__value__ = 42 }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.__container__.content.should == instance.__value__
    
    instance.extend( ::Magnets::Bindings::Attributes::Multiple )
    
    instance.__value__ = [ :one, :two, :three, :four ]
    instance.__container__.is_a?( ::Magnets::Bindings::Container::MultiContainerProxy ).should == true
    instance.__container__.__count__.should == 4
    instance.__container__[ 0 ].is_a?( class_instance.__container_class__ ).should == true
    instance.__container__[ 0 ].content.should == :one
    instance.__container__[ 1 ].is_a?( class_instance.__container_class__ ).should == true
    instance.__container__[ 1 ].content.should == :two
    instance.__container__[ 2 ].is_a?( class_instance.__container_class__ ).should == true
    instance.__container__[ 2 ].content.should == :three
    instance.__container__[ 3 ].is_a?( class_instance.__container_class__ ).should == true
    instance.__container__[ 3 ].content.should == :four
    
  end

end
