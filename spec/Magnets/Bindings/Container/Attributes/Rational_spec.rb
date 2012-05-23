
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Types::Rational do

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

  ##################
  #  attr_rational  #
  ##################
  
  it 'can define rationals' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_rational :some_rational => ::Magnets::Bindings::Container::ClassInstance::Mock::Container, & config_proc
      
      binding_instance = __binding__( :some_rational )
      
      binding_instance.required?.should == false
      respond_to?( :some_rational ).should == true
      method_defined?( :some_rational ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Magnets::Bindings::Container::ClassInstance::Mock::Container
            
      has_binding?( :some_rational ).should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_rational = [ Object ] }.should raise_error
    Proc.new { instance.some_rational = :some_value }.should raise_error
    instance.some_rational = Rational( 1, 2 )
    
  end

  ####################
  #  attr_rationals  #
  ####################
  
  it 'can define required rationals' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_rationals :some_rationals
      
      has_binding?( :some_rationals ).should == true
      binding_instance = __binding__( :some_rationals )
      binding_instance.required?.should == false

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_rationals = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_rationals = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_rationals = Rational( 1, 4 )
    instance.some_rationals = [ Rational( 4, 2 ), Rational( 2, 3 ) ]
    Proc.new { instance.some_rationals = [ Object, :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
  end  

  ###########################
  #  attr_required_rational  #
  ###########################
  
  it 'can define required rationals' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_required_rational :some_required_rational
      
      has_binding?( :some_required_rational ).should == true
      binding_instance = __binding__( :some_required_rational )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_rational = [ Rational( 4, 2 ), :some_other_value ] }.should raise_error
    instance.some_required_rational = Rational( 4, 2 )
    instance.some_required_rational = nil
    
  end  

  #############################
  #  attr_required_rationals  #
  #############################
  
  it 'can define required rationals' do
    
    class ::Magnets::Bindings::Container::ClassInstance::Mock
      
      attr_required_rationals :some_required_rationals
      
      has_binding?( :some_required_rationals ).should == true
      binding_instance = __binding__( :some_required_rationals )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_rationals = [ Rational( 4, 2 ), :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_rationals = [ Object, Rational( 4, 2 ) ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_rationals = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_rationals = [ Rational( 4, 2 ), Rational( 3, 7 ) ]
    instance.some_required_rationals = Rational( 4, 2 )
    instance.some_required_rationals = nil
    
  end  

end
