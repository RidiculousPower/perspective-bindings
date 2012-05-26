
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::AttributesContainer::Bindings::Class do

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

  ################
  #  attr_class  #
  ################
  
  it 'can define classes' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_class :some_class => ::Magnets::Bindings::Container::ClassInstance::Mock::Container, & config_proc
      
      binding_instance = __binding__( :some_class )
      
      binding_instance.required?.should == false
      respond_to?( :some_class ).should == true
      method_defined?( :some_class ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Magnets::Bindings::Container::ClassInstance::Mock::Container
      
      has_binding?( :some_class ).should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_class = [ Object ] }.should raise_error
    Proc.new { instance.some_class = :some_value }.should raise_error
    instance.some_class = Object
    
  end

  ##################
  #  attr_classes  #
  ##################
  
  it 'can define required classes' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_classes :some_classes
      
      has_binding?( :some_classes ).should == true
      binding_instance = __binding__( :some_classes )
      binding_instance.required?.should == false

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_classes = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_classes = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_classes = Object
    instance.some_classes = [ Object, Class ]
    Proc.new { instance.some_classes = [ Object, :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
  end  

  #########################
  #  attr_required_class  #
  #########################
  
  it 'can define required classes' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_required_class :some_required_class
      
      has_binding?( :some_required_class ).should == true
      binding_instance = __binding__( :some_required_class )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_class = [ :some_value, :some_other_value ] }.should raise_error
    Proc.new { instance.some_required_class = :some_value }.should raise_error
    instance.some_required_class = Class
    instance.some_required_class = nil
    
  end  

  ############################
  #  attr_required_classes  #
  ############################
  
  it 'can define required classes' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_required_classes :some_required_classes
      
      has_binding?( :some_required_classes ).should == true
      binding_instance = __binding__( :some_required_classes )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_classes = [ :object, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_classes = [ Object, :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_classes = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_classes = [ Object, Class ]
    instance.some_required_classes = Object
    instance.some_required_classes = nil
    
  end  

end
