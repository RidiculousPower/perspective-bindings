
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Rational do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Rational
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Rational
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
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_rational :some_rational => ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock::View, & config_proc
      
      binding_instance = binding_configuration( :some_rational )
      
      binding_instance.required?.should == false
      respond_to?( :some_rational ).should == true
      instance_methods.include?( :some_rational ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock::View
            
      has_binding?( :some_rational ).should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock.new
    Proc.new { instance.some_rational = [ Object ] }.should raise_error
    Proc.new { instance.some_rational = :some_value }.should raise_error
    instance.some_rational = Rational( 1, 2 )
    
    instance.class.binding_configuration( :some_rational ).ensure_binding_render_value_valid( instance.some_rational )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      attr_unbind :some_rational

    end
    
  end

  ####################
  #  attr_rationals  #
  ####################
  
  it 'can define required rationals' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      attr_rationals :some_rationals
      
      has_binding?( :some_rationals ).should == true
      binding_instance = binding_configuration( :some_rationals )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock.new
    Proc.new { instance.some_rationals = [ :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_rationals = :object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_rationals = Rational( 1, 4 )
    instance.some_rationals = [ Rational( 4, 2 ), Rational( 2, 3 ) ]
    Proc.new { instance.some_rationals = [ Object, :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
    instance.class.binding_configuration( :some_rationals ).ensure_binding_render_value_valid( instance.some_rationals )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock

      attr_unbind :some_rationals

    end
    
  end  

  ###########################
  #  attr_required_rational  #
  ###########################
  
  it 'can define required rationals' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      attr_required_rational :some_required_rational
      
      has_binding?( :some_required_rational ).should == true
      binding_instance = binding_configuration( :some_required_rational )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock.new
    Proc.new { instance.some_required_rational = [ Rational( 4, 2 ), :some_other_value ] }.should raise_error
    instance.some_required_rational = Rational( 4, 2 )
    instance.some_required_rational = nil
    Proc.new { instance.class.binding_configuration( :some_required_rational ).ensure_binding_render_value_valid( instance.some_required_rational ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock

      attr_unbind :some_required_rational

    end
    
  end  

  #############################
  #  attr_required_rationals  #
  #############################
  
  it 'can define required rationals' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      attr_required_rationals :some_required_rationals
      
      has_binding?( :some_required_rationals ).should == true
      binding_instance = binding_configuration( :some_required_rationals )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock.new
    Proc.new { instance.some_required_rationals = [ Rational( 4, 2 ), :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_rationals = [ Object, Rational( 4, 2 ) ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_rationals = :other }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_rationals = [ Rational( 4, 2 ), Rational( 3, 7 ) ]
    instance.some_required_rationals = Rational( 4, 2 )
    instance.some_required_rationals = nil
    Proc.new { instance.class.binding_configuration( :some_required_rationals ).ensure_binding_render_value_valid( instance.some_required_rationals ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Rational::Mock

      attr_unbind :some_required_rationals

    end
    
  end  

end
