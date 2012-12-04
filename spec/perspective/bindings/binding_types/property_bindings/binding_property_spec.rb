
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding do

  before :all do
    class ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock
      include ::Perspective::Bindings::Container
      class Container
        include ::Perspective::Bindings::Container
        attr_binding :content
        def autobind( object )
        end
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  ###########################
  #  attr_binding           #
  #  __has_binding__?       #
  #  binding_configuration  #
  ###########################
  
  it 'can define bindings' do
    
    class ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_binding :some_binding, & config_proc
      attr_binding :some_other_binding, ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock::Container, & config_proc
      
      __has_binding__?( :some_binding ).should == true
      __binding__( :some_binding ).__required__?.should == false
      respond_to?( :some_binding ).should == true
      method_defined?( :some_binding ).should == true

      __has_binding__?( :some_other_binding ).should == true
      __binding__( :some_other_binding ).__required__?.should == false
      respond_to?( :some_other_binding ).should == true
      method_defined?( :some_other_binding ).should == true

      __has_binding__?( :another_binding ).should == false      

      config = __binding__( :some_binding )
      config.is_a?( ::Perspective::Bindings::BindingBase::ClassBinding ).should == true
      config.__required__?.should == false
      config.__configuration_procs__.should == [ config_proc ]
      config.__container_class__.should == nil

      other_config = __binding__( :some_other_binding )
      other_config.__container_class__.should == ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock::Container
      some_other_binding.__container_class__.should == other_config.__container_class__
      
      __has_binding__?( :some_binding ).should == true

    end
    
    instance = ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock.new

    Proc.new { instance.some_binding.__value__ = [ :some_value, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_binding.__value__ = :some_value
    
    # prove corresponding containers work - this should only be necessary to prove once
    instance.__binding__( :some_binding )
    instance.some_other_binding.__value__ = :some_value
    
  end

  ###################
  #  attr_bindings  #
  ###################
  
  it 'can define required bindings' do
    
    class ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock
      
      attr_bindings :some_bindings

      __has_binding__?( :some_bindings ).should == true
      binding_instance = __binding__( :some_bindings )
      binding_instance.__required__?.should == false

    end
    
    instance = ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock.new
    instance.some_bindings.__value__ = [ :some_value, :some_other_value ]
    instance.some_bindings.__value__ = :some_value
        
  end  

  ###########################
  #  attr_required_binding  #
  ###########################
  
  it 'can define required bindings' do
    
    class ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock
      
      attr_required_binding :some_required_binding
      
      __has_binding__?( :some_required_binding ).should == true
      binding_instance = __binding__( :some_required_binding )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock.new
    Proc.new { instance.some_required_binding.__value__ = [ :some_value, :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_binding.__value__ = :some_value
    instance.some_required_binding.__value__ = nil
    
  end  

  ############################
  #  attr_required_bindings  #
  ############################
  
  it 'can define required bindings' do
    
    class ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock
      
      attr_required_bindings :some_required_bindings

      __has_binding__?( :some_required_bindings ).should == true
      binding_instance = __binding__( :some_required_bindings )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::BindingTypeContainer::Bindings::Binding::Mock.new
    instance.some_required_bindings.__value__ = [ :some_value, :some_other_value ]
    instance.some_required_bindings.__value__ = :some_value
    instance.some_required_bindings.__value__ = nil
    
  end  

end
