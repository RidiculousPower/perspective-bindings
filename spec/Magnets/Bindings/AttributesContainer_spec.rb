
require_relative '../../../lib/magnets-bindings.rb'

describe ::Magnets::Bindings::AttributesContainer do

  before :all do
    
    class ::Magnets::Bindings::ClassBinding::MockSub < ::Magnets::Bindings::ClassBinding
    end
    class ::Magnets::Bindings::InstanceBinding::MockSub < ::Magnets::Bindings::InstanceBinding
    end
    class ::Magnets::Bindings::ClassBinding::MockSubSub < ::Magnets::Bindings::ClassBinding::MockSub
    end
    class ::Magnets::Bindings::InstanceBinding::MockSubSub < ::Magnets::Bindings::InstanceBinding::MockSub
    end
    
  end

  ################
  #  initialize  #
  ################
  
  it 'can initialize with or without a parent container and optionally specifying class and instance binding base classes as well as providing a definition block to run at the end of initialization' do
    
    proc_ran = false
    define_proc = Proc.new do
      proc_ran = true
    end
    
    # without parent container or base class specification
    instance = ::Magnets::Bindings::AttributesContainer.new( & define_proc )
    instance.base_class_binding_class.should == ::Magnets::Bindings::ClassBinding
    instance.base_instance_binding_class.should == ::Magnets::Bindings::InstanceBinding
    proc_ran.should == true
    proc_ran = false
    # without parent with base class binding class
    instance = ::Magnets::Bindings::AttributesContainer.new( nil, ::Magnets::Bindings::ClassBinding::MockSub, & define_proc )
    instance.base_class_binding_class.should == ::Magnets::Bindings::ClassBinding::MockSub
    instance.base_instance_binding_class.should == ::Magnets::Bindings::InstanceBinding
    proc_ran.should == true
    proc_ran = false
    # without parent with base instance binding class
    instance = ::Magnets::Bindings::AttributesContainer.new( nil, nil, ::Magnets::Bindings::InstanceBinding::MockSub, & define_proc )
    instance.base_class_binding_class.should == ::Magnets::Bindings::ClassBinding
    instance.base_instance_binding_class.should == ::Magnets::Bindings::InstanceBinding::MockSub
    proc_ran.should == true
    proc_ran = false
    # without parent with base class and instance binding classes
    instance = ::Magnets::Bindings::AttributesContainer.new( nil, ::Magnets::Bindings::ClassBinding::MockSub, ::Magnets::Bindings::InstanceBinding::MockSub, & define_proc )
    instance.base_class_binding_class.should == ::Magnets::Bindings::ClassBinding::MockSub
    instance.base_instance_binding_class.should == ::Magnets::Bindings::InstanceBinding::MockSub
    proc_ran.should == true
    proc_ran = false
    
    parent_instance = instance
    
    # with parent container no base class specification
    instance = ::Magnets::Bindings::AttributesContainer.new( parent_instance, & define_proc )
    instance.ancestors.include?( parent_instance ).should == true
    ::CascadingConfiguration::Variable.ancestor( parent_instance, :binding_types ).should == ::Magnets::Bindings::AttributesContainer
    ::CascadingConfiguration::Variable.ancestor( instance, :binding_types ).should == parent_instance
    instance.base_class_binding_class.should == ::Magnets::Bindings::ClassBinding::MockSub
    instance.base_instance_binding_class.should == ::Magnets::Bindings::InstanceBinding::MockSub
    proc_ran.should == true
    proc_ran = false
    # with parent container with base class binding class
    instance = ::Magnets::Bindings::AttributesContainer.new( parent_instance, ::Magnets::Bindings::ClassBinding::MockSubSub, & define_proc )
    instance.base_class_binding_class.should == ::Magnets::Bindings::ClassBinding::MockSubSub
    instance.base_instance_binding_class.should == ::Magnets::Bindings::InstanceBinding::MockSub
    proc_ran.should == true
    proc_ran = false
    # with parent container with base instance binding class
    instance = ::Magnets::Bindings::AttributesContainer.new( parent_instance, nil, ::Magnets::Bindings::InstanceBinding::MockSubSub, & define_proc )
    instance.base_class_binding_class.should == ::Magnets::Bindings::ClassBinding::MockSub
    instance.base_instance_binding_class.should == ::Magnets::Bindings::InstanceBinding::MockSubSub
    proc_ran.should == true
    proc_ran = false
    # with parent container with base class and instance binding classes
    instance = ::Magnets::Bindings::AttributesContainer.new( parent_instance, ::Magnets::Bindings::ClassBinding::MockSubSub, ::Magnets::Bindings::InstanceBinding::MockSubSub, & define_proc )
    instance.base_class_binding_class.should == ::Magnets::Bindings::ClassBinding::MockSubSub
    instance.base_instance_binding_class.should == ::Magnets::Bindings::InstanceBinding::MockSubSub
    proc_ran.should == true
    proc_ran = false
    
  end

	#######################################  Method Names  ###########################################

  ################################
  #  single_binding_method_name  #
  ################################
  
  it 'can return a method name for defining a single binding type: attr_[type]' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.single_binding_method_name( 'text' ).should == 'attr_text'
  end
  
  ##################################
  #  multiple_binding_method_name  #
  ##################################
  
  it 'can return a method name for defining a single binding type: attr_[type]s or attr_[types]es' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.multiple_binding_method_name( 'text' ).should == 'attr_texts'
  end
  
  #########################################
  #  required_single_binding_method_name  #
  #########################################
  
  it 'can return a method name for defining a single binding type: attr_required_[type]' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.required_single_binding_method_name( 'text' ).should == 'attr_required_text'
  end
  
  ###########################################
  #  required_multiple_binding_method_name  #
  ###########################################

  it 'can return a method name for defining a single binding type: attr_required_[type]s or attr_required_[types]es' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.required_multiple_binding_method_name( 'text' ).should == 'attr_required_texts'
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
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.define_class_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance::LikeText.is_a?( ::Class ).should == true
    instance::LikeText::Multiple.is_a?( ::Class ).should == true
    instance.define_instance_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance::LikeText::InstanceBinding.is_a?( ::Class ).should == true
    instance::LikeText::InstanceBinding::Multiple.is_a?( ::Class ).should == true
    instance.class_binding_class( 'like_text' ).should == instance::LikeText
    instance.instance_binding_class( 'like_text' ).should == instance::LikeText::InstanceBinding
    instance.class_multiple_binding_class( 'like_text' ).should == instance::LikeText::Multiple
    instance.instance_multiple_binding_class( 'like_text' ).should == instance::LikeText::InstanceBinding::Multiple
  end

	#######################################  Define Types  ###########################################

  ################################
  #  define_single_binding_type  #
  ################################

  it 'can define a single binding declaration method for a given type' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.define_class_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance.define_instance_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance.define_single_binding_type( 'like_text' )
    instance.method_defined?( :attr_like_text ).should == true
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  it 'can define a multiple binding declaration method for a given type' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.define_class_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance.define_instance_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance.define_multiple_binding_type( 'like_text' )
    instance.method_defined?( :attr_like_texts ).should == true
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  it 'can define a required single binding declaration method for a given type' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.define_class_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance.define_instance_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance.define_required_single_binding_type( 'like_text' )
    instance.method_defined?( :attr_required_like_text ).should == true
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  it 'can define a required multiple binding declaration method for a given type' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.define_class_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance.define_instance_binding_class( 'like_text', ::Magnets::Bindings::Attributes::Text )
    instance.define_required_multiple_binding_type( 'like_text' )
    instance.method_defined?( :attr_required_like_texts ).should == true
  end

  ############################
  #  define_binding_methods  #
  ############################

  it 'can define all necessary supports for a binding type' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.define_class_binding_class( 'also_alot_like_text', ::Magnets::Bindings::Attributes::Text )
    instance.define_instance_binding_class( 'also_alot_like_text', ::Magnets::Bindings::Attributes::Text )


    instance.define_binding_methods( 'also_alot_like_text' )

    instance.method_defined?( :attr_also_alot_like_text ).should == true
    instance.method_defined?( :attr_also_alot_like_texts ).should == true
    instance.method_defined?( :attr_required_also_alot_like_text ).should == true
    instance.method_defined?( :attr_required_also_alot_like_texts ).should == true

    class ::Magnets::Bindings::AttributesContainer::NestedContainerMock
      include ::Magnets::Bindings::Container
    end
    
    ::Magnets::Bindings::AttributesContainer::ContainerMock = ::Class.new do
      include ::Magnets::Bindings::Container
      extend instance

      new_bindings = attr_also_alot_like_text :some_binding, ::Magnets::Bindings::AttributesContainer::NestedContainerMock
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( instance::AlsoAlotLikeText ).should == true
      new_binding.required?.should == false

      new_bindings = attr_also_alot_like_texts :some_bindings, ::Magnets::Bindings::AttributesContainer::NestedContainerMock
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( instance::AlsoAlotLikeText::Multiple ).should == true
      new_binding.required?.should == false

      new_bindings = attr_required_also_alot_like_text :some_required_binding, ::Magnets::Bindings::AttributesContainer::NestedContainerMock
      new_binding = new_bindings[ 0 ]

      new_binding.is_a?( instance::AlsoAlotLikeText ).should == true
      new_binding.required?.should == true

      new_bindings = attr_required_also_alot_like_texts :some_required_bindings, ::Magnets::Bindings::AttributesContainer::NestedContainerMock
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( instance::AlsoAlotLikeText::Multiple ).should == true
      new_binding.required?.should == true

    end

    container_instance = ::Magnets::Bindings::AttributesContainer::ContainerMock.new


  end

  #########################
  #  define_binding_type  #
  #########################

  it 'can define all necessary supports for a binding type' do
    instance = ::Magnets::Bindings::AttributesContainer.new
    instance.define_binding_type( 'also_like_text' )
    instance::AlsoLikeText.is_a?( ::Class ).should == true
    instance::AlsoLikeText::InstanceBinding.is_a?( ::Class ).should == true
    instance::AlsoLikeText::Multiple.is_a?( ::Class ).should == true
    instance::AlsoLikeText::InstanceBinding::Multiple.is_a?( ::Class ).should == true
  end

  ###################
  #  binding_types  #
  ###################
  
  it 'can re-define binding types in each cascading module instance using the local base binding types' do
    parent_instance = ::Magnets::Bindings::AttributesContainer.new( nil, ::Magnets::Bindings::ClassBinding::MockSub, ::Magnets::Bindings::InstanceBinding::MockSub )
    parent_instance.define_binding_type( 'also_like_text' )
    Instance = instance = ::Magnets::Bindings::AttributesContainer.new( parent_instance, ::Magnets::Bindings::ClassBinding::MockSubSub, ::Magnets::Bindings::InstanceBinding::MockSubSub )
    instance::AlsoLikeText.is_a?( ::Class ).should == true
    instance::AlsoLikeText::InstanceBinding.is_a?( ::Class ).should == true
    instance::AlsoLikeText::Multiple.is_a?( ::Class ).should == true
    instance::AlsoLikeText::InstanceBinding::Multiple.is_a?( ::Class ).should == true
    instance::AlsoLikeText.ancestors.include?( ::Magnets::Bindings::ClassBinding::MockSubSub ).should == true
    instance::AlsoLikeText::InstanceBinding.ancestors.include?( ::Magnets::Bindings::InstanceBinding::MockSubSub ).should == true
  end

end
