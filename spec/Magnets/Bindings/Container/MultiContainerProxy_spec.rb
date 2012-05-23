
require_relative '../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Container::MultiContainerProxy do

  before :all do
    
    class ::Magnets::Bindings::Container::MultiContainerProxy::MockContainer
      class View
        include ::Magnets::Bindings::Container
        attr_text :content
      end
      include ::Magnets::Bindings::Container
      attr_text :some_text, ::Magnets::Bindings::Container::MultiContainerProxy::MockContainer::View
    end
    
  end

  #########################
  #  initialize           #
  #  __container_class__  #
  #  __storage_array__    # 
  #########################
  
  it 'can be created to contain multiple containers and relay instructions to them' do
    container = ::Magnets::Bindings::Container::MultiContainerProxy::MockContainer.new
    instance = ::Magnets::Bindings::Container::MultiContainerProxy.new( container.some_text )
    instance.__parent_binding__.should == container.some_text
    instance.__storage_array__.is_a?( ::Array ).should == true
    instance.__storage_array__.should == [ container.some_text.__container__ ]
    instance.__container_class__.should == container.some_text.__container__.class
  end

  ####################
  #  method_missing  #
  ####################
  
  it 'forwards messages to its members' do
    container = ::Magnets::Bindings::Container::MultiContainerProxy::MockContainer.new
    container.some_text.__container__.define_singleton_method( :some_method ) do
      @called_some_method = true
    end
    container.some_text.__container__.define_singleton_method( :called_some_method ) do
      return @called_some_method
    end
    instance = ::Magnets::Bindings::Container::MultiContainerProxy.new( container.some_text )
    instance.some_method
    container.some_text.__container__.called_some_method.should == true
  end
  
  ##################
  #  __autobind__  #
  ##################

  it 'can autobind' do
    container = ::Magnets::Bindings::Container::MultiContainerProxy::MockContainer.new
    instance = ::Magnets::Bindings::Container::MultiContainerProxy.new( container.some_text )
    instance.__autobind__( :one, :two, :three, :four )
    instance[ 0 ].content.__value__.should == :one
    instance[ 1 ].content.__value__.should == :two
    instance[ 2 ].content.__value__.should == :three
    instance[ 3 ].content.__value__.should == :four
    CascadingConfiguration::Variable.ancestor( instance[ 1 ], :__bindings__ ).should == instance[ 0 ]
    CascadingConfiguration::Variable.ancestor( instance[ 2 ], :__bindings__ ).should == instance[ 0 ]
    CascadingConfiguration::Variable.ancestor( instance[ 3 ], :__bindings__ ).should == instance[ 0 ]
  end

  #################
  #  __count__    #
  #  __push__     #
  #  __pop__      #
  #  __shift__    #
  #  __unshift__  #
  #  []           #
  #  []=          #
  #################
  
  it 'can return count of views proxied and push/pop/shift/index like an array' do
    container = ::Magnets::Bindings::Container::MultiContainerProxy::MockContainer.new
    instance = ::Magnets::Bindings::Container::MultiContainerProxy.new( container.some_text )
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
