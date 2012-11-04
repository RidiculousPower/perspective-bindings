
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::Module do


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

  #################
  #  attr_module  #
  #################
  
  it 'can define modules' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_module :some_module => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc
      
      binding_instance = __binding__( :some_module )
      
      binding_instance.__required__?.should == false
      respond_to?( :some_module ).should == true
      method_defined?( :some_module ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container
            
      __has_binding__?( :some_module ).should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_module.__value__ = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_module.__value__ = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_module.__value__ = Kernel
    
  end

  ##################
  #  attr_modules  #
  ##################
  
  it 'can define required modules' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_modules :some_modules
      
      __has_binding__?( :some_modules ).should == true
      binding_instance = __binding__( :some_modules )
      binding_instance.__required__?.should == false

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_modules.__value__ = [ :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_modules.__value__ = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_modules.__value__ = Kernel
    instance.some_modules.__value__ = [ Kernel, Kernel ]
    Proc.new { instance.some_modules.__value__ = [ Kernel, :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    
  end  

  ##########################
  #  attr_required_module  #
  ##########################
  
  it 'can define required modules' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_module :some_required_module
      
      __has_binding__?( :some_required_module ).should == true
      binding_instance = __binding__( :some_required_module )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_module.__value__ = [ :some_value, Kernel ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_module.__value__ = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_module.__value__ = Kernel
    instance.some_required_module.__value__ = nil
    
  end  

  ###########################
  #  attr_required_modules  #
  ###########################
  
  it 'can define required modules' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_modules :some_required_modules
      
      __has_binding__?( :some_required_modules ).should == true
      binding_instance = __binding__( :some_required_modules )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_modules.__value__ = [ :object, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_modules.__value__ = [ Kernel, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_modules.__value__ = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_modules.__value__ = [ Kernel, Kernel ]
    instance.some_required_modules.__value__ = Kernel
    instance.some_required_modules.__value__ = nil
    
  end  

end
