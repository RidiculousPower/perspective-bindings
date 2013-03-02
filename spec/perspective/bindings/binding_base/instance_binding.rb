# -*- encoding : utf-8 -*-

require_relative 'instance_binding_setup.rb'

require_relative 'shared.rb'

shared_examples_for :base_instance_binding do

  it_behaves_like :shared_binding do
    let( :topclass_binding ) { topclass_instance_binding }
    let( :subclass_binding ) { subclass_instance_binding }
    let( :topclass_bound_container ) { topclass_bound_container_instance }
    let( :subclass_bound_container ) { subclass_bound_container_instance }
  end

  ######################
  #  «parent_binding»  #
  ######################
  
  context '#«parent_binding»' do
    it 'topclass binding has topclass class binding as parent' do
      topclass_instance_binding.«parent_binding».should == topclass_class_binding
    end
    it 'subclass binding has subclass class binding as parent' do
      subclass_instance_binding.«parent_binding».should == subclass_class_binding
    end
  end
  
  #######################
  #  permits_multiple?  #
  #  permits_multiple=  #
  #######################

  context '#permits_multiple?, #permits_multiple=' do
    it 'topclass binding can permit multiple' do
      topclass_instance_binding.permits_multiple?.should be false
      topclass_instance_binding.permits_multiple = true
      topclass_instance_binding.permits_multiple?.should be true
    end
    it 'subclass binding can permit multiple independent of topclass binding' do
      subclass_instance_binding.permits_multiple?.should be false
      subclass_instance_binding.permits_multiple = true
      subclass_instance_binding.permits_multiple?.should be true
    end
  end

  ###############
  #  required?  #
  #  required=  #
  ###############

  context '#required?, #required=' do
    it 'topclass binding can require binding' do
      topclass_instance_binding.required?.should be false
      topclass_instance_binding.required = true
      topclass_instance_binding.required?.should be true
    end
    it 'subclass binding can require binding independent of topclass binding' do
      subclass_instance_binding.required?.should be false
      subclass_instance_binding.required = true
      subclass_instance_binding.required?.should be true
    end
  end

  ###############
  #  optional?  #
  #  optional=  #
  ###############

  context '#optional?, #optional=' do
    it 'topclass binding can require binding and query via optional? (inverted)' do
      topclass_instance_binding.optional?.should be true
      topclass_instance_binding.optional = false
      topclass_instance_binding.optional?.should be false
    end
    it 'subclass binding can require binding independent of topclass binding and query via optional? (inverted)' do
      subclass_instance_binding.optional?.should be true
      subclass_instance_binding.optional = false
      subclass_instance_binding.optional?.should be false
    end
  end
  
  ##########################
  #  binding_value_valid?  #
  ##########################
  
  context '#binding_value_valid?' do
    let( :value ) { Complex( 42, 37 ) }
    let( :bad_value ) { 42 }
    context 'without permitted value module(s)' do
      it 'topclass binding can report value valid' do
        topclass_instance_binding.binding_value_valid?( value ).should be false
        topclass_instance_binding.binding_value_valid?( bad_value ).should be false
      end
      it 'subclass binding can report value valid' do
        subclass_instance_binding.binding_value_valid?( value ).should be false
        subclass_instance_binding.binding_value_valid?( bad_value ).should be false
      end
    end
    context 'with permitted value module' do
      let( :permitted_value_module ) { ::Perspective::Bindings::BindingDefinitions::Complex }
      before :each do
        topclass_instance_binding.extend( permitted_value_module )
        subclass_instance_binding.extend( permitted_value_module )
      end
      it 'topclass binding can report value valid' do
        topclass_instance_binding.binding_value_valid?( value ).should be true
        topclass_instance_binding.binding_value_valid?( bad_value ).should be false
      end
      it 'subclass binding can report value valid' do
        subclass_instance_binding.binding_value_valid?( value ).should be true
        subclass_instance_binding.binding_value_valid?( bad_value ).should be false
      end
      context 'when does not permit multiple and value is array' do
        let( :value ) { [ :any_array ] }
        it 'topclass binding can report value valid' do
          topclass_instance_binding.binding_value_valid?( value ).should be false
          topclass_instance_binding.binding_value_valid?( bad_value ).should be false
        end
        it 'subclass binding can report value valid' do
          subclass_instance_binding.binding_value_valid?( value ).should be false
          subclass_instance_binding.binding_value_valid?( bad_value ).should be false
        end
      end
      context 'when permits multiple and value is array' do
        before :each do
          topclass_instance_binding.permits_multiple = true
          subclass_instance_binding.permits_multiple = true
        end
        it 'topclass binding can report value valid' do
          topclass_instance_binding.binding_value_valid?( value ).should be true
          topclass_instance_binding.binding_value_valid?( bad_value ).should be false
        end
        it 'subclass binding can report value valid' do
          subclass_instance_binding.binding_value_valid?( value ).should be true
          subclass_instance_binding.binding_value_valid?( bad_value ).should be false
        end
      end
    end
  end

  ##############
  #  «value»   #
  #  «value»=  #
  ##############

  context '#«value», #«value»=' do
    let( :value ) { Complex( 42, 37 ) }
    context 'if binding_value_valid? is false' do
      it 'topclass binding will raise error for invalid value' do
        ::Proc.new { topclass_instance_binding.«value» = value }.should raise_error( ::ArgumentError )
      end
      it 'subclass binding will raise error for invalid value' do
        ::Proc.new { subclass_instance_binding.«value» = value }.should raise_error( ::ArgumentError )
      end
    end
    context 'if binding_value_valid? is true' do
      let( :permitted_value_module ) { ::Perspective::Bindings::BindingDefinitions::Complex }
      before :all do
        topclass_instance_binding.extend( permitted_value_module )
        subclass_instance_binding.extend( permitted_value_module )
      end
      it 'topclass binding will accept valid values' do
        topclass_instance_binding.«value».should be nil
        topclass_instance_binding.«value» = value
        topclass_instance_binding.«value».should be value
      end
      it 'subclass binding will accept valid values' do
        subclass_instance_binding.«value».should be nil
        subclass_instance_binding.«value» = value
        subclass_instance_binding.«value».should be value
      end
    end
  end

  ###########
  #  value  #
  ###########
  
  context '#value' do
    it 'is an alias for #«value»' do
      ::Perspective::Bindings::InstanceBinding.instance_method( :value ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :«value» )
    end
  end

  ############
  #  value=  #
  ############
  
  context 'value=' do
    it 'is an alias for #«value»=' do
      ::Perspective::Bindings::InstanceBinding.instance_method( :value= ).should == ::Perspective::Bindings::InstanceBinding.instance_method( :«value»= )
    end
  end

	########
	#  ==  #
	########

  context '#==' do
    let( :permitted_value_module ) { ::Perspective::Bindings::BindingDefinitions::Text }
    let( :value ) { 'some value' }
    before :all do
      topclass_instance_binding.extend( permitted_value_module ).«value» = value
      subclass_instance_binding.extend( permitted_value_module ).«value» = value
    end
    it 'topclass binding will accept valid values' do
      topclass_instance_binding.«value».should == value
    end
    it 'subclass binding will accept valid values' do
      subclass_instance_binding.«value».should == value
    end
  end

end
