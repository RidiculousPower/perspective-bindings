
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::Module do


  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance::Bindings
      extend ::Magnets::Bindings::ClassInstance::Bindings::Module
      class View
        include ::Magnets::Bindings::ObjectInstance
        extend ::Magnets::Bindings::ClassInstance::Bindings
        extend ::Magnets::Bindings::ClassInstance::Bindings::Module
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
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_module :some_module => ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock::View, & config_proc
      
      binding_instance = __binding_configuration__( :some_module )
      
      binding_instance.required?.should == false
      respond_to?( :some_module ).should == true
      method_defined?( :some_module ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock::View
            
      has_binding?( :some_module ).should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock.new
    Proc.new { instance.some_module = [ Object ] }.should raise_error
    Proc.new { instance.some_module = :some_value }.should raise_error
    instance.some_module = Kernel
    
    instance.class.__binding_configuration__( :some_module ).ensure_binding_render_value_valid( instance.some_module )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      attr_unbind :some_module

    end
    
  end

  ##################
  #  attr_modules  #
  ##################
  
  it 'can define required modules' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      attr_modules :some_modules
      
      has_binding?( :some_modules ).should == true
      binding_instance = __binding_configuration__( :some_modules )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock.new
    Proc.new { instance.some_modules = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_modules = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_modules = Kernel
    instance.some_modules = [ Kernel, Kernel ]
    Proc.new { instance.some_modules = [ Kernel, :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
    instance.class.__binding_configuration__( :some_modules ).ensure_binding_render_value_valid( instance.some_modules )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock

      attr_unbind :some_modules

    end
    
  end  

  ##########################
  #  attr_required_module  #
  ##########################
  
  it 'can define required modules' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      attr_required_module :some_required_module
      
      has_binding?( :some_required_module ).should == true
      binding_instance = __binding_configuration__( :some_required_module )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock.new
    Proc.new { instance.some_required_module = [ :some_value, Kernel ] }.should raise_error
    Proc.new { instance.some_required_module = :some_value }.should raise_error
    instance.some_required_module = Kernel
    instance.some_required_module = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_module ).ensure_binding_render_value_valid( instance.some_required_module ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock

      attr_unbind :some_required_module

    end
    
  end  

  ###########################
  #  attr_required_modules  #
  ###########################
  
  it 'can define required modules' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      attr_required_modules :some_required_modules
      
      has_binding?( :some_required_modules ).should == true
      binding_instance = __binding_configuration__( :some_required_modules )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock.new
    Proc.new { instance.some_required_modules = [ :object, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_modules = [ Kernel, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_modules = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_modules = [ Kernel, Kernel ]
    instance.some_required_modules = Kernel
    instance.some_required_modules = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_modules ).ensure_binding_render_value_valid( instance.some_required_modules ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Module::Mock

      attr_unbind :some_required_modules

    end
    
  end  

end
