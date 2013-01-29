
require_relative '../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingTypeContainer do
  
  before :all do
    proc_ran = false
    @init_with_type = ::Perspective::Bindings::BindingTypeContainer.new( :basic_type ) { proc_ran = true }
    proc_ran.should == true
    @init_with_type_and_parents = ::Perspective::Bindings::BindingTypeContainer.new( :sub_basic_type, @init_with_type, true )
  end
  
  #########################
  #  type_container_name  #
  #########################
  
  it 'it can report its type container name' do
    @init_with_type.type_container_name.should == :basic_type
  end
  
  it 'it can report its type container name when initialized with parents' do
    @init_with_type_and_parents.type_container_name.should == :sub_basic_type
  end

  ########################
  #  binding_type_class  #
  ########################
  
  it 'can return its binding type class, which is subclassed to create binding types' do
    @init_with_type.binding_type_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType ).should == true
  end
  
  ################################
  #  subclass_existing_bindings  #
  ################################
  
  it 'can report if it creates new bindings of local container binding type for bindings inherited from its parent' do
    @init_with_type_and_parents.subclass_existing_bindings.should == true
  end
  
  ########################
  #  class_binding_base  #
  ########################

  it 'has a class binding base module used for all class binding types' do
    @init_with_type.class_binding_base.ancestors.include?( ::Perspective::Bindings::BindingBase::ClassBinding ).should == true
  end

  it 'inherits its parent class binding base module' do
    @init_with_type_and_parents.class_binding_base.ancestors.include?( @init_with_type.class_binding_base ).should == true
  end

  ###########################
  #  instance_binding_base  #
  ###########################

  it 'has a instance binding base module used for all instance binding types' do
    @init_with_type.instance_binding_base.ancestors.include?( ::Perspective::Bindings::BindingBase::InstanceBinding ).should == true
  end

  it 'inherits its parent instance binding base module' do
    @init_with_type_and_parents.instance_binding_base.ancestors.include?( @init_with_type.instance_binding_base ).should == true    
  end

  ###############################
  #  nested_class_binding_base  #
  ###############################

  it 'has a nested class binding base module used for all nested class binding types' do
    @init_with_type.nested_class_binding_base.ancestors.include?( ::Perspective::Bindings::BindingBase::NestedClassBinding ).should == true
  end

  it 'inherits its parent nested class binding base module' do
    @init_with_type_and_parents.nested_class_binding_base.ancestors.include?( @init_with_type.nested_class_binding_base ).should == true
  end

  ##################################
  #  nested_instance_binding_base  #
  ##################################

  it 'has a nested instance binding base module used for all nested instance binding types' do
    @init_with_type.nested_instance_binding_base.ancestors.include?( ::Perspective::Bindings::BindingBase::NestedInstanceBinding ).should == true
  end

  it 'inherits its parent nested instance binding base module' do
    @init_with_type_and_parents.nested_instance_binding_base.ancestors.include?( @init_with_type.nested_instance_binding_base ).should == true
  end
  
end

describe ::Perspective::Bindings::BindingTypeContainer do

  before :all do
    @instance = ::Perspective::Bindings::BindingTypeContainer.new( :basic_type )
  end

	#######################################  Method Names  ###########################################

  ################################
  #  single_binding_method_name  #
  ################################
  
  it 'can return a method name for defining a single binding type: attr_[type]' do
    @instance.instance_eval do
      single_binding_method_name( 'text' ).should == 'attr_text'
    end
  end
  
  ##################################
  #  multiple_binding_method_name  #
  ##################################
  
  it 'can return a method name for defining a single binding type: attr_[type]s or attr_[types]es' do
    @instance.instance_eval do
      multiple_binding_method_name( 'text' ).should == 'attr_texts'
    end
  end
  
  #########################################
  #  required_single_binding_method_name  #
  #########################################
  
  it 'can return a method name for defining a single binding type: attr_required_[type]' do
    @instance.instance_eval do
      required_single_binding_method_name( 'text' ).should == 'attr_required_text'
    end
  end
  
  ###########################################
  #  required_multiple_binding_method_name  #
  ###########################################

  it 'can return a method name for defining a single binding type: attr_required_[type]s or attr_required_[types]es' do
    @instance.instance_eval do
      required_multiple_binding_method_name( 'text' ).should == 'attr_required_texts'
    end
  end

end

describe ::Perspective::Bindings::BindingTypeContainer do

  before :all do
    @instance = ::Perspective::Bindings::BindingTypeContainer.new( :basic_type )
    @instance.define_binding_type( :some_type )
    @instance.alias_binding_type( :some_type_alias, :some_type )
    @inheriting_instance = ::Perspective::Bindings::BindingTypeContainer.new( :sub_basic_type, @instance )
  end

  #########################
  #  define_binding_type  #
  #########################
  
  it 'should define a binding type as a container for its modules and classes' do
    @instance.binding_types[ :some_type ].ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType ).should == true
  end
  
  it 'should inherit binding types' do
    puts 'wtf: ' + ::CascadingConfiguration.configuration( @inheriting_instance, :binding_types ).parents.to_s
    @inheriting_instance.binding_types[ :some_type ].ancestors.include?( @instance.binding_types[ :some_type ] ).should == true
  end
  
  ########################
  #  alias_binding_type  #
  ########################

  it 'can alias a defined type with a second name' do
    @instance.binding_aliases[ :some_type_alias ].should == :some_type
  end

  ################################
  #  define_single_binding_type  #
  ################################
  
  it 'should define a method to create single-value bindings of type' do
    @instance.instance_methods.include?( :attr_some_type ).should == true
  end

  ##################################
  #  define_multiple_binding_type  #
  ##################################

  it 'should define a method to create multiple-value bindings of type' do
    @instance.instance_methods.include?( :attr_some_types ).should == true
  end

  #########################################
  #  define_required_single_binding_type  #
  #########################################

  it 'should define a method to create required single-value bindings of type' do
    @instance.instance_methods.include?( :attr_required_some_type ).should == true
  end

  ###########################################
  #  define_required_multiple_binding_type  #
  ###########################################

  it 'should define a method to create required multiple-value bindings of type' do
    @instance.instance_methods.include?( :attr_required_some_types ).should == true
  end

end
