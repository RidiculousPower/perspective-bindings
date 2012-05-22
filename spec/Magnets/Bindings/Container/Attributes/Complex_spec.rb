
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Types::Complex do

  before :all do
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      include ::Magnets::Bindings::Container
      class Container
        include ::Magnets::Bindings::Container
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
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_complex :some_complex => ::Magnets::Bindings::Container::ClassInstance::Mock::Container, & config_proc
      
      binding_instance = __binding__( :some_complex )
      
      binding_instance.required?.should == false
      respond_to?( :some_complex ).should == true
      method_defined?( :some_complex ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Magnets::Bindings::Container::ClassInstance::Mock::Container
            
      has_binding?( :some_complex ).should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_complex = [ Object ] }.should raise_error
    Proc.new { instance.some_complex = :some_value }.should raise_error
    instance.some_complex = Complex( 1, 2 )
    
    instance.__binding__( :some_complex ).render_value_valid?.should == true
    
  end

  ####################
  #  attr_complexes  #
  ####################
  
  it 'can define required complexes' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_complexes :some_complexes
      
      has_binding?( :some_complexes ).should == true
      binding_instance = __binding__( :some_complexes )
      binding_instance.required?.should == false

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_complexes = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_complexes = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_complexes = Complex( 1, 0 )
    instance.some_complexes = [ Complex( 4, 2 ), Complex( 2, 3 ) ]
    Proc.new { instance.some_complexes = [ Object, :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
    instance.__binding__( :some_complexes ).render_value_valid?.should == true
        
  end  

  ###########################
  #  attr_required_complex  #
  ###########################
  
  it 'can define required complexes' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_required_complex :some_required_complex
      
      has_binding?( :some_required_complex ).should == true
      binding_instance = __binding__( :some_required_complex )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_complex = [ Complex( 4, 2 ), :some_other_value ] }.should raise_error
    instance.some_required_complex = Complex( 4, 2 )
    instance.some_required_complex = nil

  end  

  #############################
  #  attr_required_complexes  #
  #############################
  
  it 'can define required complexes' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_required_complexes :some_required_complexes
      
      has_binding?( :some_required_complexes ).should == true
      binding_instance = __binding__( :some_required_complexes )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_complexes = [ Complex( 4, 2 ), :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_complexes = [ Object, Complex( 4, 2 ) ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_complexes = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_complexes = [ Complex( 4, 2 ), Complex( 3, 7 ) ]
    instance.some_required_complexes = Complex( 4, 2 )
    instance.some_required_complexes = nil
    
  end  

end
