# -*- encoding : utf-8 -*-

require_relative '../../../lib/perspective/bindings.rb'

describe ::Perspective::BindingTypes do

  let( :block ) do
    ::Proc.new do
      define_binding_type( :type_A )
      define_binding_type( :type_B )
      define_binding_type( :type_C )
    end
  end

  shared_examples_for :container_creation do
    it 'will create containers with optional inheritance' do
      parent.should be_a ::Perspective::Bindings::BindingTypeContainer
      child.should be_a ::Perspective::Bindings::BindingTypeContainer
      child_without_subclassing.should be_a ::Perspective::Bindings::BindingTypeContainer
    end
    it 'a child will inherit bindings' do
      parent.binding_types.each do |this_binding_type_name, this_binding_type|
        child.binding_types.has_key?( this_binding_type_name ).should be true
      end
    end
    it 'a child that subclasses bindings will have its own instances subclassing the parent instances' do
      parent.binding_types.each do |this_binding_type_name, this_binding_type|
        child.binding_types[ this_binding_type_name ].ancestors.include?( this_binding_type ).should be true
        child.binding_types[ this_binding_type_name ].should_not be parent.binding_types[ this_binding_type_name ]
      end
    end
    it 'a child that does not subclass will inherit the same instances from its parent' do
      parent.binding_types.each do |this_binding_type_name, this_binding_type|
        child_without_subclassing.binding_types[ this_binding_type_name ].should be this_binding_type
      end
    end
  end

  ################################
  #  self.create_container_type  #
  ################################

  context '::create_container_type' do
    let( :container_type_name ) { :create_parent }
    let( :child_container_type_name ) { :create_child }
    let( :child_without_subclassing_name ) { :create_child_without_subclassing }
    let( :parent ) { ::Perspective::BindingTypes.create_container_type( container_type_name, & block ) }
    let( :child ) { ::Perspective::BindingTypes.create_container_type( child_container_type_name, parent ) }
    let( :child_without_subclassing ) { ::Perspective::BindingTypes.create_container_type( child_without_subclassing_name, parent, false ) }
    it_behaves_like :container_creation
  end
  
  ################################
  #  self.define_container_type  #
  ################################
  
  context '::define_container_type' do
    let( :container_type_name ) { :define_parent }
    let( :child_container_type_name ) { :define_child }
    let( :child_without_subclassing_name ) { :define_child_without_subclassing }
    let( :parent ) { ::Perspective::BindingTypes.define_container_type( container_type_name, & block ) }
    let( :child ) { ::Perspective::BindingTypes.define_container_type( child_container_type_name, parent ) }
    let( :child_without_subclassing ) { ::Perspective::BindingTypes.define_container_type( child_without_subclassing_name, parent, false ) }
    it_behaves_like :container_creation
  end
  
  #########################
  #  self.type_container  #
  #########################

  context '::type_container' do
    let( :container_type_name ) { :type_parent }
    let( :child_container_type_name ) { :type_child }
    let( :child_without_subclassing_name ) { :type_child_without_subclassing }
    context 'when no container exists for type and require exist is true' do
      it 'will raise exception' do
        ::Proc.new { ::Perspective::BindingTypes.type_container( child_container_type_name ) }.should raise_error( ::ArgumentError )
      end
    end
    context 'when no container exists for type and require exist is true' do
      it 'will return nil' do
        ::Perspective::BindingTypes.type_container( child_container_type_name, false ).should == nil
      end
    end
    context 'when container exists' do
      let( :container ) { ::Perspective::BindingTypes.define_container_type( container_type_name ) }
      before :all do
        container
      end
      it 'will return container for name' do
        ::Perspective::BindingTypes.type_container( container_type_name ).should == container
      end
    end
  end

end
