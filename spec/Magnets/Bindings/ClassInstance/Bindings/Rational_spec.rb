
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::Rational do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance::Bindings
      extend ::Magnets::Bindings::ClassInstance::Bindings::Rational
      class View
        include ::Magnets::Bindings::ObjectInstance
        extend ::Magnets::Bindings::ClassInstance::Bindings
        extend ::Magnets::Bindings::ClassInstance::Bindings::Rational
        attr_reader :to_html_node
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
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_rational :some_rational => ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock::View, & config_proc
      
      binding_instance = __binding_configuration__( :some_rational )
      
      binding_instance.required?.should == false
      respond_to?( :some_rational ).should == true
      method_defined?( :some_rational ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock::View
            
      has_binding?( :some_rational ).should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock.new
    Proc.new { instance.some_rational = [ Object ] }.should raise_error
    Proc.new { instance.some_rational = :some_value }.should raise_error
    instance.some_rational = Rational( 1, 2 )
    
    instance.class.__binding_configuration__( :some_rational ).__ensure_render_value_valid__( instance.some_rational )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      attr_unbind :some_rational

    end
    
  end

  ####################
  #  attr_rationals  #
  ####################
  
  it 'can define required rationals' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      attr_rationals :some_rationals
      
      has_binding?( :some_rationals ).should == true
      binding_instance = __binding_configuration__( :some_rationals )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock.new
    Proc.new { instance.some_rationals = [ :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_rationals = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_rationals = Rational( 1, 4 )
    instance.some_rationals = [ Rational( 4, 2 ), Rational( 2, 3 ) ]
    Proc.new { instance.some_rationals = [ Object, :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
    instance.class.__binding_configuration__( :some_rationals ).__ensure_render_value_valid__( instance.some_rationals )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock

      attr_unbind :some_rationals

    end
    
  end  

  ###########################
  #  attr_required_rational  #
  ###########################
  
  it 'can define required rationals' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      attr_required_rational :some_required_rational
      
      has_binding?( :some_required_rational ).should == true
      binding_instance = __binding_configuration__( :some_required_rational )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock.new
    Proc.new { instance.some_required_rational = [ Rational( 4, 2 ), :some_other_value ] }.should raise_error
    instance.some_required_rational = Rational( 4, 2 )
    instance.some_required_rational = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_rational ).__ensure_render_value_valid__( instance.some_required_rational ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock

      attr_unbind :some_required_rational

    end
    
  end  

  #############################
  #  attr_required_rationals  #
  #############################
  
  it 'can define required rationals' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock
      
      attr_required_rationals :some_required_rationals
      
      has_binding?( :some_required_rationals ).should == true
      binding_instance = __binding_configuration__( :some_required_rationals )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock.new
    Proc.new { instance.some_required_rationals = [ Rational( 4, 2 ), :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_rationals = [ Object, Rational( 4, 2 ) ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_rationals = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_rationals = [ Rational( 4, 2 ), Rational( 3, 7 ) ]
    instance.some_required_rationals = Rational( 4, 2 )
    instance.some_required_rationals = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_rationals ).__ensure_render_value_valid__( instance.some_required_rationals ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Rational::Mock

      attr_unbind :some_required_rationals

    end
    
  end  

end
