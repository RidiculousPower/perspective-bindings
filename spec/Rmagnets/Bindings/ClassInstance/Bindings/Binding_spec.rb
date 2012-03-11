
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Binding do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Binding
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Binding
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  ###########################
  #  attr_binding           #
  #  has_binding?           #
  #  binding_configuration  #
  ###########################
  
  it 'can define bindings' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_binding :some_binding => ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock::View, & config_proc
      
      has_binding?( :some_binding ).should == true
      binding_configuration( :some_binding ).required?.should == false
      respond_to?( :some_binding ).should == true
      instance_methods.include?( :some_binding ).should == true

      has_binding?( :some_other_binding ).should == false      

      config = binding_configuration( :some_binding )
      config.is_a?( ::Rmagnets::Bindings::Binding ).should == true
      config.required?.should == false
      config.configuration_procs[0].instance_variable_get( :@configuration_proc ).should == config_proc
      config.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock::View
            
      has_binding?( :some_binding ).should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock.new
    Proc.new { instance.some_binding = [ :some_value, :some_other_value ] }.should raise_error
    instance.some_binding = :some_value
    
    instance.class.binding_configuration( :some_binding ).ensure_binding_render_value_valid( instance.some_binding )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_unbind :some_binding

    end
    
  end

  ###################
  #  attr_bindings  #
  ###################
  
  it 'can define required bindings' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_bindings :some_bindings
      
      has_binding?( :some_bindings ).should == true
      binding_instance = binding_configuration( :some_bindings )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock.new
    instance.some_bindings = [ :some_value, :some_other_value ]
    instance.some_bindings = :some_value
    
    instance.class.binding_configuration( :some_bindings ).ensure_binding_render_value_valid( instance.some_bindings )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock

      attr_unbind :some_bindings

    end
    
  end  

  ###########################
  #  attr_required_binding  #
  ###########################
  
  it 'can define required bindings' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_required_binding :some_required_binding
      
      has_binding?( :some_required_binding ).should == true
      binding_instance = binding_configuration( :some_required_binding )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock.new
    Proc.new { instance.some_required_binding = [ :some_value, :some_other_value ] }.should raise_error
    instance.some_required_binding = :some_value
    instance.some_required_binding = nil
    Proc.new { instance.class.binding_configuration( :some_required_binding ).ensure_binding_render_value_valid( instance.some_required_binding ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock

      attr_unbind :some_required_binding

    end
    
  end  

  ############################
  #  attr_required_bindings  #
  ############################
  
  it 'can define required bindings' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_required_bindings :some_required_bindings
      
      has_binding?( :some_required_bindings ).should == true
      binding_instance = binding_configuration( :some_required_bindings )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock.new
    instance.some_required_bindings = [ :some_value, :some_other_value ]
    instance.some_required_bindings = :some_value
    instance.some_required_bindings = nil
    Proc.new { instance.class.binding_configuration( :some_required_bindings ).ensure_binding_render_value_valid( instance.some_required_bindings ) }.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock

      attr_unbind :some_required_bindings

    end
    
  end  

end
