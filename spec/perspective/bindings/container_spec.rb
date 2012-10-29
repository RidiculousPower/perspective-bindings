
require_relative '../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::Container do

  before :all do
    
    class ::Perspective::Bindings::Container::Mock
      
      include ::Perspective::Bindings::Container
      
      class ContentBindingView

        include ::Perspective::Bindings::Container
        
        attr_binding :content
                
      end
      
      class AutobindMultibindingsView

        include ::Perspective::Bindings::Container
        
        attr_binding :binding_one, :binding_two
                
      end
      
      attr_text :text_binding, ::Perspective::Bindings::Container::Mock::ContentBindingView
      attr_texts :texts_binding, ::Perspective::Bindings::Container::Mock::AutobindMultibindingsView
      
    end

    class ::Perspective::Bindings::Container::OtherMock
      
      include ::Perspective::Bindings::Container
      
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
    ::Perspective::Bindings::Container.instance_method( :bindings ).should == ::Perspective::Bindings::Container.instance_method( :__bindings__ )
    ::Perspective::Bindings::Container.instance_method( :binding ).should == ::Perspective::Bindings::Container.instance_method( :__binding__ )

    Perspective::Bindings::Container::Mock.__bindings__.is_a?( ::Hash ).should == true
    Perspective::Bindings::Container::Mock.__bindings__[ :text_binding ].is_a?( ::Perspective::Bindings::ClassBinding ).should == true
    Perspective::Bindings::Container::Mock.text_binding.should == Perspective::Bindings::Container::Mock.__bindings__[ :text_binding ]
    Perspective::Bindings::Container::Mock.has_binding?( :text_binding ).should == true

    instance = ::Perspective::Bindings::Container::Mock.new    
    
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :text_binding ].is_a?( ::Perspective::Bindings::InstanceBinding ).should == true
    instance.text_binding.should == instance.__bindings__[ :text_binding ]
    instance.has_binding?( :text_binding ).should == true
    
  end

  ################
  #  attr_alias  #
  ################
  
  it 'can define binding aliases' do
    
    class ::Perspective::Bindings::Container::Mock
      
      attr_binding :yet_another_binding

    end

    Proc.new { ::Perspective::Bindings::Container::Mock.attr_alias :yet_another_binding, :aliased_binding_name }.should raise_error( ::Perspective::Bindings::Exception::NoBindingError )

    class ::Perspective::Bindings::Container::OtherMock
      
      attr_binding :some_other_binding

      has_binding?( :some_other_binding ).should == true
      respond_to?( :some_other_binding ).should == true

      some_other_binding.is_a?( ::Perspective::Bindings::ClassBinding ).should == true

    end
    
    class ::Perspective::Bindings::Container::Mock

      attr_alias :aliased_binding_name, :yet_another_binding
      attr_binding :another_binding, ::Perspective::Bindings::Container::OtherMock
      attr_alias :some_other_binding, another_binding.some_other_binding

      has_binding?( :aliased_binding_name ).should == true
      aliased_binding_name.required?.should == false

      has_binding?( :another_binding ).should == true
      another_binding.required?.should == false
      respond_to?( :another_binding ).should == true
      method_defined?( :another_binding ).should == true
      
      another_binding.has_binding?( :some_other_binding ).should == true
      another_binding.respond_to?( :some_other_binding ).should == true
      another_binding.__bindings__[ :some_other_binding ].is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      another_binding.some_other_binding.is_a?( ::Perspective::Bindings::ClassBinding ).should == true

      has_binding?( :some_other_binding ).should == true
      some_other_binding.required?.should == false
      respond_to?( :some_other_binding ).should == true
      method_defined?( :some_other_binding ).should == true

      some_other_binding.is_a?( ::Perspective::Bindings::ClassBinding ).should == true
      some_other_binding.should == another_binding.some_other_binding
      
    end
    
  end

  ##################
  #  autobind      #
  #  __autobind__  #
  ##################

  it 'can autobind a data object' do

    instance = ::Perspective::Bindings::Container::Mock::ContentBindingView.new    
    instance.__autobind__( :one )
    instance.content.value.should == :one

    instance = ::Perspective::Bindings::Container::Mock::AutobindMultibindingsView.new
    data_object = Object.new
    data_object.define_singleton_method( :binding_one ) do
      :one
    end
    data_object.define_singleton_method( :binding_two ) do
      :two
    end
    instance.__autobind__( data_object )
    instance.binding_one.value.should == :one
    instance.binding_two.value.should == :two
    
  end

  ###############
  #  configure  #
  ###############

  it 'can define configuration procs to be run before rendering' do
    rspec = self
    class ::Perspective::Bindings::Container::Mock
      include ::Perspective::Bindings::Container
      configuration_proc = Proc.new do
        configuration_method
      end
      configure( & configuration_proc )
      __configuration_procs__[ 0 ].should == configuration_proc
    end
  end

end
