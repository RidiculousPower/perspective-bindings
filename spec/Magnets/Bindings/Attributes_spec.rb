
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::Attributes do

  before :all do
    
    class ::Magnets::Bindings::Attributes::Mock
      include ::Magnets::Bindings::Container
      class Container
        include ::Magnets::Bindings::Container
      end
      extend ::Magnets::Bindings::Attributes
    end
    
  end

	#######################################  Method Names  ###########################################

  ################################
  #  single_binding_method_name  #
  ################################
  
  it 'can return a method name for defining a single binding type: attr_[type]' do
    ::Magnets::Bindings::Attributes::Mock.module_eval do
      single_binding_method_name( 'text' ).should == 'attr_text'
    end
  end
  
  ##################################
  #  multiple_binding_method_name  #
  ##################################
  
  it 'can return a method name for defining a single binding type: attr_[type]s or attr_[types]es' do
    ::Magnets::Bindings::Attributes::Mock.module_eval do
      multiple_binding_method_name( 'text' ).should == 'attr_texts'
    end
  end
  
  #########################################
  #  required_single_binding_method_name  #
  #########################################
  
  it 'can return a method name for defining a single binding type: attr_required_[type]' do
    ::Magnets::Bindings::Attributes::Mock.module_eval do
      required_single_binding_method_name( 'text' ).should == 'attr_required_text'
    end
  end
  
  ###########################################
  #  required_multiple_binding_method_name  #
  ###########################################

  it 'can return a method name for defining a single binding type: attr_required_[type]s or attr_required_[types]es' do
    ::Magnets::Bindings::Attributes::Mock.module_eval do
      required_multiple_binding_method_name( 'text' ).should == 'attr_required_texts'
    end
  end

	#################################  Define and Return Classes  ####################################

  #####################################
  #  define_class_binding_class       #
  #  define_instance_binding_class    #
  #  class_binding_class              #
  #  instance_binding_class           #
  #  class_multiple_binding_class     #
  #  instance_multiple_binding_class  #
  #####################################

  it 'can define and return a class binding class for a given type' do
    ::Magnets::Bindings::Attributes::Mock.module_eval do
      define_class_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
      ::Magnets::Bindings::Types::LikeText.is_a?( ::Class ).should == true
      ::Magnets::Bindings::Types::LikeText::Multiple.is_a?( ::Class ).should == true
      define_instance_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
      ::Magnets::Bindings::Types::LikeText::InstanceBinding.is_a?( ::Class ).should == true
      ::Magnets::Bindings::Types::LikeText::InstanceBinding::Multiple.is_a?( ::Class ).should == true
      class_binding_class( 'like_text' ).should == ::Magnets::Bindings::Types::LikeText
      instance_binding_class( 'like_text' ).should == ::Magnets::Bindings::Types::LikeText::InstanceBinding
      class_multiple_binding_class( 'like_text' ).should == ::Magnets::Bindings::Types::LikeText::Multiple
      instance_multiple_binding_class( 'like_text' ).should == ::Magnets::Bindings::Types::LikeText::InstanceBinding::Multiple
    end
  end

  #########################
  #  define_binding_type  #
  #########################

  it 'can define all necessary supports for a binding type' do
    ::Magnets::Bindings::Attributes::Mock.module_eval do
      
      define_binding_type( 'also_like_text' )
      
      ::Magnets::Bindings::Types::AlsoLikeText.is_a?( ::Class ).should == true
      ::Magnets::Bindings::Types::AlsoLikeText::InstanceBinding.is_a?( ::Class ).should == true
      ::Magnets::Bindings::Types::AlsoLikeText::Multiple.is_a?( ::Class ).should == true
      ::Magnets::Bindings::Types::AlsoLikeText::InstanceBinding::Multiple.is_a?( ::Class ).should == true
      
    end
  end

end
