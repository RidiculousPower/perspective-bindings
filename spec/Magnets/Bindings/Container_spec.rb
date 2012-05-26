
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Container do

  before :all do
    
    class ::Magnets::Bindings::Container::Mock
      
      include ::Magnets::Bindings::Container
      
      class ContentBindingView

        include ::Magnets::Bindings::Container
        
        attr_binding :content
                
      end
      
      class AutobindMultibindingsView

        include ::Magnets::Bindings::Container
        
        attr_binding :binding_one, :binding_two
                
      end
      
      attr_text :text_binding, ::Magnets::Bindings::Container::Mock::ContentBindingView
      attr_texts :texts_binding, ::Magnets::Bindings::Container::Mock::AutobindMultibindingsView
      
    end

    class ::Magnets::Bindings::Container::OtherMock
      
      include ::Magnets::Bindings::Container
      
    end
    
  end

  ##################
  #  bindings      #
  #  __bindings__  #
  #  binding       #
  #  __binding__   #
  #  has_binding?  #
  ##################

  it 'can return sub-bindings that define containers nested inside this binding container class' do
    ::Magnets::Bindings::Container.instance_method( :bindings ).should == ::Magnets::Bindings::Container.instance_method( :__bindings__ )
    ::Magnets::Bindings::Container.instance_method( :binding ).should == ::Magnets::Bindings::Container.instance_method( :__binding__ )

    Magnets::Bindings::Container::Mock.__bindings__.is_a?( ::Hash ).should == true
    Magnets::Bindings::Container::Mock.__bindings__[ :text_binding ].is_a?( ::Magnets::Bindings::ClassBinding ).should == true
    Magnets::Bindings::Container::Mock.__binding__( :text_binding ).should == Magnets::Bindings::Container::Mock.__bindings__[ :text_binding ]
    Magnets::Bindings::Container::Mock.has_binding?( :text_binding ).should == true

    instance = ::Magnets::Bindings::Container::Mock.new    
    
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :text_binding ].is_a?( ::Magnets::Bindings::InstanceBinding ).should == true
    instance.__binding__( :text_binding ).should == instance.__bindings__[ :text_binding ]
    instance.has_binding?( :text_binding ).should == true
    
  end

  ################
  #  attr_alias  #
  ################
  
  it 'can define binding aliases' do
    
    class ::Magnets::Bindings::Container::Mock
      
      attr_binding :yet_another_binding

    end
    
    Proc.new { ::Magnets::Bindings::Container::Mock.attr_alias :yet_another_binding, :aliased_binding_name }.should raise_error( ::Magnets::Bindings::Exception::NoBindingError )

    class ::Magnets::Bindings::Container::OtherMock
      
      attr_binding :some_other_binding

      has_binding?( :some_other_binding ).should == true
      respond_to?( :some_other_binding ).should == true
      some_other_binding.is_a?( ::Magnets::Bindings::ClassBinding ).should == true

    end
    
    class ::Magnets::Bindings::Container::Mock
      
      attr_alias :aliased_binding_name, :yet_another_binding
      attr_binding :another_binding, ::Magnets::Bindings::Container::OtherMock
      attr_alias :some_other_binding, another_binding.some_other_binding

      has_binding?( :aliased_binding_name ).should == true
      __binding__( :aliased_binding_name ).required?.should == false

      has_binding?( :another_binding ).should == true
      __binding__( :another_binding ).required?.should == false
      respond_to?( :another_binding ).should == true
      method_defined?( :another_binding ).should == true
      method_defined?( :another_binding= ).should == true

      has_binding?( :some_other_binding ).should == true
      __binding__( :some_other_binding ).required?.should == false
      respond_to?( :some_other_binding ).should == true
      method_defined?( :some_other_binding ).should == true
      method_defined?( :some_other_binding= ).should == true

      some_other_binding.is_a?( ::Magnets::Bindings::ClassBinding ).should == true
      some_other_binding.should == another_binding.some_other_binding
      
    end
    
  end

  ##################
  #  autobind      #
  #  __autobind__  #
  ##################

  it 'can autobind a data object' do

    instance = ::Magnets::Bindings::Container::Mock::ContentBindingView.new    
    instance.__autobind__( :one )
    instance.content.__value__.should == :one

    instance = ::Magnets::Bindings::Container::Mock::AutobindMultibindingsView.new
    data_object = Object.new
    data_object.define_singleton_method( :binding_one ) do
      :one
    end
    data_object.define_singleton_method( :binding_two ) do
      :two
    end
    instance.__autobind__( data_object )
    instance.binding_one.__value__.should == :one
    instance.binding_two.__value__.should == :two
    
  end

  ###############
  #  configure  #
  ###############

  it 'can define configuration procs to be run before rendering' do
    rspec = self
    class ::Magnets::Bindings::Container::Mock
      include ::Magnets::Bindings::Container
      configuration_proc = Proc.new do
        configuration_method
      end
      configure( & configuration_proc )
      __configuration_procs__[ 0 ].should == configuration_proc
    end
  end

end