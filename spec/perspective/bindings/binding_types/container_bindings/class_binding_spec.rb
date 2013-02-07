
require_relative '../../../../../lib/perspective/bindings.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../binding_base/class_binding.rb'

describe ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBindingBase do

  before :all do
    # test with a generic binding we create
    ::Perspective::Bindings::BindingTypes::ContainerBindings.define_binding_type( :class_binding_test_binding )
  end

  let( :class_binding_class ) do
    ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBindingTestBinding::ClassBinding
  end
  
  
  let( :base_container ) do
    _mock_container_module = mock_container_module
    ::Class.new { include( _mock_container_module ) }.extend( mock_container_module )
  end
  let( :first_nested_container ) do
    _mock_container_module = mock_container_module
    ::Class.new { include( _mock_container_module ) }.extend( mock_container_module )
  end
  let( :nth_nested_container ) do
    _mock_container_module = mock_container_module
    ::Class.new { include( _mock_container_module ) }.extend( mock_container_module )
  end
  let( :sub_base_container ) { ::Class.new( base_container ) }
  let( :sub_first_nested_container ) { ::Class.new( first_nested_container ) }
  let( :sub_nth_nested_container ) { ::Class.new( nth_nested_container ) }
  
  let( :class_binding_to_base ) { class_binding_class.new( base_container, binding_to_base_name, & base_proc ) }
  let( :class_binding_to_first_nested ) { class_binding_class.new( class_binding_to_base, binding_to_first_nested_name, & first_nested_proc ) }
  let( :class_binding_to_nth_nested ) { class_binding_class.new( class_binding_to_first_nested, binding_to_nth_nested_name, & nth_nested_proc ) }
  
  let( :subclass_class_binding_to_base ) { class_binding_class.new( sub_base_container, nil, class_binding_to_base ) }
  let( :subclass_class_binding_to_first_nested ) { class_binding_class.new( subclass_class_binding_to_base, nil, class_binding_to_first_nested ) }
  let( :subclass_class_binding_to_nth_nested ) { class_binding_class.new( subclass_class_binding_to_first_nested, nil, class_binding_to_nth_nested ) }

  it_behaves_like :class_binding

  it 'bound to base container' do
    class_binding_to_base.__parent_binding__.should == nil
  end
  it 'bound to first nested container' do
    class_binding_to_first_nested.__parent_binding__.should == nil
  end
  it 'bound to nth nested container' do
    class_binding_to_nth_nested.__parent_binding__.should == nil
  end
  it 'bound to subclass of base container' do
    subclass_class_binding_to_base.__parent_binding__.should == class_binding_to_base
  end
  it 'bound to subclass of first nested container' do
    subclass_class_binding_to_first_nested.__parent_binding__.should == class_binding_to_first_nested
  end
  it 'bound to subclass of nth nested container' do
    subclass_class_binding_to_nth_nested.__parent_binding__.should == class_binding_to_nth_nested
  end

  #########################
  #  __container_class__  #
  #########################

  context '#__container_class__' do
    
  end

  #####################
  #  container_class  #
  #####################

  context '#container_class' do
    it 'is an alias for #__container_class__' do
      class_binding_class.instance_method( :container_class ).should == class_binding_class.instance_method( :__container_class__ )
    end
  end

  ########################################
  #  __initialize_for_container_class__  #
  ########################################

  context '#__initialize_for_container_class__' do
    
  end

  ##################################
  #  __validate_container_class__  #
  ##################################

  context '#__validate_container_class__' do
    
  end

  ######################
  #  __nested_route__  #
  ######################

  context '#__nested_route__' do
    it 'bound to base container' do
      class_binding_to_base.__nested_route__( class_binding_to_base ).should == nil
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__nested_route__( class_binding_to_base ).should == nil
      class_binding_to_first_nested.__nested_route__( class_binding_to_first_nested ).should == nil
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__nested_route__( class_binding_to_base ).should == [ binding_to_first_nested_name ]
      class_binding_to_nth_nested.__nested_route__( class_binding_to_first_nested ).should == nil
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__nested_route__( subclass_class_binding_to_base ).should == nil
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__nested_route__( subclass_class_binding_to_base ).should == nil
      subclass_class_binding_to_first_nested.__nested_route__( subclass_class_binding_to_first_nested ).should == nil
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__nested_route__( class_binding_to_base ).should == [ binding_to_first_nested_name ]
      subclass_class_binding_to_nth_nested.__nested_route__( class_binding_to_first_nested ).should == nil
    end
  end
  
end
