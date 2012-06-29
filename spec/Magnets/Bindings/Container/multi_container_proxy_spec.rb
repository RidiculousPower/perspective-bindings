
require_relative '../../../../lib/magnets/bindings.rb'

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
    instance = ::Magnets::Bindings::Container::MultiContainerProxy.new( container.__binding__( :some_text ) )
    instance.__parent_binding__.should == container.__binding__( :some_text )
    instance.__storage_array__.is_a?( ::Array ).should == true
    instance.__storage_array__.should == [ container.__binding__( :some_text ).__container__ ]
    instance.__container_class__.should == container.__binding__( :some_text ).__container__.class
  end

  ####################
  #  method_missing  #
  ####################
  
  it 'forwards messages to its members' do
    container = ::Magnets::Bindings::Container::MultiContainerProxy::MockContainer.new
    container.__binding__( :some_text ).__container__.define_singleton_method( :some_method ) do
      @called_some_method = true
    end
    container.__binding__( :some_text ).__container__.define_singleton_method( :called_some_method ) do
      return @called_some_method
    end
    instance = ::Magnets::Bindings::Container::MultiContainerProxy.new( container.__binding__( :some_text ) )
    instance.some_method
    container.__binding__( :some_text ).__container__.called_some_method.should == true
  end
  
  ##################
  #  __autobind__  #
  ##################

  it 'can autobind' do
    container = ::Magnets::Bindings::Container::MultiContainerProxy::MockContainer.new
    instance = ::Magnets::Bindings::Container::MultiContainerProxy.new( container.__binding__( :some_text ) )
    instance.__autobind__( :one, :two, :three, :four )
    instance[ 0 ].content.should == :one
    instance[ 1 ].content.should == :two
    instance[ 2 ].content.should == :three
    instance[ 3 ].content.should == :four
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
    instance = ::Magnets::Bindings::Container::MultiContainerProxy.new( container.__binding__( :some_text ) )
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
