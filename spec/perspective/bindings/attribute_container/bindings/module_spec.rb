
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
      
      binding_instance.required?.should == false
      respond_to?( :some_module ).should == true
      method_defined?( :some_module ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container
            
      has_binding?( :some_module ).should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_module.value = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_module.value = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_module.value = Kernel
    
  end

  ##################
  #  attr_modules  #
  ##################
  
  it 'can define required modules' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_modules :some_modules
      
      has_binding?( :some_modules ).should == true
      binding_instance = __binding__( :some_modules )
      binding_instance.required?.should == false

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_modules.value = [ :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_modules.value = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_modules.value = Kernel
    instance.some_modules.value = [ Kernel, Kernel ]
    Proc.new { instance.some_modules.value = [ Kernel, :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    
  end  

  ##########################
  #  attr_required_module  #
  ##########################
  
  it 'can define required modules' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_module :some_required_module
      
      has_binding?( :some_required_module ).should == true
      binding_instance = __binding__( :some_required_module )
      binding_instance.required?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_module.value = [ :some_value, Kernel ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_module.value = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_module.value = Kernel
    instance.some_required_module.value = nil
    
  end  

  ###########################
  #  attr_required_modules  #
  ###########################
  
  it 'can define required modules' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_modules :some_required_modules
      
      has_binding?( :some_required_modules ).should == true
      binding_instance = __binding__( :some_required_modules )
      binding_instance.required?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_modules.value = [ :object, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_modules.value = [ Kernel, :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_modules.value = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_modules.value = [ Kernel, Kernel ]
    instance.some_required_modules.value = Kernel
    instance.some_required_modules.value = nil
    
  end  

end