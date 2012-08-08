
require_relative '../../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::AttributeContainer::Bindings::Rational do

  before :all do
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      include ::Perspective::Bindings::Container
      class Container
        include ::Perspective::Bindings::Container
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
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_rational :some_rational => ::Perspective::Bindings::Container::ClassInstance::Mock::Container, & config_proc
      
      binding_instance = __binding__( :some_rational )
      
      binding_instance.required?.should == false
      respond_to?( :some_rational ).should == true
      method_defined?( :some_rational ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__container_class__.should == ::Perspective::Bindings::Container::ClassInstance::Mock::Container
            
      has_binding?( :some_rational ).should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_rational = [ Object ] }.should raise_error
    Proc.new { instance.some_rational = :some_value }.should raise_error
    instance.some_rational = Rational( 1, 2 )
    
  end

  ####################
  #  attr_rationals  #
  ####################
  
  it 'can define required rationals' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_rationals :some_rationals
      
      has_binding?( :some_rationals ).should == true
      binding_instance = __binding__( :some_rationals )
      binding_instance.required?.should == false

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_rationals = [ :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_rationals = :object }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_rationals = Rational( 1, 4 )
    instance.some_rationals = [ Rational( 4, 2 ), Rational( 2, 3 ) ]
    Proc.new { instance.some_rationals = [ Object, :object ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    
  end  

  ###########################
  #  attr_required_rational  #
  ###########################
  
  it 'can define required rationals' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_rational :some_required_rational
      
      has_binding?( :some_required_rational ).should == true
      binding_instance = __binding__( :some_required_rational )
      binding_instance.required?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_rational = [ Rational( 4, 2 ), :some_other_value ] }.should raise_error
    instance.some_required_rational = Rational( 4, 2 )
    instance.some_required_rational = nil
    
  end  

  #############################
  #  attr_required_rationals  #
  #############################
  
  it 'can define required rationals' do
    
    class ::Perspective::Bindings::Container::ClassInstance::Mock
      
      attr_required_rationals :some_required_rationals
      
      has_binding?( :some_required_rationals ).should == true
      binding_instance = __binding__( :some_required_rationals )
      binding_instance.required?.should == true

    end
    
    instance = ::Perspective::Bindings::Container::ClassInstance::Mock.new
    Proc.new { instance.some_required_rationals = [ Rational( 4, 2 ), :other ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_rationals = [ Object, Rational( 4, 2 ) ] }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    Proc.new { instance.some_required_rationals = :other }.should raise_error( ::Perspective::Bindings::Exception::BindingInstanceInvalidType )
    instance.some_required_rationals = [ Rational( 4, 2 ), Rational( 3, 7 ) ]
    instance.some_required_rationals = Rational( 4, 2 )
    instance.some_required_rationals = nil
    
  end  

end
