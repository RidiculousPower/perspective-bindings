
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Container::ClassInstance::Bindings::Complex do

  before :all do
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock
      include ::Magnets::Bindings
      class View
        include ::Magnets::Bindings
        attr_reader :to_html_node
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
    
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_complex :some_complex => ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock::View, & config_proc
      
      binding_instance = __binding_configuration__( :some_complex )
      
      binding_instance.required?.should == false
      respond_to?( :some_complex ).should == true
      method_defined?( :some_complex ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock::View
            
      has_binding?( :some_complex ).should == true

    end
    
    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock.new
    Proc.new { instance.some_complex = [ Object ] }.should raise_error
    Proc.new { instance.some_complex = :some_value }.should raise_error
    instance.some_complex = Complex( 1, 2 )
    
    instance.class.__binding_configuration__( :some_complex ).render_value_valid?( instance.some_complex )
    
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock
      
      attr_unbind :some_complex

    end
    
  end

  ####################
  #  attr_complexes  #
  ####################
  
  it 'can define required complexes' do
    
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock
      
      attr_complexes :some_complexes
      
      has_binding?( :some_complexes ).should == true
      binding_instance = __binding_configuration__( :some_complexes )
      binding_instance.required?.should == false

    end
    
    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock.new
    Proc.new { instance.some_complexes = [ :object ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_complexes = :object }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    instance.some_complexes = Complex( 1, 0 )
    instance.some_complexes = [ Complex( 4, 2 ), Complex( 2, 3 ) ]
    Proc.new { instance.some_complexes = [ Object, :object ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    
    instance.class.__binding_configuration__( :some_complexes ).render_value_valid?( instance.some_complexes )
    
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock

      attr_unbind :some_complexes

    end
    
  end  

  ###########################
  #  attr_required_complex  #
  ###########################
  
  it 'can define required complexes' do
    
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock
      
      attr_required_complex :some_required_complex
      
      has_binding?( :some_required_complex ).should == true
      binding_instance = __binding_configuration__( :some_required_complex )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock.new
    Proc.new { instance.some_required_complex = [ Complex( 4, 2 ), :some_other_value ] }.should raise_error
    instance.some_required_complex = Complex( 4, 2 )
    instance.some_required_complex = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Binding::Exception::BindingRequired )
    
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock

      attr_unbind :some_required_complex

    end
    
  end  

  #############################
  #  attr_required_complexes  #
  #############################
  
  it 'can define required complexes' do
    
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock
      
      attr_required_complexes :some_required_complexes
      
      has_binding?( :some_required_complexes ).should == true
      binding_instance = __binding_configuration__( :some_required_complexes )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock.new
    Proc.new { instance.some_required_complexes = [ Complex( 4, 2 ), :other ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_complexes = [ Object, Complex( 4, 2 ) ] }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_complexes = :other }.should raise_error( ::Magnets::Binding::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_complexes = [ Complex( 4, 2 ), Complex( 3, 7 ) ]
    instance.some_required_complexes = Complex( 4, 2 )
    instance.some_required_complexes = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Binding::Exception::BindingRequired )
    
    class ::Magnets::Binding::Container::ClassInstance::Bindings::Complex::Mock

      attr_unbind :some_required_complexes

    end
    
  end  

end
