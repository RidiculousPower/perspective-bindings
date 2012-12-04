
require_relative '../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingTypeContainer do

  ################
  #  initialize  #
  ################
  
  it 'can initialize with or without a parent container and optionally specifying class and instance binding base classes as well as providing a definition block to run at the end of initialization' do
    
    proc_ran = false
    define_proc = Proc.new do
      proc_ran = true
    end
    
    # without parent container or base class specification
    instance = ::Perspective::Bindings::BindingTypeContainer.new( & define_proc )
    proc_ran.should == true
    proc_ran = false
    
    parent_instance = instance

  end

	#######################################  Method Names  ###########################################

  ################################
  #  single_binding_method_name  #
  ################################
  
  it 'can return a method name for defining a single binding type: attr_[type]' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.single_binding_method_name( 'text' ).should == 'attr_text'
  end
  
  ##################################
  #  multiple_binding_method_name  #
  ##################################
  
  it 'can return a method name for defining a single binding type: attr_[type]s or attr_[types]es' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.multiple_binding_method_name( 'text' ).should == 'attr_texts'
  end
  
  #########################################
  #  required_single_binding_method_name  #
  #########################################
  
  it 'can return a method name for defining a single binding type: attr_required_[type]' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.required_single_binding_method_name( 'text' ).should == 'attr_required_text'
  end
  
  ###########################################
  #  required_multiple_binding_method_name  #
  ###########################################

  it 'can return a method name for defining a single binding type: attr_required_[type]s or attr_required_[types]es' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.required_multiple_binding_method_name( 'text' ).should == 'attr_required_texts'
  end

	#################################  Define and Return Classes  ####################################

  #####################################
  #  define_class_binding_class       #
  #  define_instance_binding_class    #
  #  class_binding_class              #
  #  instance_binding_class           #
  #  nested_class_binding_class     #
  #  nested_instance_binding_class  #
  #####################################

  it 'can define and return a class binding class for a given type' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.define_class_binding_class( 'like_text' )
    instance::LikeText.is_a?( ::Class ).should == true
    instance::LikeText::NestedClassBinding.is_a?( ::Class ).should == true
    instance.define_instance_binding_class( 'like_text', ::Perspective::Bindings::BindingDefinitions::Text )
    instance::LikeText::InstanceBinding.is_a?( ::Class ).should == true
    instance::LikeText::NestedClassBinding::InstanceBinding.is_a?( ::Class ).should == true
    instance.class_binding_class( 'like_text' ).should == instance::LikeText
    instance.instance_binding_class( 'like_text' ).should == instance::LikeText::InstanceBinding
    instance.nested_class_binding_class( 'like_text' ).should == instance::LikeText::NestedClassBinding
    instance.nested_instance_binding_class( 'like_text' ).should == instance::LikeText::NestedClassBinding::InstanceBinding
  end

	#######################################  Define Types  ###########################################

  ################################
  #  define_single_binding_type  #
  ################################

  it 'can define a single binding declaration method for a given type' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.define_class_binding_class( 'like_text' )
    instance.define_instance_binding_class( 'like_text', ::Perspective::Bindings::BindingDefinitions::Text )
    instance.define_single_binding_type( 'like_text' )
    instance.method_defined?( :attr_like_text ).should == true
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  it 'can define a multiple binding declaration method for a given type' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.define_class_binding_class( 'like_text' )
    instance.define_instance_binding_class( 'like_text', ::Perspective::Bindings::BindingDefinitions::Text )
    instance.define_multiple_binding_type( 'like_text' )
    instance.method_defined?( :attr_like_texts ).should == true
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  it 'can define a required single binding declaration method for a given type' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.define_class_binding_class( 'like_text' )
    instance.define_instance_binding_class( 'like_text', ::Perspective::Bindings::BindingDefinitions::Text )
    instance.define_required_single_binding_type( 'like_text' )
    instance.method_defined?( :attr_required_like_text ).should == true
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  it 'can define a required multiple binding declaration method for a given type' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.define_class_binding_class( 'like_text' )
    instance.define_instance_binding_class( 'like_text', ::Perspective::Bindings::BindingDefinitions::Text )
    instance.define_required_multiple_binding_type( 'like_text' )
    instance.method_defined?( :attr_required_like_texts ).should == true
  end

  ############################
  #  define_binding_methods  #
  ############################

  it 'can define all necessary supports for a binding type' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.define_class_binding_class( 'also_alot_like_text' )
    instance.define_instance_binding_class( 'also_alot_like_text', ::Perspective::Bindings::BindingDefinitions::Text )


    instance.define_binding_methods( 'also_alot_like_text' )

    instance.method_defined?( :attr_also_alot_like_text ).should == true
    instance.method_defined?( :attr_also_alot_like_texts ).should == true
    instance.method_defined?( :attr_required_also_alot_like_text ).should == true
    instance.method_defined?( :attr_required_also_alot_like_texts ).should == true

    class ::Perspective::Bindings::BindingTypeContainer::NestedContainerMock
      include ::Perspective::Bindings::Container
    end
    
    ::Perspective::Bindings::BindingTypeContainer::ContainerMock = ::Class.new do
      include ::Perspective::Bindings::Container
      extend instance

      new_bindings = attr_also_alot_like_text :some_binding, ::Perspective::Bindings::BindingTypeContainer::NestedContainerMock
      new_binding = new_bindings[ 0 ]
      new_binding.is_a?( instance::AlsoAlotLikeText ).should == true
      new_binding.__required__?.should == false

      new_bindings = attr_also_alot_like_texts :some_bindings, ::Perspective::Bindings::BindingTypeContainer::NestedContainerMock
      new_binding = new_bindings[ 0 ]
      new_binding.__permits_multiple__?.should == true
      new_binding.__required__?.should == false

      new_bindings = attr_required_also_alot_like_text :some_required_binding, ::Perspective::Bindings::BindingTypeContainer::NestedContainerMock
      new_binding = new_bindings[ 0 ]

      new_binding.is_a?( instance::AlsoAlotLikeText ).should == true
      new_binding.__required__?.should == true

      new_bindings = attr_required_also_alot_like_texts :some_required_bindings, ::Perspective::Bindings::BindingTypeContainer::NestedContainerMock
      new_binding = new_bindings[ 0 ]
      new_binding.__permits_multiple__?.should == true
      new_binding.__required__?.should == true

    end

    container_instance = ::Perspective::Bindings::BindingTypeContainer::ContainerMock.new


  end

  #########################
  #  define_binding_type  #
  #########################

  it 'can define all necessary supports for a binding type' do
    instance = ::Perspective::Bindings::BindingTypeContainer.new
    instance.define_binding_type( 'also_like_text' )

    instance::AlsoLikeText.ancestors.include?( ::Perspective::Bindings::BindingBase::ClassBinding ).should == true

    instance::AlsoLikeText::InstanceBinding.ancestors.include?( ::Perspective::Bindings::BindingBase::InstanceBinding ).should == true

    instance::AlsoLikeText::NestedClassBinding.ancestors.include?( ::Perspective::Bindings::BindingBase::ClassBinding ).should == true
    instance::AlsoLikeText::NestedClassBinding.ancestors.include?( ::Perspective::Bindings::BindingBase::NestedClassBinding ).should == true

    instance::AlsoLikeText::NestedClassBinding::InstanceBinding.ancestors.include?( ::Perspective::Bindings::BindingBase::InstanceBinding ).should == true
    instance::AlsoLikeText::NestedClassBinding::NestedInstanceBinding.ancestors.include?( ::Perspective::Bindings::BindingBase::NestedInstanceBinding ).should == true

  end

  ###################
  #  binding_types  #
  ###################
  
  it 'can re-define binding types in each cascading module instance using the local base binding types' do
    parent_instance = ::Perspective::Bindings::BindingTypeContainer.new
    parent_instance.define_binding_type( 'also_like_text' )
    instance = ::Perspective::Bindings::BindingTypeContainer.new( :A, true, parent_instance )
    instance::AlsoLikeText.is_a?( ::Class ).should == true
    instance::AlsoLikeText::InstanceBinding.is_a?( ::Class ).should == true
    instance::AlsoLikeText::NestedClassBinding.is_a?( ::Class ).should == true
    instance::AlsoLikeText::NestedClassBinding::InstanceBinding.is_a?( ::Class ).should == true
  end

  it 'can parse arguments for creating bindings' do
    
    # :binding_name, ...
    # :binding_name, container_class, ...
    # :binding_name => container_class, ...
    # :binding_name1, :binding_name2 => container_class
    
    module ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock
      extend ::Perspective::Bindings::ParseBindingDeclarationArgs
      class Container1
      end
      class Container2
      end
      class Container3
      end
    end
    
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, :binding_two, :binding_three )
    result.should == { :binding_one => nil, :binding_two => nil, :binding_three => nil }
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1 )
    result.should == { :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1 }
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                                                                                                    :binding_two => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2, 
                                                                                                    :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container3 )
    result.should == { :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_two => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2, 
                       :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container3 }
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, 
                                                                                                    :binding_two, 
                                                                                                    :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1 )
    result.should == { :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_two => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1 }
    
    result = ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock.parse_binding_declaration_args( :binding_one, 
                                                                                                        :binding_two, 
                                                                                                        :binding_three, 
                                                                                                        :binding_four, ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1,
                                                                                                        :binding_five, { 
                                                                                                        :binding_six => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2,
                                                                                                        :binding_seven => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container3 },
                                                                                                        :binding_eight )
    result.should == { :binding_one => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_two => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1, 
                       :binding_three => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1,
                       :binding_four => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container1,
                       :binding_five => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2,
                       :binding_six => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container2,
                       :binding_seven => ::Perspective::Bindings::ParseBindingDeclarationArgs::Mock::Container3,
                       :binding_eight => nil }
    
  end

end
