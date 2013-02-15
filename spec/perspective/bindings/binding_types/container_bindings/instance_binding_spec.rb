
require_relative '../../../../../lib/perspective/bindings.rb'

require_relative '../../../../support/named_class_and_module.rb'

require_relative '../../binding_base/instance_binding.rb'

require_relative 'instance_binding_setup.rb'
#require_relative 'instance_binding.rb'

describe ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding do

  before :all do
    # test with a generic binding we create
    ::Perspective::Bindings::BindingTypes::ContainerBindings.define_binding_type( :instance_binding_test_binding, :text )
  end

  let( :class_binding_class ) do
    ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBindingTestBinding::ClassBinding
  end
  let( :instance_binding_class ) do
    ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBindingTestBinding::InstanceBinding
  end
  
  setup_container_class_binding_tests

  let( :topclass_bound_container_instance ) { topclass_bound_container_class.new }
  let( :topclass_nested_container_instance_A ) { nested_container_class_A.new }
  let( :topclass_nested_container_instance_B ) { nested_container_class_B.new }

  let( :subclass_bound_container_instance ) { subclass_bound_container_class.new }
  let( :subclass_nested_container_instance_A ) { nested_container_class_A.new }
  let( :subclass_nested_container_instance_B ) { nested_container_class_B.new }

  let( :topclass_instance_binding ) { topclass_instance_binding_A }
  let( :subclass_instance_binding ) { subclass_instance_binding_A }

  let( :topclass_instance_binding_A ) { instance_binding_class.new( topclass_class_binding_A, topclass_bound_container_instance ) }
  let( :topclass_instance_binding_A_B ) { instance_binding_class.new( topclass_class_binding_A_B, topclass_nested_container_instance_A ) }
  let( :topclass_instance_binding_A_B_C ) { instance_binding_class.new( topclass_class_binding_A_B_C, topclass_nested_container_instance_B ) }
  
  let( :subclass_instance_binding_A ) { instance_binding_class.new( subclass_class_binding_A, subclass_bound_container_instance ) }
  let( :subclass_instance_binding_A_B ) { instance_binding_class.new( subclass_class_binding_A_B, subclass_nested_container_instance_A ) }
  let( :subclass_instance_binding_A_B_C ) { instance_binding_class.new( subclass_class_binding_A_B_C, subclass_nested_container_instance_B ) }

  it_behaves_like :base_instance_binding
#  it_behaves_like :container_instance_binding
  
  #########################################
  #  __initialize_container_from_class__  #
  #########################################
  
  context '#__initialize_container_from_class__' do
    it 'will be extended with container instance binding methods' do
      topclass_class_binding_A.__container_class__::Controller::InstanceBindingMethods.should === topclass_instance_binding_A
    end
    it 'will create and store instance of container' do
      topclass_class_binding_A.__container_class__.should === topclass_instance_binding_A.__container__
    end
  end
  
  ###################
  #  __container__  #
  ###################

  context '#__container__' do
    it 'will return the initialized container instance' do
      topclass_instance_binding_A.__container__.should be_a topclass_class_binding_A.__container_class__
      topclass_instance_binding_A_B.__container__.should be_a topclass_class_binding_A_B.__container_class__
      topclass_instance_binding_A_B_C.__container__.should be_a topclass_class_binding_A_B_C.__container_class__
      subclass_instance_binding_A.__container__.should be_a subclass_class_binding_A.__container_class__
      subclass_instance_binding_A_B.__container__.should be_a subclass_class_binding_A_B.__container_class__
      subclass_instance_binding_A_B_C.__container__.should be_a subclass_class_binding_A_B_C.__container_class__
    end
  end
  
  ####################
  #  __container__=  #
  ####################

  context '#__container__=' do
    it 'will store container, initializing self with container as parent (reverse the norm)' do
      subclass_instance_binding_A_B_C.__container__ = topclass_nested_container_instance_A
      subclass_instance_binding_A_B_C.__container__.should be topclass_nested_container_instance_A
      CascadingConfiguration.configuration( subclass_instance_binding_A_B_C, :__bindings__ ).is_parent?( topclass_nested_container_instance_A ).should be true
    end
  end
  
  ###############
  #  container  #
  ###############

  context '#container' do
    it 'is an alias for #__container__' do
      instance_binding_class.instance_method( :container ).should == instance_binding_class.instance_method( :__container__ )
    end
  end
  
  ################
  #  container=  #
  ################

  context '#container=' do
    it 'is an alias for #__container__=' do
      instance_binding_class.instance_method( :container= ).should == instance_binding_class.instance_method( :__container__= )
    end
  end
  
  ######################################
  #  __ensure_multi_container_proxy__  #
  ######################################

  context '#__ensure_multi_container_proxy__' do
    context 'when no container' do
      before :each do
        topclass_instance_binding_A.__container__ = nil
        topclass_instance_binding_A.__ensure_multi_container_proxy__
      end
      it 'will do nothing' do
        topclass_instance_binding_A.__has_container__?.should be false
      end
    end
    context 'when container' do
      before :each do
        topclass_instance_binding_A.__ensure_multi_container_proxy__
      end
      it 'will create multi-container-proxy for container' do
        topclass_instance_binding_A.__container__.should be_a ::Perspective::Bindings::Container::MultiContainerProxy
      end
    end
    context 'when multi-container-proxy' do
      before :each do
        @multi_container_proxy = topclass_instance_binding_A.__ensure_multi_container_proxy__
        @multi_container_proxy.should_not be nil
      end
      it 'will return multi-container-proxy' do
        topclass_instance_binding_A.__ensure_multi_container_proxy__.should be @multi_container_proxy
      end
    end
  end
  
  ###########
  #  value  #
  ###########

  context '#value' do
    it 'is an alias for #__value__' do
      instance_binding_class.instance_method( :value ).should == instance_binding_class.instance_method( :__value__ )
    end
  end
  
  ############
  #  value=  #
  ############

  context '#value=' do
    it 'is an alias for #__value__=' do
      instance_binding_class.instance_method( :value= ).should == instance_binding_class.instance_method( :__value__= )
    end
  end
  
  ######################
  #  __nested_route__  #
  ######################
  
  context '#__nested_route__' do
    context 'binding is nested in queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_instance_binding_A_B.__nested_route__( topclass_instance_binding_A ).should == nil
      end
    end
    context 'binding is nested in binding under queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_instance_binding_A_B_C.__nested_route__( topclass_instance_binding_A ).should == [ topclass_class_binding_A_B_name ]
      end
    end
  end

end
