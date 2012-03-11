
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Complex do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Complex
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Complex
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
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_complex :some_complex => ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock::View, & config_proc
      
      binding_instance = binding_configuration( :some_complex )
      
      binding_instance.required?.should == false
      respond_to?( :some_complex ).should == true
      instance_methods.include?( :some_complex ).should == true

      binding_instance.configuration_procs[ 0 ][ 0 ].should == config_proc
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock::View
            
      has_binding?( :some_complex ).should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock.new
    Proc.new { instance.some_complex = [ Object ] }.should raise_error
    Proc.new { instance.some_complex = :some_value }.should raise_error
    instance.some_complex = Complex( 1, 2 )
    
    instance.class.binding_configuration( :some_complex ).ensure_binding_render_value_valid( instance.some_complex )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock
      
      attr_unbind :some_complex

    end
    
  end

  ####################
  #  attr_complexes  #
  ####################
  
  it 'can define required complexes' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock
      
      attr_complexes :some_complexes
      
      has_binding?( :some_complexes ).should == true
      binding_instance = binding_configuration( :some_complexes )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock.new
    Proc.new { instance.some_complexes = [ :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_complexes = :object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_complexes = Complex( 1, 0 )
    instance.some_complexes = [ Complex( 4, 2 ), Complex( 2, 3 ) ]
    Proc.new { instance.some_complexes = [ Object, :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
    instance.class.binding_configuration( :some_complexes ).ensure_binding_render_value_valid( instance.some_complexes )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock

      attr_unbind :some_complexes

    end
    
  end  

  ###########################
  #  attr_required_complex  #
  ###########################
  
  it 'can define required complexes' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock
      
      attr_required_complex :some_required_complex
      
      has_binding?( :some_required_complex ).should == true
      binding_instance = binding_configuration( :some_required_complex )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock.new
    Proc.new { instance.some_required_complex = [ Complex( 4, 2 ), :some_other_value ] }.should raise_error
    instance.some_required_complex = Complex( 4, 2 )
    instance.some_required_complex = nil
    Proc.new { instance.class.binding_configuration( :some_required_complex ).ensure_binding_render_value_valid( instance.some_required_complex ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock

      attr_unbind :some_required_complex

    end
    
  end  

  #############################
  #  attr_required_complexes  #
  #############################
  
  it 'can define required complexes' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock
      
      attr_required_complexes :some_required_complexes
      
      has_binding?( :some_required_complexes ).should == true
      binding_instance = binding_configuration( :some_required_complexes )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock.new
    Proc.new { instance.some_required_complexes = [ Complex( 4, 2 ), :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_complexes = [ Object, Complex( 4, 2 ) ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_complexes = :other }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_complexes = [ Complex( 4, 2 ), Complex( 3, 7 ) ]
    instance.some_required_complexes = Complex( 4, 2 )
    instance.some_required_complexes = nil
    Proc.new { instance.class.binding_configuration( :some_required_complexes ).ensure_binding_render_value_valid( instance.some_required_complexes ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Complex::Mock

      attr_unbind :some_required_complexes

    end
    
  end  

end
