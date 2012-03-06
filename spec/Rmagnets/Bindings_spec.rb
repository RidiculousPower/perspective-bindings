
require_relative '../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings do

  before :all do
    
    class ::Rmagnets::Bindings::Mock
      
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance
      
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance
      end
      class OtherView
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance
      end
    
    end

    class ::Rmagnets::Bindings::OtherMock
      
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance
      
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance
      end
      class OtherView
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance
      end
    
    end
    
  end

  ##################################################################################################
  #    private #####################################################################################
  ##################################################################################################

  ####################
  #  create_binding  #
  ####################
  
  it 'can create a binding' do
    
    class ::Rmagnets::Bindings::Mock
      
      view_class = ::Rmagnets::Bindings::Mock::View
      
      configuration_proc_one = Proc.new { puts 'one' }
      configuration_proc_two = Proc.new { puts 'two' }
      
      create_binding( :some_binding, view_class, false, false, & configuration_proc_one )
      create_binding( :some_other_binding, view_class, true, false, & configuration_proc_two )
      
      has_binding?( :some_binding ).should == true
      has_binding?( :some_other_binding ).should == true
      
      binding_required?( :some_binding ).should == false
      binding_required?( :some_other_binding ).should == true
      
      binding_instance( :some_binding ).configuration_proc.should == configuration_proc_one
      binding_instance( :some_other_binding ).configuration_proc.should == configuration_proc_two
      
      ::CascadingConfiguration::Variable.define_module_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_binding= ) { puts '' }
      ::CascadingConfiguration::Variable.define_module_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_other_binding= ) { puts '' }

      attr_unbind( :some_binding, :some_other_binding )
      
    end
    
  end

  ##############################
  #  create_bindings_for_hash  #
  ##############################

  it 'can create bindings from a hash' do
    
    class ::Rmagnets::Bindings::Mock
      
      view_class = ::Rmagnets::Bindings::Mock::View
      
      configuration_proc_one = Proc.new { puts 'one' }
      configuration_proc_two = Proc.new { puts 'two' }
      
      create_bindings_for_hash( { :some_binding => view_class }, false, false, & configuration_proc_one )
      create_bindings_for_hash( { :some_other_binding => view_class }, true, false, & configuration_proc_two )
      
      has_binding?( :some_binding ).should == true
      has_binding?( :some_other_binding ).should == true
      
      binding_required?( :some_binding ).should == false
      binding_required?( :some_other_binding ).should == true
      
      binding_instance( :some_binding ).configuration_proc.should == configuration_proc_one
      binding_instance( :some_other_binding ).configuration_proc.should == configuration_proc_two
      
      ::CascadingConfiguration::Variable.define_module_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_binding= ) { puts '' }
      ::CascadingConfiguration::Variable.define_module_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_other_binding= ) { puts '' }
      attr_unbind( :some_binding, :some_other_binding )
      
    end
    
  end

  ##############################
  #  create_bindings_for_args  #
  ##############################

  it 'can create bindings from args' do

    class ::Rmagnets::Bindings::Mock
      
      view_class = ::Rmagnets::Bindings::Mock::View
      
      configuration_proc_one = Proc.new { puts 'one' }
      configuration_proc_two = Proc.new { puts 'two' }
      
      other_view_class = ::Rmagnets::Bindings::Mock::OtherView
      
      args = [ :some_binding, :another_binding, :yet_another_binding, view_class, { :some_other_binding => other_view_class } ]
      
      create_bindings_for_args( args, false, false, & configuration_proc_one )
      
      has_binding?( :some_binding ).should == true
      has_binding?( :another_binding ).should == true
      has_binding?( :yet_another_binding ).should == true
      has_binding?( :some_other_binding ).should == true
      
      binding_required?( :some_binding ).should == false
      binding_required?( :another_binding ).should == false
      binding_required?( :yet_another_binding ).should == false
      binding_required?( :some_other_binding ).should == false
      
      binding_instance( :some_binding ).configuration_proc.should == configuration_proc_one
      binding_instance( :another_binding ).configuration_proc.should == configuration_proc_one
      binding_instance( :yet_another_binding ).configuration_proc.should == configuration_proc_one
      binding_instance( :some_other_binding ).configuration_proc.should == configuration_proc_one

      binding_instance( :some_binding ).view_class.should == view_class
      binding_instance( :another_binding ).view_class.should == view_class
      binding_instance( :yet_another_binding ).view_class.should == view_class
      binding_instance( :some_other_binding ).view_class.should == other_view_class
      
      ::CascadingConfiguration::Variable.define_module_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_binding= ) { puts '' }
      ::CascadingConfiguration::Variable.define_module_method( self, :another_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :another_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :another_binding= ) { puts '' }
      ::CascadingConfiguration::Variable.define_module_method( self, :yet_another_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :yet_another_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :yet_another_binding= ) { puts '' }
      ::CascadingConfiguration::Variable.define_module_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Variable.define_instance_method( self, :some_other_binding= ) { puts '' }
      attr_unbind( :some_binding, :another_binding, :yet_another_binding, :some_other_binding )
      
    end
    
  end

  ##################################################################################################
  #    public ######################################################################################
  ##################################################################################################

  ###########################
  #  attr_binding           #
  #  has_binding?           #
  #  binding_instance       #
  #  attr_unbind            #
  ###########################
  
  it 'can define bindings' do
    
    class ::Rmagnets::Bindings::Mock
      
      config_proc = Proc.new do
        puts 'do some live configuration here'
      end
      
      attr_binding :some_binding => ::Rmagnets::Bindings::Mock::View, & config_proc
      
      has_binding?( :some_binding ).should == true
      binding_required?( :some_binding ).should == false
      respond_to?( :some_binding ).should == true
      instance_methods.include?( :some_binding ).should == true

      has_binding?( :some_other_binding ).should == false      

      config = binding_instance( :some_binding )
      config.is_a?( ::Rmagnets::Bindings::Binding ).should == true
      config.required?.should == false
      config.configuration_proc.should == config_proc
      config.view_class.should == ::Rmagnets::Bindings::Mock::View
      
      attr_unbind :some_binding
      has_binding?( :some_binding ).should == false
      has_binding?( :some_other_binding ).should == false
      
    end
    
  end

  ###########################
  #  attr_required_binding  #
  ###########################
  
  it 'can define required bindings' do
    
    class ::Rmagnets::Bindings::Mock
      
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
    
    class ::Rmagnets::Bindings::Mock
      
      attr_binding :yet_another_binding

    end
    
    Proc.new { Rmagnets::Bindings::Mock.attr_alias :yet_another_binding, :aliased_binding_name }.should raise_error( ::Rmagnets::Bindings::Exception::NoBindingError )

    class ::Rmagnets::Bindings::OtherMock
      
      attr_binding :some_other_binding

      has_binding?( :some_other_binding ).should == true
      respond_to?( :some_other_binding ).should == true
      some_other_binding.is_a?( ::Rmagnets::Bindings::Binding::Router ).should == true

    end
    
    class ::Rmagnets::Bindings::Mock
      
      attr_alias :aliased_binding_name, :yet_another_binding
      attr_binding :another_binding, ::Rmagnets::Bindings::OtherMock
      attr_alias :some_other_binding, another_binding.some_other_binding
      
      has_binding?( :aliased_binding_name ).should == true
      binding_required?( :aliased_binding_name ).should == false

      has_binding?( :some_other_binding ).should == true
      binding_required?( :some_other_binding ).should == false
      respond_to?( :some_other_binding ).should == true
      instance_methods.include?( :some_other_binding ).should == true
      instance_methods.include?( :some_other_binding= ).should == true

      some_other_binding.is_a?( ::Rmagnets::Bindings::Binding::Router ).should == true
      some_other_binding.should == another_binding.some_other_binding

      attr_unbind :yet_another_binding, :some_other_binding
      
    end
    
    class ::Rmagnets::Bindings::OtherMock
      
      attr_unbind :some_other_binding

    end
    
  end
  
	################
  #  attr_order  #
  ################

  it 'can order bindings in sequence' do
    
    class ::Rmagnets::Bindings::Mock
    
      attr_binding :first_binding, :second_binding

    end
    
    Proc.new { ::Rmagnets::Bindings::Mock.attr_order :first_binding, :third_binding }.should raise_error

    class ::Rmagnets::Bindings::Mock

      attr_binding :third_binding
      
    end

    Proc.new { ::Rmagnets::Bindings::Mock.attr_order :first_binding, :third_binding }.should raise_error

    class ::Rmagnets::Bindings::Mock

      attr_order :third_binding
      
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
    
    class ::Rmagnets::Bindings::Mock

      class View

        attr_binding :sub_binding
        
      end
    
      attr_binding :some_binding
      attr_binding :sub_view, ::Rmagnets::Bindings::Mock::View
      attr_alias   :sub_binding, sub_view.sub_binding
      
    end
    
    instance = Rmagnets::Bindings::Mock.new
    instance.sub_view.sub_binding.__id__.should == instance.sub_binding.__id__

    instance.bound?( :some_binding ).should == false
    
    some_object = Object.new
    instance.some_binding = some_object
    instance.bound?( :some_binding ).should == true
    some_other_object = Object.new
    instance.sub_view.sub_binding.__id__.should == instance.sub_binding.__id__
    instance.sub_binding = some_other_object
    instance.sub_view.sub_binding.should == instance.sub_binding
    instance.sub_view.sub_binding.object.should == instance.sub_binding.object

    instance.bound?( :sub_binding ).should == true
    instance.sub_binding?.should == instance.bound?( :sub_binding )
    instance.unbind( :sub_binding )
    instance.bound?( :sub_binding ).should == false
    
    instance.sub_binding = some_other_object
    instance.bound?( :sub_binding ).should == true
    instance.sub_binding?.should == instance.bound?( :sub_binding )
    instance.sub_view.unbind( :sub_binding )
    instance.bound?( :sub_binding ).should == false

    class ::Rmagnets::Bindings::Mock
    
      attr_unbind :some_binding
      
      class View
        
        attr_unbind :sub_binding
        
      end
      
    end
    
  end

end
