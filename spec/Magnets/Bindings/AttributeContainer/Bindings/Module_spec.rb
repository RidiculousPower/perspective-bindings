
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::AttributeContainer::Bindings::Module do


  before :all do
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      include ::Magnets::Bindings::Container
      class Container
        include ::Magnets::Bindings::Container
        attr_accessor :content
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
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_module :some_module => ::Magnets::Bindings::Container::ClassInstance::Mock::Container, & config_proc
      
      binding_instance = __binding__( :some_module )
      
      binding_instance.required?.should == false
      respond_to?( :some_module ).should == true
      method_defined?( :some_module ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Magnets::Bindings::Container::ClassInstance::Mock::Container
            
      has_binding?( :some_module ).should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_module = [ Object ] }.should raise_error
    Proc.new { instance.some_module = :some_value }.should raise_error
    instance.some_module = Kernel
    
  end

  ##################
  #  attr_modules  #
  ##################
  
  it 'can define required modules' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_modules :some_modules
      
      has_binding?( :some_modules ).should == true
      binding_instance = __binding__( :some_modules )
      binding_instance.required?.should == false

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_modules = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_modules = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_modules = Kernel
    instance.some_modules = [ Kernel, Kernel ]
    Proc.new { instance.some_modules = [ Kernel, :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
  end  

  ##########################
  #  attr_required_module  #
  ##########################
  
  it 'can define required modules' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_required_module :some_required_module
      
      has_binding?( :some_required_module ).should == true
      binding_instance = __binding__( :some_required_module )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_module = [ :some_value, Kernel ] }.should raise_error
    Proc.new { instance.some_required_module = :some_value }.should raise_error
    instance.some_required_module = Kernel
    instance.some_required_module = nil
    
  end  

  ###########################
  #  attr_required_modules  #
  ###########################
  
  it 'can define required modules' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_required_modules :some_required_modules
      
      has_binding?( :some_required_modules ).should == true
      binding_instance = __binding__( :some_required_modules )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_modules = [ :object, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_modules = [ Kernel, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_modules = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_modules = [ Kernel, Kernel ]
    instance.some_required_modules = Kernel
    instance.some_required_modules = nil
    
  end  

end
