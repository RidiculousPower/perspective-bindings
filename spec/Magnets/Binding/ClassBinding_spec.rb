
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::ClassBinding do

  before :all do
    class ::Magnets::Binding::ClassBinding::ViewMock1
      attr_reader :to_html_node
    end
    class ::Magnets::Binding::ClassBinding::ViewMock2
      attr_reader :to_html_node
    end
    class ::Magnets::Binding::ClassBinding::ViewMock3
      attr_reader :to_html_node
    end
    class ::Magnets::Binding::ClassBinding::ViewMock4
      attr_reader :to_html_node
    end
  end

  ###########################################
  #  initialize                             #
  #  __initialize_ancestor_configuration__  #
  #  __initialize_defaults__                #
  #  __validate_binding_name__              #
  #  __validate_view_class__                #
  #  __initialize_route__                   #
  #  name                                   #
  #  __name__                               #
  #  view_class                             #
  #  __view_class__                         #
  #  route                                  #
  #  __route__                              #
  #  route_string                           #
  #  __route_string__                       #
  ###########################################

  it 'can initialize, validate parameters, establish its route, register ancestor' do

    ::Magnets::Binding::ClassBinding.instance_method( :name ).should == ::Magnets::Binding::ClassBinding.instance_method( :__name__ )
    ::Magnets::Binding::ClassBinding.instance_method( :view_class ).should == ::Magnets::Binding::ClassBinding.instance_method( :__view_class__ )
    ::Magnets::Binding::ClassBinding.instance_method( :route ).should == ::Magnets::Binding::ClassBinding.instance_method( :__route__ )
    ::Magnets::Binding::ClassBinding.instance_method( :route_string ).should == ::Magnets::Binding::ClassBinding.instance_method( :__route_string__ )

    # no view class
    instance = ::Magnets::Binding::ClassBinding.new( :binding_name )
    instance.__name__.should == :binding_name
    instance.__view_class__.should == nil
    instance.__route__.should == nil
    instance.__route_string__.should == 'binding_name'

    # with view class
    view_instance = ::Magnets::Binding::ClassBinding.new( :binding_name, ::Magnets::Binding::ClassBinding::ViewMock1 )
    view_instance.__name__.should == :binding_name
    view_instance.__view_class__.should == ::Magnets::Binding::ClassBinding::ViewMock1
    view_instance.__route__.should == nil
    view_instance.__route_string__.should == 'binding_name'

    # with ancestor
    ancestor_instance = ::Magnets::Binding::ClassBinding.new( nil, nil, view_instance )
    ancestor_instance.__name__.should == :binding_name
    ancestor_instance.__view_class__.should == ::Magnets::Binding::ClassBinding::ViewMock1
    ancestor_instance.__route__.should == nil
    ancestor_instance.__route_string__.should == 'binding_name'

    # with view class and ancestor
    view_ancestor_instance = ::Magnets::Binding::ClassBinding.new( nil, ::Magnets::Binding::ClassBinding::ViewMock2, ancestor_instance )
    view_ancestor_instance.__name__.should == :binding_name
    view_ancestor_instance.__view_class__.should == ::Magnets::Binding::ClassBinding::ViewMock2
    view_ancestor_instance.__route__.should == nil
    view_ancestor_instance.__route_string__.should == 'binding_name'

    # with base route
    baseroute_instance = ::Magnets::Binding::ClassBinding.new( :binding_name, nil, nil, [ :path, :to, :binding ] )
    baseroute_instance.__name__.should == :binding_name
    baseroute_instance.__view_class__.should == nil
    baseroute_instance.__route__.should == [ :path, :to, :binding ]
    baseroute_instance.__route_string__.should == 'path-to-binding-binding_name'

    # with view class and base route
    view_baseroute_instance = ::Magnets::Binding::ClassBinding.new( :binding_name, ::Magnets::Binding::ClassBinding::ViewMock3, nil, [ :a, :path, :to, :binding ] )    
    view_baseroute_instance.__name__.should == :binding_name
    view_baseroute_instance.__view_class__.should == ::Magnets::Binding::ClassBinding::ViewMock3
    view_baseroute_instance.__route__.should == [ :a, :path, :to, :binding ]
    view_baseroute_instance.__route_string__.should == 'a-path-to-binding-binding_name'

    # with ancestor and base route
    ancestor_baseroute_instance = ::Magnets::Binding::ClassBinding.new( nil, nil, view_baseroute_instance, [ :another, :path, :to, :binding ] )
    ancestor_baseroute_instance.__name__.should == :binding_name
    ancestor_baseroute_instance.__view_class__.should == ::Magnets::Binding::ClassBinding::ViewMock3
    ancestor_baseroute_instance.__route__.should == [ :another, :path, :to, :binding ]
    ancestor_baseroute_instance.__route_string__.should == 'another-path-to-binding-binding_name'

    # with view class, ancestor and base route
    view_ancestor_baseroute_instance = ::Magnets::Binding::ClassBinding.new( nil, ::Magnets::Binding::ClassBinding::ViewMock4, ancestor_baseroute_instance, [ :some, :other, :path, :to, :binding ] )
    view_ancestor_baseroute_instance.__name__.should == :binding_name
    view_ancestor_baseroute_instance.__view_class__.should == ::Magnets::Binding::ClassBinding::ViewMock4
    view_ancestor_baseroute_instance.__route__.should == [ :some, :other, :path, :to, :binding ]
    view_ancestor_baseroute_instance.__route_string__.should == 'some-other-path-to-binding-binding_name'

  end

  ###################
  #  required?      #
  #  optional?      #
  #  required=      #
  #  __required__=  #
  ###################

  it 'can mark itself as optional or required' do
    ::Magnets::Binding::ClassBinding.instance_method( :required= ).should == ::Magnets::Binding::ClassBinding.instance_method( :__required__= )
    instance = ::Magnets::Binding::ClassBinding.new( :binding_name )
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
    ::Magnets::Binding::ClassBinding.instance_method( :configuration_procs ).should == ::Magnets::Binding::ClassBinding.instance_method( :__configuration_procs__ )
    instance = ::Magnets::Binding::ClassBinding.new( :binding_name )
    instance.__configuration_procs__.is_a?( ::Array ).should == true
  end

  ###################
  #  configure      #
  #  __configure__  #
  ###################

  it 'can add a block to the configuration procs' do
    ::Magnets::Binding::ClassBinding.instance_method( :configure ).should == ::Magnets::Binding::ClassBinding.instance_method( :__configure__ )
    instance = ::Magnets::Binding::ClassBinding.new( :binding_name )
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
  ##################

  it 'can return sub-bindings that define views nested inside this binding view class' do
    ::Magnets::Binding::ClassBinding.instance_method( :bindings ).should == ::Magnets::Binding::ClassBinding.instance_method( :__bindings__ )
    ::Magnets::Binding::ClassBinding.instance_method( :binding ).should == ::Magnets::Binding::ClassBinding.instance_method( :__binding__ )
    instance = ::Magnets::Binding::ClassBinding.new( :binding_name )
    some_binding_instance = ::Magnets::Binding::ClassBinding.new( :some_binding )
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :some_binding ] = some_binding_instance
    instance.__binding__( :some_binding ).should == some_binding_instance
  end

  #############################################
  #  __duplicate_as_inheriting_sub_binding__  #
  #############################################

  it 'can duplicate itself for use in a nested context' do
    instance = ::Magnets::Binding::ClassBinding.new( :binding_name )
    inheriting_instance = instance.__duplicate_as_inheriting_sub_binding__
    inheriting_instance.__name__.should == instance.__name__
    inheriting_instance.__route__.should == instance.__route__
    instance = ::Magnets::Binding::ClassBinding.new( :binding_name )
    inheriting_instance = instance.__duplicate_as_inheriting_sub_binding__( [ :some, :other, :route ] )
    inheriting_instance.__name__.should == instance.__name__
    inheriting_instance.__route__.should == [ :some, :other, :route ]
  end
      
end
