# -*- encoding : utf-8 -*-

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
  
  ######################
  #  «parent_binding»  #
  ######################
  
  context '#«parent_binding»' do
    it 'topclass binding has no parent binding' do
      topclass_class_binding.«parent_binding».should == topclass_class_binding_parent_binding
    end
    it 'subclass binding has topclass binding as parent' do
      subclass_class_binding.«parent_binding».should == topclass_class_binding
    end
  end
  
  #############################
  #  «validate_binding_name»  #
  #############################
  
  context '#«validate_binding_name»' do
    let( :binding_name ) { :new }
    let( :topclass«validate_binding_name» ) { ::Proc.new { topclass_class_binding.«validate_binding_name»( binding_name ) } }
    let( :subclass«validate_binding_name» ) { ::Proc.new { subclass_class_binding.«validate_binding_name»( binding_name ) } }
    it 'topclass prohibits :new' do
      topclass«validate_binding_name».should raise_error( ::ArgumentError )
    end
    it 'subclass prohibits :new' do
      subclass«validate_binding_name».should raise_error( ::ArgumentError )
    end
  end
  
  ###########################
  #  «configuration_procs»  #
  ###########################

  context '#«configuration_procs»' do
    it 'topclass binding has proc' do
      topclass_class_binding.«configuration_procs».should == topclass_class_binding_configuration_procs
    end
    it 'subclass binding has topclass proc plus additional proc' do
      subclass_class_binding.«configuration_procs».should == subclass_class_binding_configuration_procs
    end
  end

  #################
  #  «configure»  #
  #################

  context '#«configure»' do
    let( :another_block ) { ::Proc.new { puts 'another block' } }
    it 'topclass binding can configure via proc' do
      topclass_class_binding.«configuration_procs».should == topclass_class_binding_configuration_procs
      topclass_class_binding.«configure»( & another_block )
      topclass_class_binding_configuration_procs.push( another_block )
      topclass_class_binding.«configuration_procs».should == topclass_class_binding_configuration_procs
    end
    it 'subclass can configure its own procs in addition' do
      subclass_class_binding.«configuration_procs».should == subclass_class_binding_configuration_procs
      subclass_class_binding.«configure»( & another_block )
      subclass_class_binding_configuration_procs.push( another_block )
      topclass_class_binding.«configuration_procs».should == topclass_class_binding_configuration_procs
      subclass_class_binding.«configuration_procs».should == subclass_class_binding_configuration_procs
    end
  end

  ###############
  #  configure  #
  ###############
  
  context '#configure' do
    it 'is an alias for #«configure»' do
      ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :configure ).should == ::Perspective::Bindings::BindingBase::ClassBinding.instance_method( :«configure» )
    end
  end

  #######################
  #  permits_multiple?  #
  #  permits_multiple=  #
  #######################

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

  ###############
  #  required?  #
  #  required=  #
  ###############

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

  ###############
  #  optional?  #
  #  optional=  #
  ###############

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
