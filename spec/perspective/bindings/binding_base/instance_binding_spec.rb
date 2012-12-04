
require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingBase::InstanceBinding do

  before :all do
    class ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock
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
    class ::Perspective::Bindings::BindingBase::InstanceBinding::ClassBindingMock
      include ::Perspective::Bindings::BindingBase::ClassBinding
    end
    class ::Perspective::Bindings::BindingBase::InstanceBinding::InstanceBindingMock
      include ::Perspective::Bindings::BindingBase::InstanceBinding
    end
    @configuration_proc = ::Proc.new { puts 'config!' }
    @bound_container = ::Perspective::Bindings::BindingBase::InstanceBinding::BoundContainerMock
    @bound_container_instance = @bound_container.new
  end
  
  before :each do
    @class_binding = ::Perspective::Bindings::BindingBase::InstanceBinding::ClassBindingMock.new( @bound_container, :binding_name, & @configuration_proc )
    @instance_binding = ::Perspective::Bindings::BindingBase::InstanceBinding::InstanceBindingMock.new( @class_binding, @bound_container_instance )
  end

  #########################
  #  __bound_container__  #
  #########################
  
  it 'binds to a container' do
    @instance_binding.__bound_container__.should == @bound_container_instance
  end

  ##############
  #  __name__  #
  ##############
  
  it 'has a name' do
    @instance_binding.__name__.should == :binding_name
  end

  ##############
  #  __root__  #
  ##############
  
  it 'has a root container, which for a non-nested class binding is self' do
    @instance_binding.__root__.should == @bound_container_instance
  end

  ###############
  #  __route__  #
  ###############

  it 'it has a route, which for a non-nested class binding is nil' do
    @instance_binding.__route__.should == nil
  end

  #########################
  #  __route_with_name__  #
  #########################

  it 'it has a route with name, which for a non-nested class binding is the name' do
    @instance_binding.__route_with_name__.should == [ :binding_name ]
  end

  ######################
  #  __route_string__  #
  ######################

  it 'it has a route string, which for a non-nested class binding is the name' do
    @instance_binding.__route_string__.should == ::Perspective::Bindings.context_string( @instance_binding.__route_with_name__ )
    
  end

  ############################
  #  __route_print_string__  #
  ############################

  it 'it has a route print string, which for a non-nested class binding is the root string plus the name' do
    @instance_binding.__route_print_string__.should == ::Perspective::Bindings.context_print_string( @bound_container_instance, @instance_binding.__route_string__ )
  end

  ###########################
  #  __permits_multiple__?  #
  #  __permits_multiple__=  #
  ###########################

  it 'does not permit multiple by default' do
    @instance_binding.__permits_multiple__?.should == false
  end

  ###################
  #  __required__?  #
  #  __required__=  #
  ###################

  it 'can report whether required' do
    @instance_binding.__required__?.should == ! @instance_binding.__optional__?
    @instance_binding.__required__ = ! @instance_binding.__required__?
    @instance_binding.__required__?.should == ! @instance_binding.__optional__?
  end

  ###################
  #  __optional__?  #
  #  __optional__=  #
  ###################

  it 'can report whether optional' do
    @instance_binding.__optional__?.should == ! @instance_binding.__required__?
    @instance_binding.__optional__ = ! @instance_binding.__optional__?
    @instance_binding.__optional__?.should == ! @instance_binding.__required__?
  end

  ##############################
  #  __binding_value_valid__?  #
  ##############################
  
  it 'can ensure class instances are valid binding objects' do
    @instance_binding.__permits_multiple__ = true
    @instance_binding.__instance_eval__ do
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

  #################
	#  __equals__?  #
	#################

  it 'has an alias to its original :== method' do
    @instance_binding.__equals__?( @instance_binding ).should == true
  end

  ################
  #  value       #
  #  value=      #
  #  __value__   #
  #  __value__=  #
  ################

  it 'can hold a value' do
    ::Perspective::Bindings::BindingBase::InstanceBinding.instance_method( :value ).should == ::Perspective::Bindings::BindingBase::InstanceBinding.instance_method( :__value__ )
    ::Perspective::Bindings::BindingBase::InstanceBinding.instance_method( :value= ).should == ::Perspective::Bindings::BindingBase::InstanceBinding.instance_method( :__value__= )
    @instance_binding.__extend__ ::Perspective::Bindings::BindingDefinitions::Text
    @instance_binding.__value__ = :some_value
    @instance_binding.__value__.should == :some_value
  end
  
	########
	#  ==  #
	########

  it 'evaluates equality by its value rather than self' do
    @instance_binding.__extend__ ::Perspective::Bindings::BindingDefinitions::Text
    @instance_binding.__value__ = :some_value
    @instance_binding.should == :some_value
  end
  
  ####################
  #  method_missing  #
  ####################
	
	it 'forwards almost all methods to its value' do
	  non_forwarded_methods = [ :method_missing, :object_id, :hash, :==,
                              :equal?, :class, 
                              :view, :view=, :container, :container=, :to_html_node ]
    non_forwarded_methods.each do |this_method_name|
      @instance_binding.__instance_eval__ do
        respond_to_missing?( this_method_name, true ).should == false
      end
    end
    @instance_binding.respond_to_missing?( :some_other_method, true ).should == true
  end
  
end
