
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Module do


  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Module
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Module
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
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      config_proc = Proc.new do
        puts 'do some live configuration here'
      end
      
      attr_module :some_module => ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock::View, & config_proc
      
      binding_instance = binding_configuration( :some_module )
      
      binding_instance.required?.should == false
      respond_to?( :some_module ).should == true
      instance_methods.include?( :some_module ).should == true

      binding_instance.configuration_procs.should == [ config_proc ]
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock::View
            
      has_binding?( :some_module ).should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock.new
    Proc.new { instance.some_module = [ Object ] }.should raise_error
    Proc.new { instance.some_module = :some_value }.should raise_error
    instance.some_module = Kernel
    
    instance.class.binding_configuration( :some_module ).ensure_binding_render_value_valid( instance.some_module )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      attr_unbind :some_module

    end
    
  end

  ##################
  #  attr_modules  #
  ##################
  
  it 'can define required modules' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      attr_modules :some_modules
      
      has_binding?( :some_modules ).should == true
      binding_instance = binding_configuration( :some_modules )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock.new
    Proc.new { instance.some_modules = [ :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_modules = :object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_modules = Kernel
    instance.some_modules = [ Kernel, Kernel ]
    Proc.new { instance.some_modules = [ Kernel, :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
    instance.class.binding_configuration( :some_modules ).ensure_binding_render_value_valid( instance.some_modules )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock

      attr_unbind :some_modules

    end
    
  end  

  ##########################
  #  attr_required_module  #
  ##########################
  
  it 'can define required modules' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      attr_required_module :some_required_module
      
      has_binding?( :some_required_module ).should == true
      binding_instance = binding_configuration( :some_required_module )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock.new
    Proc.new { instance.some_required_module = [ :some_value, Kernel ] }.should raise_error
    Proc.new { instance.some_required_module = :some_value }.should raise_error
    instance.some_required_module = Kernel
    instance.some_required_module = nil
    Proc.new { instance.class.binding_configuration( :some_required_module ).ensure_binding_render_value_valid( instance.some_required_module ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock

      attr_unbind :some_required_module

    end
    
  end  

  ###########################
  #  attr_required_modules  #
  ###########################
  
  it 'can define required modules' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock
      
      attr_required_modules :some_required_modules
      
      has_binding?( :some_required_modules ).should == true
      binding_instance = binding_configuration( :some_required_modules )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock.new
    Proc.new { instance.some_required_modules = [ :object, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_modules = [ Kernel, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_modules = :other }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_modules = [ Kernel, Kernel ]
    instance.some_required_modules = Kernel
    instance.some_required_modules = nil
    Proc.new { instance.class.binding_configuration( :some_required_modules ).ensure_binding_render_value_valid( instance.some_required_modules ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Module::Mock

      attr_unbind :some_required_modules

    end
    
  end  

end
