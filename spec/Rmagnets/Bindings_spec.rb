
require_relative '../../lib/rmagnets-bindings.rb'

describe ::Rmagnets::Bindings do

  before :all do
    
    class ::Rmagnets::Bindings::Mock
      
      include ::Rmagnets::Bindings::ObjectInstance
      extend ::Rmagnets::Bindings::ClassInstance
      
      class View
        include ::Rmagnets::Bindings::ObjectInstance
        extend ::Rmagnets::Bindings::ClassInstance
        class SubView
          include ::Rmagnets::Bindings::ObjectInstance
          extend ::Rmagnets::Bindings::ClassInstance
          class SubSubView
            include ::Rmagnets::Bindings::ObjectInstance
            extend ::Rmagnets::Bindings::ClassInstance
          end
        end
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
      
      binding_configuration( :some_binding ).configuration_proc.should == configuration_proc_one
      binding_configuration( :some_other_binding ).configuration_proc.should == configuration_proc_two
      
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
      
      binding_configuration( :some_binding ).configuration_proc.should == configuration_proc_one
      binding_configuration( :some_other_binding ).configuration_proc.should == configuration_proc_two
      
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
      
      binding_configuration( :some_binding ).configuration_proc.should == configuration_proc_one
      binding_configuration( :another_binding ).configuration_proc.should == configuration_proc_one
      binding_configuration( :yet_another_binding ).configuration_proc.should == configuration_proc_one
      binding_configuration( :some_other_binding ).configuration_proc.should == configuration_proc_one

      binding_configuration( :some_binding ).view_class.should == view_class
      binding_configuration( :another_binding ).view_class.should == view_class
      binding_configuration( :yet_another_binding ).view_class.should == view_class
      binding_configuration( :some_other_binding ).view_class.should == other_view_class
      
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
  #  attr_view              #
  #  attr_text              #
  #  attr_rename            #
  #  has_binding?           #
  #  binding_instance       #
  #  attr_unbind            #
  ###########################
  
  it 'can define bindings' do
    
    class ::Rmagnets::Bindings::Mock
      
      config_proc = Proc.new do
        puts 'do some live configuration here'
      end
      
      attr_view :some_binding => ::Rmagnets::Bindings::Mock::View, & config_proc
      
      has_binding?( :some_binding ).should == true
      binding_required?( :some_binding ).should == false
      respond_to?( :some_binding ).should == true
      instance_methods.include?( :some_binding ).should == true

      has_binding?( :some_other_binding ).should == false      

      config = binding_configuration( :some_binding )
      config.is_a?( ::Rmagnets::Bindings::Binding ).should == true
      config.required?.should == false
      config.configuration_proc.should == config_proc
      config.view_class.should == ::Rmagnets::Bindings::Mock::View
      
      attr_text :some_text_binding
      
      has_binding?( :some_text_binding ).should == true
      
      attr_rename :some_text_binding, :some_renamed_text_binding
      attr_rename :some_binding, :some_renamed_binding

      has_binding?( :some_text_binding ).should == false
      has_binding?( :some_binding ).should == false
      has_binding?( :some_renamed_binding ).should == true
      has_binding?( :some_renamed_text_binding ).should == true
      
      attr_unbind :some_renamed_binding, :some_renamed_text_binding
      has_binding?( :some_renamed_binding ).should == false
      has_binding?( :some_renamed_text_binding ).should == false
      has_binding?( :some_other_binding ).should == false

    end
    
  end

  ###########################
  #  attr_required_view  #
  ###########################
  
  it 'can define required bindings' do
    
    class ::Rmagnets::Bindings::Mock
      
      attr_required_view :some_required_binding
      
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
      
      attr_view :yet_another_binding

    end
    
    Proc.new { Rmagnets::Bindings::Mock.attr_alias :yet_another_binding, :aliased_binding_name }.should raise_error( ::Rmagnets::Bindings::Exception::NoBindingError )

    class ::Rmagnets::Bindings::OtherMock
      
      attr_view :some_other_binding

      has_binding?( :some_other_binding ).should == true
      respond_to?( :some_other_binding ).should == true
      some_other_binding.is_a?( ::Rmagnets::Bindings::Binding::Router ).should == true

    end
    
    class ::Rmagnets::Bindings::Mock
      
      attr_alias :aliased_binding_name, :yet_another_binding
      attr_view :another_binding, ::Rmagnets::Bindings::OtherMock
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

      attr_unbind :yet_another_binding, :some_other_binding, :another_binding
      
    end
    
    Proc.new { ::Rmagnets::Bindings::OtherMock.attr_unbind :another_binding }.should raise_error( ::Rmagnets::Bindings::Exception::NoBindingError )
    
    class ::Rmagnets::Bindings::OtherMock
      
      attr_unbind :some_other_binding

    end
    
  end
  
	################
  #  attr_order  #
  ################

  it 'can order bindings in sequence' do
    
    class ::Rmagnets::Bindings::Mock
    
      attr_view :first_binding, :second_binding

    end
    
    Proc.new { ::Rmagnets::Bindings::Mock.attr_order :first_binding, :third_binding }.should raise_error( ::Rmagnets::Bindings::Exception::NoBindingError )

    class ::Rmagnets::Bindings::Mock

      attr_view :third_binding
      
    end

    class ::Rmagnets::Bindings::Mock
      
      attr_order :first_binding, :third_binding
      
      attr_order.should == [ :first_binding, :third_binding ]

      attr_order.insert( 1, :second_binding )

      attr_order.should == [ :first_binding, :second_binding, :third_binding ]

      attr_order :third_binding

      attr_order.should == [ :third_binding ]
      
      attr_order.clear
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
        
        class SubView
          
          class SubSubView
          end
          
          attr_view :sub_sub_binding, ::Rmagnets::Bindings::Mock::View::SubView::SubSubView

        end
        
        attr_view :sub_binding, ::Rmagnets::Bindings::Mock::View::SubView
        
      end
      
    
      attr_view :some_binding

      attr_view :renamable_sub_view, ::Rmagnets::Bindings::Mock::View
      attr_rename :renamable_sub_view, :sub_view
      binding_configurations.include?( :renamable_sub_view ).should == false
      
      attr_alias   :renamable_sub_binding, sub_view.sub_binding
      has_binding?( :renamable_sub_binding ).should == true
      respond_to?( :renamable_sub_binding ).should == true
      attr_rename  :renamable_sub_binding, :sub_binding

      attr_alias   :renamable_alias, :sub_view
      renamable_alias.should == sub_view
      attr_rename  :renamable_alias, :renamed_alias
      has_binding?( :renamable_alias ).should == false
      has_binding?( :renamed_alias ).should == true
      renamed_alias.should == sub_view

      attr_alias   :sub_sub_binding, sub_view.sub_binding.sub_sub_binding
      
      attr_text :text_only_binding
      
    end
    
    instance = ::Rmagnets::Bindings::Mock.new

    instance.sub_view.is_a?( ::Rmagnets::Bindings::Mock::View ).should == true
    instance.sub_view.sub_binding.is_a?( ::Rmagnets::Bindings::Mock::View::SubView ).should == true
    instance.sub_view.sub_binding.sub_sub_binding.is_a?( ::Rmagnets::Bindings::Mock::View::SubView::SubSubView ).should == true

    instance.sub_binding.is_a?( ::Rmagnets::Bindings::Mock::View::SubView ).should == true
    instance.sub_sub_binding.is_a?( ::Rmagnets::Bindings::Mock::View::SubView::SubSubView ).should == true


    instance.sub_view.sub_binding.should == instance.sub_binding

    instance.some_binding.should == nil
    
    instance.respond_to?( :some_binding ).should == true

    instance.respond_to?( :sub_view ).should == true
    instance.respond_to?( :sub_binding ).should == true
    instance.sub_view.sub_binding.should == instance.sub_binding

    instance.respond_to?( :sub_sub_binding ).should == true
    instance.sub_view.sub_binding.sub_sub_binding.should == instance.sub_sub_binding

    some_object = Object.new
    some_other_object = Object.new
    some_third_object = Object.new

    instance.some_binding = some_object
    instance.some_binding.should == some_object

    instance.sub_sub_binding = some_third_object
    instance.sub_view.sub_binding.sub_sub_binding.should == instance.sub_sub_binding

    instance.sub_binding = some_other_object
    instance.sub_binding.should == some_other_object
    instance.sub_view.sub_binding.should == instance.sub_binding

    Proc.new { instance.sub_sub_binding = nil }.should raise_error( ::Rmagnets::Bindings::Exception::NoBindingError )
    instance.sub_binding = nil
    instance.sub_binding.should == nil
    instance.sub_view.sub_binding.should == nil

    instance.sub_view = nil
    instance.sub_view.should == nil

    instance.text_only_binding = 'some text'
    instance.text_only_binding.should == 'some text'

    Proc.new { instance.text_only_binding = some_object }.should raise_error( ::Rmagnets::Bindings::Exception::TextBindingExpectsString )

    class ::Rmagnets::Bindings::Mock
    
      attr_unbind :some_binding, :sub_view, :text_only_binding
      
      class View
        
        class SubView
          
          attr_unbind :sub_sub_binding

        end
        attr_unbind :sub_binding
        
      end
      
    end
    
  end

  ##################################################################################################
  #    private #####################################################################################
  ##################################################################################################

	##############################
  #  ensure_required_bindings  #
  ##############################

  it 'can ensure required bindings exist' do
    
    class ::Rmagnets::Bindings::Mock
    
      attr_required_view :some_required_view
      attr_view :non_required_view

    end

    Proc.new do
      ::Rmagnets::Bindings::Mock.new.instance_eval do
        ensure_required_bindings
      end
    end#.should raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    instance = ::Rmagnets::Bindings::Mock.new
    instance.some_required_view = 'not nothing'
    Proc.new do
      instance.instance_eval do
        ensure_required_bindings
      end
    end.should_not raise_error
    
    class ::Rmagnets::Bindings::Mock
    
      attr_order :some_required_view
      
    end
    
    instance = ::Rmagnets::Bindings::Mock.new
    instance.some_required_view = 'not nothing'
    Proc.new do
      instance.instance_eval do
        ensure_required_bindings
      end
    end.should_not raise_error( ::Rmagnets::Bindings::Exception::BindingRequired )

    class ::Rmagnets::Bindings::Mock
    
      attr_order :non_required_view

    end

    Proc.new do
      ::Rmagnets::Bindings::Mock.new.instance_eval do
        ensure_required_bindings
      end
    end.should_not raise_error

    Proc.new do
      ::Rmagnets::Bindings::Mock.new.instance_eval do
        self.non_required_view = [ :illegal_array, :with_multiple_items, :although_any_array_is_illegal ]
        ensure_required_bindings
      end
    end.should raise_error( ::Rmagnets::Bindings::Exception::BindingDoesNotExpectMultiple )
    
    class ::Rmagnets::Bindings::Mock
    
      attr_order [ :non_required_view ]

    end
    
    Proc.new do
      ::Rmagnets::Bindings::Mock.new.instance_eval do
        self.non_required_view = [ :some_items, :in_array ]
        ensure_required_bindings
      end
    end.should_not raise_error
    
    class ::Rmagnets::Bindings::Mock
      
      attr_order.clear
      attr_unbind :some_required_view, :non_required_view
    
    end
    
  end

end
