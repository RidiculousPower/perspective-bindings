
require_relative '../../../../lib/perspective/bindings.rb'

require_relative '../../../support/named_class_and_module.rb'

describe ::Perspective::Bindings::BindingTypeContainer::BindingType do
  
  let( :parent_mock_binding_type_container ) do
    mock_binding_type_container = ::Class.new.name( :ParentMockBindingTypeContainer )
    mock_binding_type_container.class_eval do
      def self.class_binding_base
        return @class_binding_base ||= ::Module.new.name( :ClassBindingBase )
      end
      def self.nested_class_binding_base
        return @nested_class_binding_base ||= ::Module.new.name( :NestedClassBindingBase )
      end
      def self.instance_binding_base
        return @instance_binding_base ||= ::Module.new.name( :InstanceBindingBase )
      end
      def self.nested_instance_binding_base
        return @nested_instance_binding_base ||= ::Module.new.name( :NestedInstanceBindingBase )
      end
    end
    mock_binding_type_container
  end
  let( :child_mock_binding_type_container ) do
    ::Class.new( parent_mock_binding_type_container ).name( :ChildMockBindingTypeContainer )
  end
  let( :type_name ) { :test_type_name }
  let( :parent_binding_type ) do
    ::Perspective::Bindings::BindingTypeContainer::BindingType.new( parent_mock_binding_type_container, type_name )
  end
  let( :child_binding_type ) do
    ::Perspective::Bindings::BindingTypeContainer::BindingType.new( child_mock_binding_type_container, 
                                                                    type_name, 
                                                                    parent_binding_type )
  end


  let( :binding_type_container_instance ) { mock_binding_type_container.class.new }

  ###############
  #  type_name  #
  ###############
  
  context '#type_name' do
    it 'parent instance has a type name that distinguishes it from other types' do
      parent_binding_type.type_name.should == type_name
    end
    it 'child has the same name' do
      child_binding_type.type_name.should == parent_binding_type.type_name
    end
  end

  ############################
  #  binding_type_container  #
  ############################

  context '#binding_type_container' do
    it 'parent instance belongs to the container that created it' do
      parent_binding_type.binding_type_container.should == parent_mock_binding_type_container
    end
    it 'child instance belongs to a container that subclassed parent instance container' do
      child_binding_type.binding_type_container.should == child_mock_binding_type_container
    end
  end
  
  #################
  #  parent_type  #
  #################

  context '#parent_type' do
    it 'has no parent for first instance' do
      parent_binding_type.parent_type.should == nil
    end
    it 'child instances track their parent' do
      child_binding_type.parent_type.should == parent_binding_type
    end
  end

  ##########################
  #  class_binding_module  #
  ##########################

  context '#class_binding_module' do
    it 'parent has a class binding module that will be used to cascade features to inheriting binding type instances' do
      parent_binding_type.class_binding_module.should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeModule
    end
    it 'has a class binding class used to create class binding instances' do
      parent_binding_type.class_binding_module.binding_type_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeClass ).should be true
    end
    it 'includes its class binding module' do
      parent_binding_type.class_binding_module.binding_type_class.ancestors.include?( parent_binding_type.class_binding_module ).should be true
    end
    it 'child also has a class binding module' do
      child_binding_type.class_binding_module.should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeModule
    end
    it 'child module is not the same as parent module' do
      child_binding_type.class_binding_module.should_not be parent_binding_type.class_binding_module
    end
    it 'child class binding module includes parent class binding module' do
      child_binding_type.class_binding_module.ancestors.include?( parent_binding_type.class_binding_module ).should be true
    end
  end

  #################################
  #  nested_class_binding_module  #
  #################################

  context '#nested_module_binding_module' do
    it 'parent has a nested class binding module that will be used to cascade features to inheriting binding type instances' do
      parent_binding_type.nested_class_binding_module.should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeModule
    end
    it 'has a nested class binding class used to create nested class binding instances' do
      parent_binding_type.nested_class_binding_module.binding_type_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeClass ).should be true
    end
    it 'includes its nested class binding module' do
      parent_binding_type.nested_class_binding_module.binding_type_class.ancestors.include?( parent_binding_type.nested_class_binding_module ).should be true
    end
    it 'child also has a class binding module' do
      child_binding_type.nested_class_binding_module.should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeModule
    end
    it 'child module is not the same as parent module' do
      child_binding_type.nested_class_binding_module.should_not be parent_binding_type.class_binding_module
    end
    it 'child class binding module includes parent class binding module' do
      child_binding_type.nested_class_binding_module.ancestors.include?( parent_binding_type.nested_class_binding_module ).should be true
    end
  end

  #############################
  #  instance_binding_module  #
  #############################

  context '#instance_binding_module' do
    it 'parent has an instance binding module that will be used to cascade features to inheriting binding type instances' do
      parent_binding_type.instance_binding_module.should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeModule
    end
    it 'has an instance binding class used to create instance binding instances' do
      parent_binding_type.instance_binding_module.binding_type_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeClass ).should be true
    end
    it 'includes its instance binding module' do
      parent_binding_type.instance_binding_module.binding_type_class.ancestors.include?( parent_binding_type.instance_binding_module ).should be true
    end
    it 'child also has a class binding module' do
      child_binding_type.instance_binding_module.should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeModule
    end
    it 'child module is not the same as parent module' do
      child_binding_type.instance_binding_module.should_not be parent_binding_type.class_binding_module
    end
    it 'child class binding module includes parent class binding module' do
      child_binding_type.instance_binding_module.ancestors.include?( parent_binding_type.instance_binding_module ).should be true
    end
  end

  ####################################
  #  nested_instance_binding_module  #
  ####################################

  context '#nested_instance_binding_module' do
    it 'parent has a nested instance binding module that will be used to cascade features to inheriting binding type instances' do
      parent_binding_type.nested_instance_binding_module.should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeModule
    end
    it 'has a nested instance binding class used to create nested instance binding instances' do
      parent_binding_type.nested_instance_binding_module.binding_type_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeClass ).should be true
    end
    it 'includes its nested instance binding module' do
      parent_binding_type.nested_instance_binding_module.binding_type_class.ancestors.include?( parent_binding_type.nested_instance_binding_module ).should be true
    end
    it 'child also has a class binding module' do
      child_binding_type.nested_instance_binding_module.should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingTypeModule
    end
    it 'child module is not the same as parent module' do
      child_binding_type.nested_instance_binding_module.should_not be parent_binding_type.class_binding_module
    end
    it 'child class binding module includes parent class binding module' do
      child_binding_type.nested_instance_binding_module.ancestors.include?( parent_binding_type.nested_instance_binding_module ).should be true
    end
  end
  
  ########################
  #  new_class_bindings  #
  ########################

  context '#new_class_bindings' do
    it 'creates new class bindings for a container, a list of names, and an optional block' do
    end
  end
  
end
