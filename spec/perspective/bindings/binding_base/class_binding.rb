
require_relative 'class_binding_setup.rb'

require_relative 'shared.rb'

shared_examples_for :base_class_binding do

  it_behaves_like :shared_binding do
    let( :topclass_binding ) { topclass_class_binding }
    let( :subclass_binding ) { subclass_class_binding }
    let( :topclass_bound_container ) { topclass_bound_container_class }
    let( :subclass_bound_container ) { subclass_bound_container_class }
  end

  let( :topclass_class_binding_parent_binding ) { nil }
  let( :topclass_class_binding_configuration_procs ) { [ topclass_configuration_proc ] }
  let( :subclass_class_binding_configuration_procs ) { [ topclass_configuration_proc, subclass_configuration_proc ] }
  
  ########################
  #  __parent_binding__  #
  ########################
  
  context '#__parent_binding__' do
    it 'topclass binding has no parent binding' do
      topclass_class_binding.__parent_binding__.should == topclass_class_binding_parent_binding
    end
    it 'subclass binding has topclass binding as parent' do
      subclass_class_binding.__parent_binding__.should == topclass_class_binding
    end
  end
  
  ###############################
  #  __validate_binding_name__  #
  ###############################
  
  context '#__validate_binding_name__' do
    let( :binding_name ) { :new }
    let( :topclass__validate_binding_name__ ) { ::Proc.new { topclass_class_binding.__validate_binding_name__( binding_name ) } }
    let( :subclass__validate_binding_name__ ) { ::Proc.new { subclass_class_binding.__validate_binding_name__( binding_name ) } }
    it 'topclass prohibits :new' do
      topclass__validate_binding_name__.should raise_error( ::ArgumentError )
    end
    it 'subclass prohibits :new' do
      subclass__validate_binding_name__.should raise_error( ::ArgumentError )
    end
  end
  
  #############################
  #  __configuration_procs__  #
  #############################

  context '#__configuration_procs__' do
    it 'topclass binding has proc' do
      topclass_class_binding.__configuration_procs__.should == topclass_class_binding_configuration_procs
    end
    it 'subclass binding has topclass proc plus additional proc' do
      subclass_class_binding.__configuration_procs__.should == subclass_class_binding_configuration_procs
    end
  end

  ###################
  #  __configure__  #
  ###################

  context '#__configure__' do
    let( :another_block ) { ::Proc.new { puts 'another block' } }
    it 'topclass binding can configure via proc' do
      topclass_class_binding.__configuration_procs__.should == topclass_class_binding_configuration_procs
      topclass_class_binding.__configure__( & another_block )
      topclass_class_binding_configuration_procs.push( another_block )
      topclass_class_binding.__configuration_procs__.should == topclass_class_binding_configuration_procs
    end
    it 'subclass can configure its own procs in addition' do
      subclass_class_binding.__configuration_procs__.should == subclass_class_binding_configuration_procs
      subclass_class_binding.__configure__( & another_block )
      subclass_class_binding_configuration_procs.push( another_block )
      topclass_class_binding.__configuration_procs__.should == topclass_class_binding_configuration_procs
      subclass_class_binding.__configuration_procs__.should == subclass_class_binding_configuration_procs
    end
  end

  ###############
  #  configure  #
  ###############
  
  context '#configure' do
    it 'is an alias for #__configure__' do
      ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :configure ).should == ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :__configure__ )
    end
  end

  ###########################
  #  permits_multiple?  #
  #  permits_multiple=  #
  ###########################

  context '#permits_multiple?, #permits_multiple=' do
    it 'topclass binding can permit multiple' do
      topclass_class_binding.permits_multiple?.should be false
      topclass_class_binding.permits_multiple = true
      topclass_class_binding.permits_multiple?.should be true
    end
    it 'subclass binding can permit multiple independent of topclass binding' do
      subclass_class_binding.permits_multiple?.should be false
      subclass_class_binding.permits_multiple = true
      subclass_class_binding.permits_multiple?.should be true
      subclass_class_binding.permits_multiple = false
      subclass_class_binding.permits_multiple?.should be false
      subclass_class_binding.permits_multiple = true
      subclass_class_binding.permits_multiple?.should be true
    end
  end

  ###################
  #  required?  #
  #  required=  #
  ###################

  context '#required?, #required=' do
    it 'topclass binding can require binding' do
      topclass_class_binding.required?.should be false
      topclass_class_binding.required = true
      topclass_class_binding.required?.should be true
    end
    it 'subclass binding can require binding independent of topclass binding' do
      subclass_class_binding.required?.should be false
      topclass_class_binding.required = true
      subclass_class_binding.required?.should be true
      subclass_class_binding.required = false
      subclass_class_binding.required?.should be false
      subclass_class_binding.required = true
      subclass_class_binding.required?.should be true
    end
  end

  ###################
  #  optional?  #
  #  optional=  #
  ###################

  context '#optional?, #optional=' do
    it 'topclass binding can require binding and query via optional? (inverted)' do
      topclass_class_binding.optional?.should be true
      topclass_class_binding.optional = false
      topclass_class_binding.optional?.should be false
    end
    it 'subclass binding can require binding independent of topclass binding and query via optional? (inverted)' do
      subclass_class_binding.optional?.should be true
      topclass_class_binding.optional = false
      subclass_class_binding.optional?.should be false
      subclass_class_binding.optional = true
      subclass_class_binding.optional?.should be true
      subclass_class_binding.optional = false
      subclass_class_binding.optional?.should be false
    end
  end
    
end
