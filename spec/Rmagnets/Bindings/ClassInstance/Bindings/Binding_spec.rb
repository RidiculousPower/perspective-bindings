
require_relative '../../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings::Binding do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::Binding
      extend ::Rmagnets::Bindings::ClassInstance::Bindings::View
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::Binding
        extend ::Rmagnets::Bindings::ClassInstance::Bindings::View
        attr_accessor :content
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
      
      attr_binding :some_binding, & config_proc
      attr_binding :some_other_binding, ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock::View, & config_proc
      
      has_binding?( :some_binding ).should == true
      binding_configuration( :some_binding ).required?.should == false
      respond_to?( :some_binding ).should == true
      instance_methods.include?( :some_binding ).should == true

      has_binding?( :some_binding_view ).should == true
      binding_configuration( :some_binding_view ).required?.should == false
      respond_to?( :some_binding_view ).should == true
      instance_methods.include?( :some_binding_view ).should == true

      has_binding?( :some_other_binding ).should == true
      binding_configuration( :some_other_binding ).required?.should == false
      respond_to?( :some_other_binding ).should == true
      instance_methods.include?( :some_other_binding ).should == true

      has_binding?( :some_other_binding_view ).should == true
      binding_configuration( :some_other_binding_view ).required?.should == false
      respond_to?( :some_other_binding_view ).should == true
      instance_methods.include?( :some_other_binding_view ).should == true
      binding_configuration( :some_other_binding_view ).view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock::View

      has_binding?( :another_binding ).should == false      

      config = binding_configuration( :some_binding )
      config.is_a?( ::Rmagnets::Bindings::Binding ).should == true
      config.required?.should == false
      config.configuration_procs[ 0 ][ 0 ].should == config_proc
      config.view_class.should == nil

      other_config = binding_configuration( :some_other_binding )
      other_config.view_class.should == ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock::View
      some_other_binding.__binding_instance__.view_class.should == other_config.view_class
      
      has_binding?( :some_binding ).should == true

    end
    
    instance = ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock.new
    instance.some_other_binding_view.is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock::View ).should == true

    Proc.new { instance.some_binding = [ :some_value, :some_other_value ] }.should raise_error
    instance.some_binding = :some_value
    
    # prove corresponding views work - this should only be necessary to prove once
    instance.class.binding_configuration( :some_binding ).ensure_binding_render_value_valid( instance.some_binding )
    instance.some_other_binding = :some_value
    instance.ensure_binding_render_values_valid
    instance.some_other_binding_view.is_a?( ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock::View ).should == true
    instance.some_other_binding_view.content.should == :some_value
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_unbind :some_binding, :some_other_binding

    end
    
  end

  ###################
  #  attr_bindings  #
  ###################
  
  it 'can define required bindings' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_bindings :some_bindings

      has_binding?( :some_bindings_view ).should == true
      binding_configuration( :some_bindings_view ).required?.should == false
      respond_to?( :some_bindings_view ).should == true
      instance_methods.include?( :some_bindings_view ).should == true
      
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
      
      has_binding?( :some_required_binding_view ).should == true
      binding_configuration( :some_required_binding_view ).required?.should == false
      respond_to?( :some_required_binding_view ).should == true
      instance_methods.include?( :some_required_binding_view ).should == true
      
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

      has_binding?( :some_required_bindings_view ).should == true
      binding_configuration( :some_required_bindings_view ).required?.should == false
      respond_to?( :some_required_bindings_view ).should == true
      instance_methods.include?( :some_required_bindings_view ).should == true
      
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
