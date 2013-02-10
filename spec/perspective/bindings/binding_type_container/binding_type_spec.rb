
require_relative '../../../../lib/perspective/bindings.rb'

require_relative '../../../support/named_class_and_module.rb'

describe ::Perspective::Bindings::BindingTypeContainer::BindingType do
  
  let( :parent_mock_binding_type_container ) do
    mock_binding_type_container = ::Class.new.name( :ParentMockBindingTypeContainer )
    mock_binding_type_container.class_eval do
      def self.class_binding_base
        return @class_binding_base ||= ::Perspective::Bindings::BindingTypeContainer::BindingBase::ClassBinding.new( self ).name( :ClassBinding )
      end
      def self.instance_binding_base
        return @instance_binding_base ||= ::Perspective::Bindings::BindingTypeContainer::BindingBase::InstanceBinding.new( self ).name( :InstanceBinding )
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

  ####################
  #  type_container  #
  ####################

  context '#type_container' do
    it 'parent instance belongs to the container that created it' do
      parent_binding_type.types_controller.should == parent_mock_binding_type_container
    end
    it 'child instance belongs to a container that subclassed parent instance container' do
      child_binding_type.types_controller.should == child_mock_binding_type_container
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

  #########################
  #  class_binding_class  #
  #########################

  context '#class_binding_module' do
    it 'class and instance binding classes share a common base class' do
      parent_binding_type.class_binding_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingClass ).should be true
    end
    it 'parent has a class binding class that will be used to create class binding instances' do
      parent_binding_type.class_binding_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::ClassBindingClass ).should be true
    end
    it 'each type container has a class binding base that each class binding class includes' do
      parent_binding_type.class_binding_class.ancestors.include?( parent_mock_binding_type_container.class_binding_base ).should be true
    end
    it 'each class binding class includes the common class binding base' do
      parent_binding_type.class_binding_class.ancestors.include?( ::Perspective::Bindings::BindingBase::ClassBinding ).should be true
    end
    it 'child also has a class binding class' do
      child_binding_type.class_binding_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::ClassBindingClass ).should be true
    end
    it 'child module is not the same as parent module' do
      child_binding_type.class_binding_class.should_not be parent_binding_type.class_binding_class
    end
    it 'child class binding module includes parent class binding module' do
      child_binding_type.class_binding_class.ancestors.include?( parent_binding_type.class_binding_class ).should be true
    end
  end

  ############################
  #  instance_binding_class  #
  ############################

  context '#instance_binding_module' do
    it 'parent has an instance binding class that will be used to create instance binding instances' do
      parent_binding_type.instance_binding_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::InstanceBindingClass ).should be true
    end
    it 'class and instance binding classes share a common base class' do
      parent_binding_type.instance_binding_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::BindingClass ).should be true
    end
    it 'each type container has an instance binding base that each instance binding class includes' do
      parent_binding_type.instance_binding_class.ancestors.include?( parent_mock_binding_type_container.instance_binding_base ).should be true
    end
    it 'each instance binding class includes the common instance binding base' do
      parent_binding_type.instance_binding_class.ancestors.include?( ::Perspective::Bindings::BindingBase::InstanceBinding ).should be true
    end
    it 'child also has an instance binding class' do
      child_binding_type.instance_binding_class.ancestors.include?( ::Perspective::Bindings::BindingTypeContainer::BindingType::InstanceBindingClass ).should be true
    end
    it 'child class is not the same as parent class' do
      child_binding_type.instance_binding_class.should_not be parent_binding_type.instance_binding_class
    end
    it 'child instance binding class includes parent instance binding class' do
      child_binding_type.instance_binding_class.ancestors.include?( parent_binding_type.instance_binding_class ).should be true
    end
  end

  #############
  #  include  #
  #############
  
  context '#include' do
    let( :included_module ) { ::Module.new }
    before :each do
      _included_module = included_module
      parent_binding_type.module_eval { include _included_module }
    end
    it 'will ensure it is re-included in class and instance binding classes and child binding types' do
      parent_binding_type.class_binding_class.ancestors.include?( included_module ).should be true
      parent_binding_type.instance_binding_class.ancestors.include?( included_module ).should be true
      child_binding_type.ancestors.include?( included_module ).should be true
      child_binding_type.class_binding_class.ancestors.include?( included_module ).should be true
      child_binding_type.instance_binding_class.ancestors.include?( included_module ).should be true
    end
  end

  ############
  #  extend  #
  ############

  context '#extend' do
    let( :extended_module ) { ::Module.new }
    before :each do
      child_binding_type
      parent_binding_type.extend( extended_module )
    end
    it 'will ensure it is re-extended in class and instance binding classes and child binding types' do
      parent_binding_type.class_binding_class.is_a?( extended_module ).should be true
      parent_binding_type.instance_binding_class.is_a?( extended_module ).should be true
      child_binding_type.is_a?( extended_module ).should be true
      child_binding_type.class_binding_class.is_a?( extended_module ).should be true
      child_binding_type.instance_binding_class.is_a?( extended_module ).should be true
    end
  end

end
