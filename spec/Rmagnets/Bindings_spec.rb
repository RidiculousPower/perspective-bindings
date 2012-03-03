
require_relative '../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings do

  before :all do
    
    class Rmagnets::Bindings::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance
      
      class View
      end
    
    end
    
  end

  ###########################
  #  attr_binding           #
  #  has_binding?           #
  #  binding_configuration  #
  #  attr_unbind            #
  ###########################
  
  it 'can define bindings' do
    
    class Rmagnets::Bindings::Mock
      
      config_proc = Proc.new do
        puts 'do some live configuration here'
      end
      
      attr_binding :some_binding => ::Rmagnets::Bindings::Mock::View, & config_proc
      
      has_binding?( :some_binding ).should == true
      binding_required?( :some_binding ).should == false

      has_binding?( :some_other_binding ).should == false      

      config = binding_configuration( :some_binding )
      config.is_a?( ::Rmagnets::Bindings::ClassInstance::BindingConfiguration ).should == true
      config.required.should == false
      config.live_configuration_proc.should == config_proc
      config.view_class.should == ::Rmagnets::Bindings::Mock::View
      
      attr_unbind :some_binding
      has_binding?( :some_binding ).should == false
      
    end
    
  end

  ###########################
  #  attr_required_binding  #
  ###########################
  
  it 'can define required bindings' do
    
    class Rmagnets::Bindings::Mock
      
      attr_required_binding :some_required_binding
      
      has_binding?( :some_required_binding ).should == true
      binding_required?( :some_required_binding ).should == true

      required_bindings.should == [ :some_required_binding ]

      attr_unbind :some_required_binding

    end
    
  end
  
  ################
  #  attr_alias  #
  ################
  
  it 'can define binding aliases' do
    
    class Rmagnets::Bindings::Mock
      
      attr_binding :yet_another_binding
      
    end
    
    Proc.new { Rmagnets::Bindings::Mock.attr_alias :yet_another_binding, :aliased_binding_name }.should raise_error( ::Rmagnets::Bindings::Exception::NoBindingError )
    
    class Rmagnets::Bindings::Mock
      
      attr_alias :aliased_binding_name, :yet_another_binding
      
      has_binding?( :aliased_binding_name ).should == true
      binding_required?( :aliased_binding_name ).should == false

      attr_unbind :yet_another_binding

    end
    
  end
  
  #############################
  #  attr_rebind              #
  #  attr_rebind_as_required  #
  #  binding_is_rebinding?    #
  #############################

  it 'can rebind and unbind' do

    class Rmagnets::Bindings::Mock
      
      attr_binding :another_binding

      binding_is_rebinding?( :another_binding ).should == false
      
      attr_rebind( :another_binding, :some_other_name )

      binding_is_rebinding?( :some_other_name ).should == true

      instance_methods.include?( :another_binding ).should == false
      has_binding?( :another_binding ).should == false
      
      instance_methods.include?( :some_other_name ).should == true
      has_binding?( :some_other_name ).should == true
      has_binding?( :another_binding ).should == false
      
      binding_required?( :some_other_name ).should == false
      
      attr_rebind_as_required :some_other_name
      binding_required?( :some_other_name ).should == true      
      
      attr_unbind :another_binding
      
    end
    
  end

	################
  #  attr_order  #
  ################

  it 'can order bindings in sequence' do
    
    class Rmagnets::Bindings::Mock
    
      attr_binding :first_binding, :second_binding
    
      attr_order :first_binding, :third_binding
      
      attr_order.should == [ :first_binding, :third_binding ]

      attr_order.insert( 1, :second_binding ) == [ :first_binding, :second_binding, :third_binding ]
    
      attr_unbind :first_binding, :second_binding, :third_binding
    
    end
    
  end

  ##################
  #  bind          #
  #  has_binding?  #
  #  unbind        #
  #  binding       #
  ##################

  it 'can bind an object, report whether bound, and return the bound object' do
    
    class Rmagnets::Bindings::Mock
    
      attr_binding :some_binding
      
    end
    
    instance = Rmagnets::Bindings::Mock.new

    instance.has_binding?( :some_binding ).should == false
    
    some_object = Object.new
    instance.bind( :some_binding, some_object )
    instance.has_binding?( :some_binding ).should == true
    instance.unbind( :some_binding )
    instance.has_binding?( :some_binding ).should == false


    class Rmagnets::Bindings::Mock
    
      attr_unbind :some_binding
      
    end
    
  end

	###########################
  #  ensure_binding_exists  #
  ###########################

  it '' do
    
  end

	#####################
	#  cascade_binding  #
	#####################

  it '' do
    
  end

end
