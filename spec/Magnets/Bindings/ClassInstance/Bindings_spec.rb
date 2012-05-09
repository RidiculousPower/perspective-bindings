
require_relative '../../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::ClassInstance::Bindings do

  before :all do
    class ::Magnets::Bindings::ClassInstance::Bindings::Mock
      include ::Magnets::Bindings::ObjectInstance
      extend ::Magnets::Bindings::ClassInstance::Bindings
      class View
        include ::Magnets::Bindings::ObjectInstance
        extend ::Magnets::Bindings::ClassInstance::Bindings
        attr_reader :to_html_node
      end
      class OtherView
        include ::Magnets::Bindings::ObjectInstance
        extend ::Magnets::Bindings::ClassInstance::Bindings
        attr_reader :to_html_node
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
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Mock
      
      view_class = ::Magnets::Bindings::ClassInstance::Bindings::Mock::View
      
      configuration_proc_one = Proc.new { puts 'one' }
      configuration_proc_two = Proc.new { puts 'two' }
      
      some_binding = __create_binding__( :some_binding, view_class, & configuration_proc_one )
      some_other_binding = __create_binding__( :some_other_binding, view_class, & configuration_proc_two )
      some_other_binding.__required__ = true
      
      has_binding?( :some_binding ).should == true
      has_binding?( :some_other_binding ).should == true
      has_binding?( :some_other_binding_view ).should == false
      
      __binding_configuration__( :some_binding ).required?.should == false
      __binding_configuration__( :some_other_binding ).required?.should == true
      
      __binding_configuration__( :some_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      __binding_configuration__( :some_other_binding ).__configuration_procs__.should == [ configuration_proc_two ]
      
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
  #  __create_bindings_for_hash__  #
  ##############################

  it 'can create bindings from a hash' do
    
    class ::Magnets::Bindings::ClassInstance::Bindings::Mock
     
      view_class = ::Magnets::Bindings::ClassInstance::Bindings::Mock::View
      
      configuration_proc_one = Proc.new { puts 'one' }
      configuration_proc_two = Proc.new { puts 'two' }
      
      some_binding = __create_bindings_for_hash__( { :some_binding => view_class }, & configuration_proc_one )[0]
      some_other_binding = __create_bindings_for_hash__( { :some_other_binding => view_class }, & configuration_proc_two )[0]
      some_other_binding.__required__ = true
      
      has_binding?( :some_binding ).should == true
      has_binding?( :some_other_binding ).should == true
      
      __binding_configuration__( :some_binding ).required?.should == false
      __binding_configuration__( :some_other_binding ).required?.should == true
      
      __binding_configuration__( :some_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      __binding_configuration__( :some_other_binding ).__configuration_procs__.should == [ configuration_proc_two ]
      
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
  #  __create_bindings_for_args__  #
  ##############################

  it 'can create bindings from args' do

    class ::Magnets::Bindings::ClassInstance::Bindings::Mock
      
      view_class = ::Magnets::Bindings::ClassInstance::Bindings::Mock::View
      
      configuration_proc_one = Proc.new { puts 'one' }
      configuration_proc_two = Proc.new { puts 'two' }
      
      other_view_class = ::Magnets::Bindings::ClassInstance::Bindings::Mock::OtherView
      
      args = [ :some_binding, :another_binding, :yet_another_binding, view_class, { :some_other_binding => other_view_class } ]
      
      __create_bindings_for_args__( *args, & configuration_proc_one )
      
      has_binding?( :some_binding ).should == true
      has_binding?( :another_binding ).should == true
      has_binding?( :yet_another_binding ).should == true
      has_binding?( :some_other_binding ).should == true
      
      __binding_configuration__( :some_binding ).required?.should == false
      __binding_configuration__( :another_binding ).required?.should == false
      __binding_configuration__( :yet_another_binding ).required?.should == false
      __binding_configuration__( :some_other_binding ).required?.should == false
      
      __binding_configuration__( :some_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      __binding_configuration__( :another_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      __binding_configuration__( :yet_another_binding ).__configuration_procs__.should == [ configuration_proc_one ]
      __binding_configuration__( :some_other_binding ).__configuration_procs__.should == [ configuration_proc_one ]

      __binding_configuration__( :some_binding ).__view_class__.should == view_class
      __binding_configuration__( :another_binding ).__view_class__.should == view_class
      __binding_configuration__( :yet_another_binding ).__view_class__.should == view_class
      __binding_configuration__( :some_other_binding ).__view_class__.should == other_view_class
      
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
