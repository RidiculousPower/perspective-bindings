
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Class do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Class
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Class
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
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_class :some_class => ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock::View, & config_proc
      
      binding_instance = binding_configuration( :some_class )
      
      binding_instance.required?.should == false
      respond_to?( :some_class ).should == true
      instance_methods.include?( :some_class ).should == true

      binding_instance.configuration_procs[ 0 ][ 0 ].should == config_proc
      binding_instance.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock::View
            
      has_binding?( :some_class ).should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock.new
    Proc.new { instance.some_class = [ Object ] }.should raise_error
    Proc.new { instance.some_class = :some_value }.should raise_error
    instance.some_class = Object
    
    instance.class.binding_configuration( :some_class ).ensure_binding_render_value_valid( instance.some_class )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock
      
      attr_unbind :some_class

    end
    
  end

  ##################
  #  attr_classes  #
  ##################
  
  it 'can define required classes' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock
      
      attr_classes :some_classes
      
      has_binding?( :some_classes ).should == true
      binding_instance = binding_configuration( :some_classes )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock.new
    Proc.new { instance.some_classes = [ :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_classes = :object }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_classes = Object
    instance.some_classes = [ Object, Class ]
    Proc.new { instance.some_classes = [ Object, :object ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
    instance.class.binding_configuration( :some_classes ).ensure_binding_render_value_valid( instance.some_classes )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock

      attr_unbind :some_classes

    end
    
  end  

  #########################
  #  attr_required_class  #
  #########################
  
  it 'can define required classes' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock
      
      attr_required_class :some_required_class
      
      has_binding?( :some_required_class ).should == true
      binding_instance = binding_configuration( :some_required_class )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock.new
    Proc.new { instance.some_required_class = [ :some_value, :some_other_value ] }.should raise_error
    Proc.new { instance.some_required_class = :some_value }.should raise_error
    instance.some_required_class = Class
    instance.some_required_class = nil
    Proc.new { instance.class.binding_configuration( :some_required_class ).ensure_binding_render_value_valid( instance.some_required_class ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock

      attr_unbind :some_required_class

    end
    
  end  

  ############################
  #  attr_required_classes  #
  ############################
  
  it 'can define required classes' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock
      
      attr_required_classes :some_required_classes
      
      has_binding?( :some_required_classes ).should == true
      binding_instance = binding_configuration( :some_required_classes )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock.new
    Proc.new { instance.some_required_classes = [ :object, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_classes = [ Object, :other ] }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_classes = :other }.should raise_error( ::Rmagnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_classes = [ Object, Class ]
    instance.some_required_classes = Object
    instance.some_required_classes = nil
    Proc.new { instance.class.binding_configuration( :some_required_classes ).ensure_binding_render_value_valid( instance.some_required_classes ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Class::Mock

      attr_unbind :some_required_classes

    end
    
  end  

end
