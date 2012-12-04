
require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingBase::ClassBinding do

  before :all do
    class ::Perspective::Bindings::BindingBase::ClassBinding::BoundContainerMock
      def self.__root__
        return self
      end
      def self.__root_string__
        return to_s
      end
    end
    class ::Perspective::Bindings::BindingBase::ClassBinding::BoundContainerMockSub < ::Perspective::Bindings::BindingBase::ClassBinding::BoundContainerMock
    end
    class ::Perspective::Bindings::BindingBase::ClassBinding::ClassBindingMock
      include ::Perspective::Bindings::BindingBase::ClassBinding
    end
    @configuration_proc = ::Proc.new { puts 'config!' }
    @bound_container = ::Perspective::Bindings::BindingBase::ClassBinding::BoundContainerMock
    @bound_container_two = ::Perspective::Bindings::BindingBase::ClassBinding::BoundContainerMockSub
    @configuration_proc_two = ::Proc.new { puts 'config2!' }
  end
  
  before :each do
    @class_binding = ::Perspective::Bindings::BindingBase::ClassBinding::ClassBindingMock.new( @bound_container, :binding_name, & @configuration_proc )
    @class_binding_with_ancestor = ::Perspective::Bindings::BindingBase::ClassBinding::ClassBindingMock.new( @bound_container_two, :binding_name, @class_binding, & @configuration_proc_two )
  end

  #################################
  #  __binding_name_validates__?  #
  #################################
  
  it 'prohibits certain names from being used ' do
    ::Perspective::Bindings::ProhibitedNames.has_key?( :new ).should == true
    ::Proc.new { ::Perspective::Bindings::BindingBase::ClassBinding::ClassBindingMock.new( @bound_container, :new ) }.should raise_error( ::ArgumentError )
  end

  #########################
  #  __bound_container__  #
  #########################
  
  it 'binds to a container' do
    @class_binding.__bound_container__.should == @bound_container
  end

  it 'binds to a container when declared with an ancestor' do
    @class_binding_with_ancestor.__bound_container__.should == @bound_container_two
  end
  
  ##############
  #  __name__  #
  ##############
  
  it 'has a name' do
    @class_binding.__name__.should == :binding_name
  end

  it 'has the same name as its ancestors' do
    ::CascadingConfiguration.configuration( @class_binding_with_ancestor, :__name__ ).is_parent?( @class_binding ).should == true
    @class_binding_with_ancestor.__name__.should == :binding_name
  end
  
  ##############
  #  __root__  #
  ##############
  
  it 'has a root container, which for a non-nested class binding is self' do
    @class_binding.__root__.should == @bound_container
  end

  it 'has a root container, which for a non-nested class binding with an ancestor is self' do
    @class_binding_with_ancestor.__root__.should == @bound_container_two
  end
  
  ###############
  #  __route__  #
  ###############

  it 'it has a route, which for a non-nested class binding is nil' do
    @class_binding.__route__.should == nil
  end

  it 'it has a route, which for a non-nested class binding with an ancestor is nil' do
    @class_binding_with_ancestor.__route__.should == nil
  end

  #########################
  #  __route_with_name__  #
  #########################

  it 'it has a route with name, which for a non-nested class binding is the name' do
    @class_binding.__route_with_name__.should == [ :binding_name ]
  end

  it 'it has a route with name, which for a non-nested class binding with an ancestor is the name' do
    @class_binding_with_ancestor.__route_with_name__.should == [ :binding_name ]
  end

  ######################
  #  __route_string__  #
  ######################

  it 'it has a route string, which for a non-nested class binding is the name' do
    @class_binding.__route_string__.should == ::Perspective::Bindings.context_string( @class_binding.__route_with_name__ )
    
  end

  it 'it has a route string, which for a non-nested class binding with an ancestor is the name' do
    @class_binding_with_ancestor.__route_string__.should == ::Perspective::Bindings.context_string( @class_binding_with_ancestor.__route_with_name__ )
  end

  ############################
  #  __route_print_string__  #
  ############################

  it 'it has a route print string, which for a non-nested class binding is the root string plus the name' do
    @class_binding.__route_print_string__.should == ::Perspective::Bindings.context_print_string( @bound_container, @class_binding.__route_string__ )
  end

  it 'it has a route print string, which for a non-nested class binding with an ancestor is the root string plus the name' do
    @class_binding_with_ancestor.__route_print_string__.should == ::Perspective::Bindings.context_print_string( @bound_container_two, @class_binding_with_ancestor.__route_string__ )
  end

  ###########################
  #  __permits_multiple__?  #
  #  __permits_multiple__=  #
  ###########################

  it 'does not permit multiple by default' do
    @class_binding.__permits_multiple__?.should == false
  end

  it 'does not permit multiple by default but inherits from ancestor' do
    ::CascadingConfiguration.configuration( @class_binding_with_ancestor, :__permits_multiple__? ).is_parent?( @class_binding ).should == true
    @class_binding_with_ancestor.__permits_multiple__?.should == @class_binding.__permits_multiple__?
    @class_binding.__permits_multiple__ = ! @class_binding.__permits_multiple__?
    @class_binding_with_ancestor.__permits_multiple__?.should == @class_binding.__permits_multiple__?
  end
  
  ###################
  #  __required__?  #
  #  __required__=  #
  ###################

  it 'can report whether required' do
    @class_binding.__required__?.should == ! @class_binding.__optional__?
    @class_binding.__required__ = ! @class_binding.__required__?
    @class_binding.__required__?.should == ! @class_binding.__optional__?
  end

  it 'can report whether required based on ancestor' do
    ::CascadingConfiguration.configuration( @class_binding_with_ancestor, :__required__? ).is_parent?( @class_binding ).should == true
    @class_binding_with_ancestor.__required__?.should == ! @class_binding_with_ancestor.__optional__?
    @class_binding_with_ancestor.__required__ = ! @class_binding_with_ancestor.__required__?
    @class_binding_with_ancestor.__required__?.should == ! @class_binding_with_ancestor.__optional__?
  end

  ###################
  #  __optional__?  #
  #  __optional__=  #
  ###################

  it 'can report whether optional' do
    @class_binding.__optional__?.should == ! @class_binding.__required__?
    @class_binding.__optional__ = ! @class_binding.__optional__?
    @class_binding.__optional__?.should == ! @class_binding.__required__?
  end

  it 'can report whether optional based on ancestor' do
    @class_binding_with_ancestor.__optional__?.should == ! @class_binding_with_ancestor.__required__?
    @class_binding_with_ancestor.__optional__ = ! @class_binding_with_ancestor.__optional__?
    @class_binding_with_ancestor.__optional__?.should == ! @class_binding_with_ancestor.__required__?
  end

  #############################
  #  __configuration_procs__  #
  #############################

  it 'keeps track of configuration procs in an inheriting compositing array' do
    @class_binding.__configuration_procs__.should == [ @configuration_proc ]
  end

  it 'keeps track of configuration procs in an inheriting compositing array, inheriting from ancestors' do
    @class_binding_with_ancestor.__configuration_procs__.should == [ @configuration_proc, @configuration_proc_two ]
  end

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  it 'can add a block to the configuration procs' do
    ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :configure ).should == ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :__configure__ )
    another_proc = Proc.new do
      puts 'another config'
    end
    @class_binding.__configure__( & another_proc )
    @class_binding.__configuration_procs__[ 1 ].should == another_proc
  end

end
