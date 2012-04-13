
require_relative '../../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings::File do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::File::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance::Bindings
      extend ::Magnets::Bindings::ClassInstance::Bindings::File
      class View
        include ::Magnets::Bindings::ObjectInstance
        extend ::Magnets::Bindings::ClassInstance::Bindings
        extend ::Magnets::Bindings::ClassInstance::Bindings::File
      end
    end
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  ###############
  #  attr_file  #
  ###############
  
  it 'can define classes' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::File::Mock
      
      proc_ran = false
      config_proc = Proc.new do
        proc_ran = true
      end
      
      attr_file :some_file => ::Magnets::Bindings::ClassInstance::Bindings::File::Mock::View, & config_proc
      
      binding_instance = __binding_configuration__( :some_file )
      
      binding_instance.required?.should == false
      respond_to?( :some_file ).should == true
      method_defined?( :some_file ).should == true

      binding_instance.__configuration_procs__.should == [ config_proc ]
      binding_instance.__view_class__.should == ::Magnets::Bindings::ClassInstance::Bindings::File::Mock::View
            
      has_binding?( :some_file ).should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::File::Mock.new
    Proc.new { instance.some_file = [ Object ] }.should raise_error
    Proc.new { instance.some_file = :some_value }.should raise_error
    instance.some_file = File.open( __FILE__ )
    
    instance.class.__binding_configuration__( :some_file ).ensure_binding_render_value_valid( instance.some_file )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::File::Mock
      
      attr_unbind :some_file

    end
    
  end

  #################
  #  attr_files  #
  #################
  
  it 'can define required classes' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::File::Mock
      
      attr_files :some_files
      
      has_binding?( :some_files ).should == true
      binding_instance = __binding_configuration__( :some_files )
      binding_instance.required?.should == false
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::File::Mock.new
    Proc.new { instance.some_files = [ :object, File.open( __FILE__ ) ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_files = :object }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_files = File.open( __FILE__ )
    instance.some_files = [ File.open( __FILE__ ), File.open( __FILE__ ) ]
    Proc.new { instance.some_files = [ Object, :object ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    
    instance.class.__binding_configuration__( :some_files ).ensure_binding_render_value_valid( instance.some_files )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::File::Mock

      attr_unbind :some_files

    end
    
  end  

  ########################
  #  attr_required_file  #
  ########################
  
  it 'can define required classes' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::File::Mock
      
      attr_required_file :some_required_file
      
      has_binding?( :some_required_file ).should == true
      binding_instance = __binding_configuration__( :some_required_file )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == false

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::File::Mock.new
    Proc.new { instance.some_required_file = [ File.open( __FILE__ ), :some_other_value ] }.should raise_error
    instance.some_required_file = File.open( __FILE__ )
    instance.some_required_file = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_file ).ensure_binding_render_value_valid( instance.some_required_file ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::File::Mock

      attr_unbind :some_required_file

    end
    
  end  

  ##########################
  #  attr_required_files  #
  ##########################
  
  it 'can define required classes' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::File::Mock
      
      attr_required_files :some_required_files
      
      has_binding?( :some_required_files ).should == true
      binding_instance = __binding_configuration__( :some_required_files )
      binding_instance.required?.should == true
      binding_instance.multiple_values_permitted?.should == true

    end
    
    instance = ::Magnets::Bindings::ClassInstance::Bindings::File::Mock.new
    Proc.new { instance.some_required_files = [ File.open( __FILE__ ), :other ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_files = [ Object, File.open( __FILE__ ) ] }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    Proc.new { instance.some_required_files = :other }.should raise_error( ::Magnets::Bindings::Exception::BindingInstanceInvalidTypeError )
    instance.some_required_files = [ File.open( __FILE__ ), File.open( __FILE__ ) ]
    instance.some_required_files = File.open( __FILE__ )
    instance.some_required_files = nil
    Proc.new { instance.class.__binding_configuration__( :some_required_files ).ensure_binding_render_value_valid( instance.some_required_files ) }.should raise_error( ::Magnets::Bindings::Exception::BindingRequired )
    
    class ::Magnets::Bindings::ClassInstance::Bindings::File::Mock

      attr_unbind :some_required_files

    end
    
  end  

end
