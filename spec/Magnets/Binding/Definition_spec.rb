
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Binding::Definition do

  before :all do
    
    class ::Magnets::Binding::Definition::Mock
      module ClassInstance
      end
      module ObjectInstance
      end
      extend ClassInstance
      include ObjectInstance
      class View
        attr_reader :to_html_node
      end
      extend ::Magnets::Binding::Definition
    end
    
  end

  ##################################################################################################
  #   private ######################################################################################
  ##################################################################################################

	#######################################  Method Names  ###########################################

  #########################################
  #  method_name_for_single_binding_type  #
  #########################################
  
  it 'can return a method name for defining a single binding type: attr_[type]' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      method_name_for_single_binding_type( 'text' ).should == 'attr_text'
    end
  end
  
  ###########################################
  #  method_name_for_multiple_binding_type  #
  ###########################################
  
  it 'can return a method name for defining a single binding type: attr_[type]s or attr_[types]es' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      method_name_for_multiple_binding_type( 'text' ).should == 'attr_texts'
    end
  end
  
  ##################################################
  #  method_name_for_required_single_binding_type  #
  ##################################################
  
  it 'can return a method name for defining a single binding type: attr_required_[type]' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      method_name_for_required_single_binding_type( 'text' ).should == 'attr_required_text'
    end
  end
  
  ####################################################
  #  method_name_for_required_multiple_binding_type  #
  ####################################################

  it 'can return a method name for defining a single binding type: attr_required_[type]s or attr_required_[types]es' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      method_name_for_required_multiple_binding_type( 'text' ).should == 'attr_required_texts'
    end
  end

	#################################  Define and Return Classes  ####################################

  ##############################################
  #  define_class_for_class_binding_type       #
  #  define_class_for_instance_binding_type    #
  #  class_for_class_binding_type              #
  #  class_for_instance_binding_type           #
  #  class_for_multiple_class_binding_type     #
  #  class_for_multiple_instance_binding_type  #
  ##############################################

  it 'can define and return a class binding class for a given type' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      define_class_for_class_binding_type( 'like_text', ::Magnets::Binding::Definition::Text )
      ::Magnets::Binding::Types::LikeText.is_a?( ::Class ).should == true
      ::Magnets::Binding::Types::LikeText::Multiple.is_a?( ::Class ).should == true
      define_class_for_instance_binding_type( 'like_text', ::Magnets::Binding::Definition::Text )
      ::Magnets::Binding::Types::LikeText::InstanceBinding.is_a?( ::Class ).should == true
      ::Magnets::Binding::Types::LikeText::InstanceBinding::Multiple.is_a?( ::Class ).should == true
      class_for_class_binding_type( 'like_text' ).should == ::Magnets::Binding::Types::LikeText
      class_for_instance_binding_type( 'like_text' ).should == ::Magnets::Binding::Types::LikeText::InstanceBinding
      class_for_multiple_class_binding_type( 'like_text' ).should == ::Magnets::Binding::Types::LikeText::Multiple
      class_for_multiple_instance_binding_type( 'like_text' ).should == ::Magnets::Binding::Types::LikeText::InstanceBinding::Multiple
    end
  end


	#######################################  Define Types  ###########################################

  ################################
  #  define_single_binding_type  #
  ################################

  it 'can define a single binding declaration method for a given type' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      define_single_binding_type( 'like_text' )
      ::Magnets::Binding::Definition::Mock::ClassInstance.method_defined?( :attr_like_text ).should == true
    end
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  it 'can define a multiple binding declaration method for a given type' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      define_multiple_binding_type( 'like_text' )
      ::Magnets::Binding::Definition::Mock::ClassInstance.method_defined?( :attr_like_texts ).should == true
    end
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  it 'can define a required single binding declaration method for a given type' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      define_required_single_binding_type( 'like_text' )
      ::Magnets::Binding::Definition::Mock::ClassInstance.method_defined?( :attr_required_like_text ).should == true
    end
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  it 'can define a required multiple binding declaration method for a given type' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      define_required_multiple_binding_type( 'like_text' )
      ::Magnets::Binding::Definition::Mock::ClassInstance.method_defined?( :attr_required_like_texts ).should == true
    end
  end

  ##################################################################################################
  #   public #######################################################################################
  ##################################################################################################

  #########################
  #  define_binding_type  #
  #########################

  it 'can define all necessary supports for a binding type' do
    ::Magnets::Binding::Definition::Mock.module_eval do
      
      define_binding_type( 'also_like_text' )
      
      ::Magnets::Binding::Definition::Mock::ClassInstance.method_defined?( :attr_also_like_text ).should == true
      ::Magnets::Binding::Definition::Mock::ClassInstance.method_defined?( :attr_also_like_texts ).should == true
      ::Magnets::Binding::Definition::Mock::ClassInstance.method_defined?( :attr_required_also_like_text ).should == true
      ::Magnets::Binding::Definition::Mock::ClassInstance.method_defined?( :attr_required_also_like_texts ).should == true

      new_bindings = attr_also_like_text :some_binding, ::Magnets::Binding::Definition::Mock::View
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( ::Magnets::Binding::Types::AlsoLikeText ).should == true
      new_binding.required?.should == false

      new_bindings = attr_also_like_texts :some_bindings, ::Magnets::Binding::Definition::Mock::View
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( ::Magnets::Binding::Types::AlsoLikeText::Multiple ).should == true
      new_binding.required?.should == false

      new_bindings = attr_required_also_like_text :some_required_binding, ::Magnets::Binding::Definition::Mock::View
      new_binding = new_bindings[ 0 ]

      new_binding.is_a?( ::Magnets::Binding::Types::AlsoLikeText ).should == true
      new_binding.required?.should == true

      new_bindings = attr_required_also_like_texts :some_required_bindings, ::Magnets::Binding::Definition::Mock::View
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( ::Magnets::Binding::Types::AlsoLikeText::Multiple ).should == true
      new_binding.required?.should == true
      
    end
  end

end
