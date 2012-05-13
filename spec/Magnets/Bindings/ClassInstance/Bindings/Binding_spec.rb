
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::Binding do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock
      include ::Magnets::Bindings
      class View
        include ::Magnets::Bindings
        attr_accessor :content, :to_html_node
        def autobind( object )
        end
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
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_binding :some_binding, & config_proc
      attr_binding :some_other_binding, ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock::View, & config_proc
      
      has_binding?( :some_binding ).should == true
      __binding_configuration__( :some_binding ).required?.should == false
      respond_to?( :some_binding ).should == true
      method_defined?( :some_binding ).should == true

      has_binding?( :some_other_binding ).should == true
      __binding_configuration__( :some_other_binding ).required?.should == false
      respond_to?( :some_other_binding ).should == true
      method_defined?( :some_other_binding ).should == true

      has_binding?( :another_binding ).should == false      

      config = __binding_configuration__( :some_binding )
      config.is_a?( ::Magnets::Bindings::Binding ).should == true
      config.required?.should == false
      config.__configuration_procs__.should == [ config_proc ]
      config.__view_class__.should == nil

      other_config = __binding_configuration__( :some_other_binding )
      other_config.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock::View
      some_other_binding.__view_class__.should == other_config.__view_class__
      
      has_binding?( :some_binding ).should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock.new

    Proc.new { instance.some_binding = [ :some_value, :some_other_value ] }.should raise_error
    instance.some_binding = :some_value
    
    # prove corresponding views work - this should only be necessary to prove once
    instance.class.__binding_configuration__( :some_binding ).__ensure_render_value_valid__( instance.some_binding )
    instance.some_other_binding = :some_value
    instance.__ensure_binding_render_values_valid__
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_unbind :some_binding, :some_other_binding

    end
    
  end

  ###################
  #  attr_bindings  #
  ###################
  
  it 'can define required bindings' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_bindings :some_bindings

      has_binding?( :some_bindings ).should == true
      binding_instance = __binding_configuration__( :some_bindings )
      binding_instance.required?.should == false

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock.new
    instance.some_bindings = [ :some_value, :some_other_value ]
    instance.some_bindings = :some_value
    
    instance.class.__binding_configuration__( :some_bindings ).__ensure_render_value_valid__( instance.some_bindings )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock

      attr_unbind :some_bindings

    end
    
  end  

  ###########################
  #  attr_required_binding  #
  ###########################
  
  it 'can define required bindings' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_required_binding :some_required_binding
      
      has_binding?( :some_required_binding ).should == true
      binding_instance = __binding_configuration__( :some_required_binding )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock.new
    Proc.new { instance.some_required_binding = [ :some_value, :some_other_value ] }.should raise_error
    instance.some_required_binding = :some_value
    instance.some_required_binding = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock

      attr_unbind :some_required_binding

    end
    
  end  

  ############################
  #  attr_required_bindings  #
  ############################
  
  it 'can define required bindings' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock
      
      attr_required_bindings :some_required_bindings

      has_binding?( :some_required_bindings ).should == true
      binding_instance = __binding_configuration__( :some_required_bindings )
      binding_instance.required?.should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock.new
    instance.some_required_bindings = [ :some_value, :some_other_value ]
    instance.some_required_bindings = :some_value
    instance.some_required_bindings = nil
    Proc.new { instance.__ensure_binding_render_values_valid__ }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Binding::Mock

      attr_unbind :some_required_bindings

    end
    
  end  

end