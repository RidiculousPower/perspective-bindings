
require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingTypeContainer::TypesController do

  let( :parent_type_container_name ) { :parent_type_container }
  let( :child_type_container_name ) { :child_type_container }
  let( :child_without_subclassing_type_container_name ) { :child_type_container }

  let( :parent_type_container ) { ::Perspective::Bindings::BindingTypeContainer.new( parent_type_container_name ) }
  let( :child_type_container ) { ::Perspective::Bindings::BindingTypeContainer.new( child_type_container_name, parent_type_container ) }
  let( :child_without_subclassing_type_container ) { ::Perspective::Bindings::BindingTypeContainer.new( child_without_subclassing_type_container_name, parent_type_container, false ) }

  let( :parent_types ) { ::Perspective::Bindings::BindingTypeContainer::TypesController.new }
  let( :child_types ) { ::Perspective::Bindings::BindingTypeContainer::TypesController.new( parent_types ) }
  let( :child_without_subclassing_types ) { ::Perspective::Bindings::BindingTypeContainer::TypesController.new( parent_types, false ) }

  #############################
  #  parent_types_controller  #
  #############################
  
  context '#parent_types_controller' do
    context 'when parent' do
      it 'will return nil' do
        parent_types.parent_types_controller.should be nil
      end
    end
    context 'when child' do
      it 'will return parent' do
        child_types.parent_types_controller.should be parent_types
      end
      it 'should include types from parent_type_container' do
        child_types.ancestors.include?( parent_types ).should be true
      end
    end
    context 'when child without subclassing' do
      it 'will return parent' do
        child_without_subclassing_types.parent_types_controller.should be parent_types
      end
      it 'should include types from parent_type_container' do
        child_without_subclassing_types.ancestors.include?( parent_types ).should be true
      end
    end
  end
  
  ################################
  #  subclass_existing_bindings  #
  ################################
  
  context '#subclass_existing_bindings' do
    context 'when parent' do
      it 'will return whether it should subclass bindings from its parent when they are inherited' do
        parent_types.subclass_existing_bindings.should be true
      end
    end
    context 'when child' do
      it 'will return whether it should subclass bindings from its parent when they are inherited' do
        child_types.subclass_existing_bindings.should be true
      end
    end
    context 'when child without subclassing' do
      it 'will return whether it should subclass bindings from its parent when they are inherited' do
        child_without_subclassing_types.subclass_existing_bindings.should be false
      end
    end
  end

  ########################
  #  class_binding_base  #
  ########################

  context '#class_binding_base' do
    it 'has a class binding base module used for all class binding types' do
      parent_types.class_binding_base.ancestors.include?( ::Perspective::Bindings::BindingBase::ClassBinding ).should be true
    end
    it 'inherits its parent class binding base module' do
      child_types.class_binding_base.ancestors.include?( parent_types.class_binding_base ).should be true
    end
    context 'include and extend' do
      let( :include_extend_module ) { ::Module.new }
      let( :some_type ) { parent_types.define_binding_type( :some_type ) }
      before :each do
        some_type
      end
      it 'will ensure that includes are forwarded by re-including self in children' do
        _include_extend_module = include_extend_module
        parent_types.class_binding_base.module_eval { include _include_extend_module }
        some_type.class_binding_class.ancestors.include?( include_extend_module ).should be true
      end
      it 'will ensure that extends are forwarded to children' do
        parent_types.class_binding_base.extend( include_extend_module )
        some_type.class_binding_class.is_a?( include_extend_module ).should be true
      end
    end
  end

  ###########################
  #  instance_binding_base  #
  ###########################

  context '#instance_binding_base' do
    it 'has an instance binding base module used for all class binding types' do
      parent_types.instance_binding_base.ancestors.include?( ::Perspective::Bindings::BindingBase::InstanceBinding ).should be true
    end
    it 'inherits its parent instance binding base module' do
      child_types.instance_binding_base.ancestors.include?( parent_types.instance_binding_base ).should be true
    end
    context 'include and extend' do
      let( :include_extend_module ) { ::Module.new }
      let( :some_type ) { parent_types.define_binding_type( :some_type ) }
      before :each do
        parent_types.define_binding_type( :some_type )
      end
      it 'will ensure that includes are forwarded by re-including self in children' do
        _include_extend_module = include_extend_module
        parent_types.instance_binding_base.module_eval { include _include_extend_module }
        some_type.instance_binding_class.ancestors.include?( include_extend_module ).should be true
      end
      it 'will ensure that extends are forwarded to children' do
        parent_types.instance_binding_base.extend( include_extend_module )
        some_type.instance_binding_class.is_a?( include_extend_module ).should be true
      end
    end
  end
  
  #########################
  #  define_binding_type  #
  #########################
  
  context '#define_binding_type' do
    let( :parent_binding_type_name ) { :parent_binding_type }
    let( :child_binding_type_name ) { :child_binding_type }
    let( :child_without_subclassing_binding_type_name ) { :child_without_subclassing_binding_type }
    context 'when parent' do
      before :all do
        parent_types.define_binding_type( parent_binding_type_name )
      end
      it 'will have binding type module' do
        parent_types.binding_types[ parent_binding_type_name ].should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType
      end
      it 'child will also have its own subclass of the type' do
        child_types.binding_types[ parent_binding_type_name ].ancestors.include?( parent_types.binding_types[ parent_binding_type_name ] ).should be true
      end
      it 'child without subclassing will have the same type' do
        child_without_subclassing_types.binding_types[ parent_binding_type_name ].should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType
        child_without_subclassing_types.binding_types[ parent_binding_type_name ].should be parent_types.binding_types[ parent_binding_type_name ]
      end
    end
    context 'when child' do
      before :all do
        child_types.define_binding_type( child_binding_type_name )
      end
      it 'will have binding type module' do
        child_types.binding_types[ child_binding_type_name ].should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType
      end
    end
    context 'when child without subclassing' do
      before :all do
        child_without_subclassing_types.define_binding_type( child_without_subclassing_binding_type_name )
      end
      it 'will have binding type module' do
        child_without_subclassing_types.binding_types[ child_without_subclassing_binding_type_name ].should be_a ::Perspective::Bindings::BindingTypeContainer::BindingType
      end
    end
  end
  
  ########################
  #  alias_binding_type  #
  ########################

  context '#alias_binding_type' do
    let( :binding_type_name ) { :parent_binding_type }
    let( :alias_binding_type_name ) { :alias_binding_type }
    before :all do
      parent_types.define_binding_type( binding_type_name )
      parent_types.alias_binding_type( alias_binding_type_name, binding_type_name )
    end
    it 'will have binding type module' do
      parent_types.binding_aliases[ alias_binding_type_name ].should be binding_type_name
    end
    it 'child will also have its own subclass of the type' do
      child_types.binding_aliases[ alias_binding_type_name ].should be binding_type_name
    end
    it 'child without subclassing will have the same type' do
      child_without_subclassing_types.binding_aliases[ alias_binding_type_name ].should be binding_type_name
    end
  end

end
