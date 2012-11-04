
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::File do

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

  ###############
  #  attr_file  #
  ###############
  
  it 'can define classes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_file :some_file => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc
      
      binding_instance = __binding__( :some_file )
      
      binding_instance.__required__?.should == false
      respond_to?( :some_file ).should == true
      method_defined?( :some_file ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container
            
      __has_binding__?( :some_file ).should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_file.__value__ = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_file.__value__ = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_file.__value__ = File.open( __FILE__ )
    
  end

  #################
  #  attr_files  #
  #################
  
  it 'can define required classes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_files :some_files
      
      __has_binding__?( :some_files ).should == true
      binding_instance = __binding__( :some_files )
      binding_instance.__required__?.should == false

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_files.__value__ = [ :object, File.open( __FILE__ ) ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_files.__value__ = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_files.__value__ = File.open( __FILE__ )
    instance.some_files.__value__ = [ File.open( __FILE__ ), File.open( __FILE__ ) ]
    Proc.new { instance.some_files.__value__ = [ Object, :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    
  end  

  ########################
  #  attr_required_file  #
  ########################
  
  it 'can define required classes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_file :some_required_file
      
      __has_binding__?( :some_required_file ).should == true
      binding_instance = __binding__( :some_required_file )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_file.__value__ = [ File.open( __FILE__ ), :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_file.__value__ = File.open( __FILE__ )
    instance.some_required_file.__value__ = nil

  end  

  ##########################
  #  attr_required_files  #
  ##########################
  
  it 'can define required classes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_files :some_required_files
      
      __has_binding__?( :some_required_files ).should == true
      binding_instance = __binding__( :some_required_files )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_files.__value__ = [ File.open( __FILE__ ), :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_files.__value__ = [ Object, File.open( __FILE__ ) ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_files.__value__ = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_files.__value__ = [ File.open( __FILE__ ), File.open( __FILE__ ) ]
    instance.some_required_files.__value__ = File.open( __FILE__ )
    instance.some_required_files.__value__ = nil
    
  end  

end
