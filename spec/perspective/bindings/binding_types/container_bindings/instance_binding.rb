
require_relative '../../binding_base/instance_binding.rb'

shared_examples_for :container_instance_binding do

  it_behaves_like :base_instance_binding
  
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
      topclass_instance_binding_A.class.instance_method( :container ).should == topclass_instance_binding_A.class.instance_method( :__container__ )
    end
  end
  
  ################
  #  container=  #
  ################

  context '#container=' do
    it 'is an alias for #__container__=' do
      topclass_instance_binding_A.class.instance_method( :container= ).should == topclass_instance_binding_A.class.instance_method( :__container__= )
    end
  end
  
  ###########
  #  value  #
  ###########

  context '#value' do
    it 'is an alias for #__value__' do
      topclass_instance_binding_A.class.instance_method( :value ).should == topclass_instance_binding_A.class.instance_method( :__value__ )
    end
  end
  
  ############
  #  value=  #
  ############

  context '#value=' do
    it 'is an alias for #__value__=' do
      topclass_instance_binding_A.class.instance_method( :value= ).should == topclass_instance_binding_A.class.instance_method( :__value__= )
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
