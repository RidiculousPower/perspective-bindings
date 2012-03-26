
require_relative '../../../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings::ClassInstance::Bindings do

  before :all do
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mock
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance::Bindings
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
      end
      class OtherView
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance::Bindings
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
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mock
      
      view_class = ::Rmagnets::Bindings::ClassInstance::Bindings::Mock::View
      
      configuration_proc_one = Proc.new { puts 'one' }
      configuration_proc_two = Proc.new { puts 'two' }
      
      some_binding = create_binding( :some_binding, view_class, & configuration_proc_one )
      some_other_binding = create_binding( :some_other_binding, view_class, & configuration_proc_two )
      some_other_binding.__required__ = true
      
      has_binding?( :some_binding ).should == true
      has_binding?( :some_other_binding ).should == true
      has_binding?( :some_other_binding_view ).should == false
      
      binding_configuration( :some_binding ).required?.should == false
      binding_configuration( :some_other_binding ).required?.should == true
      
      binding_configuration( :some_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      binding_configuration( :some_other_binding ).__configuration_procs__.should == [ configuration_proc_two ]
      
      ::CascadingConfiguration::Methods.define_module_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_binding= ) { puts '' }
      ::CascadingConfiguration::Methods.define_module_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_other_binding= ) { puts '' }

      attr_unbind( :some_binding, :some_other_binding )
      
      has_binding?( :some_other_binding_view ).should == false
      
    end
    
  end

  ##############################
  #  create_bindings_for_hash  #
  ##############################

  it 'can create bindings from a hash' do
    
    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mock
     
      view_class = ::Rmagnets::Bindings::ClassInstance::Bindings::Mock::View
      
      configuration_proc_one = Proc.new { puts 'one' }
      configuration_proc_two = Proc.new { puts 'two' }
      
      some_binding = create_bindings_for_hash( { :some_binding => view_class }, & configuration_proc_one )[0]
      some_other_binding = create_bindings_for_hash( { :some_other_binding => view_class }, & configuration_proc_two )[0]
      some_other_binding.__required__ = true
      
      has_binding?( :some_binding ).should == true
      has_binding?( :some_other_binding ).should == true
      
      binding_configuration( :some_binding ).required?.should == false
      binding_configuration( :some_other_binding ).required?.should == true
      
      binding_configuration( :some_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      binding_configuration( :some_other_binding ).__configuration_procs__.should == [ configuration_proc_two ]
      
      ::CascadingConfiguration::Methods.define_module_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_binding= ) { puts '' }
      ::CascadingConfiguration::Methods.define_module_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_other_binding= ) { puts '' }
      attr_unbind( :some_binding, :some_other_binding )
      
    end
    
  end

  ##############################
  #  create_bindings_for_args  #
  ##############################

  it 'can create bindings from args' do

    class ::Rmagnets::Bindings::ClassInstance::Bindings::Mock
      
      view_class = ::Rmagnets::Bindings::ClassInstance::Bindings::Mock::View
      
      configuration_proc_one = Proc.new { puts 'one' }
      configuration_proc_two = Proc.new { puts 'two' }
      
      other_view_class = ::Rmagnets::Bindings::ClassInstance::Bindings::Mock::OtherView
      
      args = [ :some_binding, :another_binding, :yet_another_binding, view_class, { :some_other_binding => other_view_class } ]
      
      create_bindings_for_args( args, & configuration_proc_one )
      
      has_binding?( :some_binding ).should == true
      has_binding?( :another_binding ).should == true
      has_binding?( :yet_another_binding ).should == true
      has_binding?( :some_other_binding ).should == true
      
      binding_configuration( :some_binding ).required?.should == false
      binding_configuration( :another_binding ).required?.should == false
      binding_configuration( :yet_another_binding ).required?.should == false
      binding_configuration( :some_other_binding ).required?.should == false
      
      binding_configuration( :some_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      binding_configuration( :another_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      binding_configuration( :yet_another_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      binding_configuration( :some_other_binding ).__configuration_procs__.should == [ configuration_proc_one ]

      binding_configuration( :some_binding ).__view_class__.should == view_class
      binding_configuration( :another_binding ).__view_class__.should == view_class
      binding_configuration( :yet_another_binding ).__view_class__.should == view_class
      binding_configuration( :some_other_binding ).__view_class__.should == other_view_class
      
      ::CascadingConfiguration::Methods.define_module_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_binding= ) { puts '' }
      ::CascadingConfiguration::Methods.define_module_method( self, :another_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :another_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :another_binding= ) { puts '' }
      ::CascadingConfiguration::Methods.define_module_method( self, :yet_another_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :yet_another_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :yet_another_binding= ) { puts '' }
      ::CascadingConfiguration::Methods.define_module_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_other_binding ) { puts '' }
      ::CascadingConfiguration::Methods.define_instance_method( self, :some_other_binding= ) { puts '' }
      attr_unbind( :some_binding, :another_binding, :yet_another_binding, :some_other_binding )
      
    end
    
  end

end
