
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::Class do

  before :all do
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      include ::Perspective::Bindings::Container
      class Container
        include ::Perspective::Bindings::Container
        attr_binding :content
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  ################
  #  attr_class  #
  ################
  
  it 'can define classes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_class :some_class => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc
      
      binding_instance = __binding__( :some_class )
      
      binding_instance.__required__?.should == false
      respond_to?( :some_class ).should == true
      method_defined?( :some_class ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container
      
      __has_binding__?( :some_class ).should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_class.value = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_class.value = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_class.value = Object
    
  end

  ##################
  #  attr_classes  #
  ##################
  
  it 'can define required classes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_classes :some_classes
      
      __has_binding__?( :some_classes ).should == true
      binding_instance = __binding__( :some_classes )
      binding_instance.__required__?.should == false

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_classes.value = [ :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_classes.value = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_classes.value = Object
    instance.some_classes.value = [ Object, Class ]
    Proc.new { instance.some_classes.value = [ Object, :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    
  end  

  #########################
  #  attr_required_class  #
  #########################
  
  it 'can define required classes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_class :some_required_class
      
      __has_binding__?( :some_required_class ).should == true
      binding_instance = __binding__( :some_required_class )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_class.value = [ :some_value, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_class.value = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_class.value = Class
    instance.some_required_class.value = nil
    
  end  

  ############################
  #  attr_required_classes  #
  ############################
  
  it 'can define required classes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_classes :some_required_classes
      
      __has_binding__?( :some_required_classes ).should == true
      binding_instance = __binding__( :some_required_classes )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_classes.value = [ :object, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_classes.value = [ Object, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_classes.value = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_classes.value = [ Object, Class ]
    instance.some_required_classes.value = Object
    instance.some_required_classes.value = nil
    
  end  

end
