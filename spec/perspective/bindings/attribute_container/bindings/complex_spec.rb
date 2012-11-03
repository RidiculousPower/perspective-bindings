
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::Complex do

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

  ##################
  #  attr_complex  #
  ##################
  
  it 'can define complexes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_complex :some_complex => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc
      
      binding_instance = __binding__( :some_complex )
      
      binding_instance.__required__?.should == false
      respond_to?( :some_complex ).should == true
      method_defined?( :some_complex ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container
            
      __has_binding__?( :some_complex ).should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_complex.value = [ Object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_complex.value = :some_value }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_complex.value = Complex( 1, 2 )
    
  end

  ####################
  #  attr_complexes  #
  ####################
  
  it 'can define required complexes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_complexes :some_complexes
      
      __has_binding__?( :some_complexes ).should == true
      binding_instance = __binding__( :some_complexes )
      binding_instance.__required__?.should == false

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_complexes.value = [ :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_complexes.value = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_complexes.value = Complex( 1, 0 )
    instance.some_complexes.value = [ Complex( 4, 2 ), Complex( 2, 3 ) ]
    Proc.new { instance.some_complexes.value = [ Object, :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    
  end  

  ###########################
  #  attr_required_complex  #
  ###########################
  
  it 'can define required complexes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_complex :some_required_complex
      
      __has_binding__?( :some_required_complex ).should == true
      binding_instance = __binding__( :some_required_complex )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_complex.value = [ Complex( 4, 2 ), :some_other_value ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_complex.value = Complex( 4, 2 )
    instance.some_required_complex.value = nil

  end  

  #############################
  #  attr_required_complexes  #
  #############################
  
  it 'can define required complexes' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_complexes :some_required_complexes
      
      __has_binding__?( :some_required_complexes ).should == true
      binding_instance = __binding__( :some_required_complexes )
      binding_instance.__required__?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_complexes.value = [ Complex( 4, 2 ), :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_complexes.value = [ Object, Complex( 4, 2 ) ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_complexes.value = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_complexes.value = [ Complex( 4, 2 ), Complex( 3, 7 ) ]
    instance.some_required_complexes.value = Complex( 4, 2 )
    instance.some_required_complexes.value = nil
    
  end  

end
