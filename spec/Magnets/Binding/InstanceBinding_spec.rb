
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::InstanceBinding do

  before :all do
    class ::Magnets::Binding::InstanceBinding::ViewMock
      attr_reader :to_html_node
    end
  end

  ########################
  #  initialize          #
  #  parent_binding      #
  #  __parent_binding__  #
  #  name                #
  #  __name__            #
  #  view                #
  #  __view__            #
  #  route               #
  #  __route__           #
  #  route_string        #
  #  __route_string__    #
  ########################

  it 'can initialize as a child of a class binding' do
    ::Magnets::Binding::InstanceBinding.instance_method( :parent_binding ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__parent_binding__ )
    ::Magnets::Binding::InstanceBinding.instance_method( :name ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__name__ )
    ::Magnets::Binding::InstanceBinding.instance_method( :view ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__view__ )
    ::Magnets::Binding::InstanceBinding.instance_method( :route ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__route__ )
    ::Magnets::Binding::InstanceBinding.instance_method( :route_string ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__route_string__ )
    class_instance = ::Magnets::Binding::ClassBinding.new( :binding_name, ::Magnets::Binding::InstanceBinding::ViewMock )
    instance = ::Magnets::Binding::InstanceBinding.new( class_instance )
    instance.__parent_binding__.should == class_instance
    instance.__name__.should == class_instance.__name__
    instance.__view__.class.should == class_instance.__view_class__
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
    
    ::Magnets::Binding::InstanceBinding.instance_method( :required= ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__required__= )
    
    class_instance = ::Magnets::Binding::ClassBinding.new( :binding_name, ::Magnets::Binding::InstanceBinding::ViewMock )
    instance = ::Magnets::Binding::InstanceBinding.new( class_instance )

    instance.required?.should == false
    instance.optional?.should == true
    instance.__required__ = true
    instance.required?.should == true
    instance.optional?.should == false
    
    class_instance.__required__ = true
    instance = ::Magnets::Binding::InstanceBinding.new( class_instance )
    instance.required?.should == true
    instance.optional?.should == false
    instance.__required__ = false
    instance.required?.should == false
    instance.optional?.should == true

  end

  ##########################
  #  value                 #
  #  __value__             #
  #  value=                #
  #  __value__=            #
  #  binding_value_valid?  #
  #  render_value_valid?   #
	#  render_value          #
	#  __render_value__      #
  ##########################

  it 'can report whether a binding value is valid for assignment to this binding and accept and return a value, performing this check and raising an exception if it fails and finally translate this value to a string for final output' do

    ::Magnets::Binding::InstanceBinding.instance_method( :value ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__value__ )
    ::Magnets::Binding::InstanceBinding.instance_method( :value= ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__value__= )
    ::Magnets::Binding::InstanceBinding.instance_method( :render_value ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__render_value__ )

    class_instance = ::Magnets::Binding::ClassBinding.new( :binding_name, ::Magnets::Binding::InstanceBinding::ViewMock )
    instance = ::Magnets::Binding::InstanceBinding.new( class_instance )
    instance.__value__.should == nil
    instance.binding_value_valid?( :some_value ).should == false
    Proc.new { instance.__value__ = :some_value }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    instance.extend( ::Magnets::Binding::Definition::Text )
    instance.binding_value_valid?( :some_value ).should == true
    instance.__value__ = :some_value
    instance.__value__.should == :some_value
    instance.render_value_valid?.should == true
    instance.__render_value__.should == 'some_value'
    instance.__value__ = nil
    instance.__required__ = true
    instance.render_value_valid?.should == false
    Proc.new { instance.__value__ = 42 }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
  end

  ##################
  #  bindings      #
  #  __bindings__  #
  #  binding       #
  #  __binding__   #
  ##################

  it 'can return sub-bindings that define views nested inside this binding view class' do
    ::Magnets::Binding::InstanceBinding.instance_method( :bindings ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__bindings__ )
    ::Magnets::Binding::InstanceBinding.instance_method( :binding ).should == ::Magnets::Binding::InstanceBinding.instance_method( :__binding__ )
    class_instance = ::Magnets::Binding::ClassBinding.new( :binding_name, ::Magnets::Binding::InstanceBinding::ViewMock )
    instance = ::Magnets::Binding::InstanceBinding.new( class_instance )
    # mock reference to InstanceBinding from ClassBinding
    ::Magnets::Binding::ClassBinding::InstanceBinding = ::Magnets::Binding::InstanceBinding
    some_binding_instance = ::Magnets::Binding::ClassBinding.new( :some_binding )
    class_instance.__bindings__[ :some_binding ] = some_binding_instance
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :some_binding ].is_a?( ::Magnets::Binding::InstanceBinding ).should == true
    instance.__binding__( :some_binding ).parent_binding.should == some_binding_instance
  end

end
