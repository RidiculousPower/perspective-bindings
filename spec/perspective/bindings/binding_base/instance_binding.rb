
require_relative 'instance_binding_setup.rb'

require_relative 'shared.rb'

shared_examples_for :instance_binding do

  setup_instance_binding_tests
  
  it_behaves_like :shared_binding do
    let( :topclass_binding ) { topclass_instance_binding }
    let( :subclass_binding ) { subclass_instance_binding }
    let( :topclass_bound_container ) { topclass_bound_container_instance }
    let( :subclass_bound_container ) { subclass_bound_container_instance }
  end

  ########################
  #  __parent_binding__  #
  ########################
  
  context '#__parent_binding__' do
    it 'topclass binding has topclass class binding as parent' do
      topclass_instance_binding.__parent_binding__.should == topclass_class_binding
    end
    it 'subclass binding has subclass class binding as parent' do
      subclass_instance_binding.__parent_binding__.should == subclass_class_binding
    end
  end
  
  ###########################
  #  __permits_multiple__?  #
  #  __permits_multiple__=  #
  ###########################

  context '#__permits_multiple__?, #__permits_multiple__=' do
    it 'topclass binding can permit multiple' do
      topclass_instance_binding.__permits_multiple__?.should be false
      topclass_instance_binding.__permits_multiple__ = true
      topclass_instance_binding.__permits_multiple__?.should be true
    end
    it 'subclass binding can permit multiple independent of topclass binding' do
      subclass_instance_binding.__permits_multiple__?.should be false
      subclass_instance_binding.__permits_multiple__ = true
      subclass_instance_binding.__permits_multiple__?.should be true
    end
  end

  ###################
  #  __required__?  #
  #  __required__=  #
  ###################

  context '#__required__?, #__required__=' do
    it 'topclass binding can require binding' do
      topclass_instance_binding.__required__?.should be false
      topclass_instance_binding.__required__ = true
      topclass_instance_binding.__required__?.should be true
    end
    it 'subclass binding can require binding independent of topclass binding' do
      subclass_instance_binding.__required__?.should be false
      subclass_instance_binding.__required__ = true
      subclass_instance_binding.__required__?.should be true
    end
  end

  ###################
  #  __optional__?  #
  #  __optional__=  #
  ###################

  context '#__optional__?, #__optional__=' do
    it 'topclass binding can require binding and query via optional? (inverted)' do
      topclass_instance_binding.__optional__?.should be true
      topclass_instance_binding.__optional__ = false
      topclass_instance_binding.__optional__?.should be false
    end
    it 'subclass binding can require binding independent of topclass binding and query via optional? (inverted)' do
      subclass_instance_binding.__optional__?.should be true
      subclass_instance_binding.__optional__ = false
      subclass_instance_binding.__optional__?.should be false
    end
  end
  
  ##############################
  #  __binding_value_valid__?  #
  ##############################
  
  context '#__binding_value_valid__?' do
    let( :value ) { 'some value' }
    let( :bad_value ) { 42 }
    context 'without permitted value module(s)' do
      it 'topclass binding can report value valid' do
        topclass_instance_binding.__binding_value_valid__?( value ).should be false
        topclass_instance_binding.__binding_value_valid__?( bad_value ).should be false
      end
      it 'subclass binding can report value valid' do
        subclass_instance_binding.__binding_value_valid__?( value ).should be false
        subclass_instance_binding.__binding_value_valid__?( bad_value ).should be false
      end
    end
    context 'with permitted value module' do
      let( :permitted_value_module ) { ::Perspective::Bindings::BindingDefinitions::Text }
      before :each do
        topclass_instance_binding.__extend__( permitted_value_module )
        subclass_instance_binding.__extend__( permitted_value_module )
      end
      it 'topclass binding can report value valid' do
        topclass_instance_binding.__binding_value_valid__?( value ).should be true
        topclass_instance_binding.__binding_value_valid__?( bad_value ).should be false
      end
      it 'subclass binding can report value valid' do
        subclass_instance_binding.__binding_value_valid__?( value ).should be true
        subclass_instance_binding.__binding_value_valid__?( bad_value ).should be false
      end
      context 'when does not permit multiple and value is array' do
        let( :value ) { [ :any_array ] }
        it 'topclass binding can report value valid' do
          topclass_instance_binding.__binding_value_valid__?( value ).should be false
          topclass_instance_binding.__binding_value_valid__?( bad_value ).should be false
        end
        it 'subclass binding can report value valid' do
          subclass_instance_binding.__binding_value_valid__?( value ).should be false
          subclass_instance_binding.__binding_value_valid__?( bad_value ).should be false
        end
      end
      context 'when permits multiple and value is array' do
        before :each do
          topclass_instance_binding.__permits_multiple__ = true
          subclass_instance_binding.__permits_multiple__ = true
        end
        it 'topclass binding can report value valid' do
          topclass_instance_binding.__binding_value_valid__?( value ).should be true
          topclass_instance_binding.__binding_value_valid__?( bad_value ).should be false
        end
        it 'subclass binding can report value valid' do
          subclass_instance_binding.__binding_value_valid__?( value ).should be true
          subclass_instance_binding.__binding_value_valid__?( bad_value ).should be false
        end
      end
    end
  end

  #################
	#  __equals__?  #
	#################

  context '#__equals__?' do
    it 'topclass binding is equal to itself' do
      topclass_instance_binding.__equals__?( topclass_instance_binding ).should be true
    end
    it 'subclass binding is equal to itself' do
      subclass_instance_binding.__equals__?( subclass_instance_binding ).should be true
    end
  end

  ################
  #  __value__   #
  #  __value__=  #
  ################

  context '#__value__, #__value__=' do
    let( :value ) { 'some value' }
    context 'if __binding_value_valid__? is false' do
      it 'topclass binding will raise error for invalid value' do
        ::Proc.new { topclass_instance_binding.__value__ = value }.should raise_error( ::ArgumentError )
      end
      it 'subclass binding will raise error for invalid value' do
        ::Proc.new { subclass_instance_binding.__value__ = value }.should raise_error( ::ArgumentError )
      end
    end
    context 'if __binding_value_valid__? is true' do
      let( :permitted_value_module ) { ::Perspective::Bindings::BindingDefinitions::Text }
      before :all do
        topclass_instance_binding.__extend__( permitted_value_module )
        subclass_instance_binding.__extend__( permitted_value_module )
      end
      it 'topclass binding will accept valid values' do
        topclass_instance_binding.__value__.should be nil
        topclass_instance_binding.__value__ = value
        topclass_instance_binding.__value__.should be value
      end
      it 'subclass binding will accept valid values' do
        subclass_instance_binding.__value__.should be nil
        subclass_instance_binding.__value__ = value
        subclass_instance_binding.__value__.should be value
      end
    end
  end

  ###########
  #  value  #
  ###########
  
  context '#value' do
    it 'is an alias for #__value__' do
      ::Perspective::Bindings::BindingBase::InstanceBinding.instance_method( :value ).should == ::Perspective::Bindings::BindingBase::InstanceBinding.instance_method( :__value__ )
    end
  end

  ############
  #  value=  #
  ############
  
  context 'value=' do
    it 'is an alias for #__value__=' do
      ::Perspective::Bindings::BindingBase::InstanceBinding.instance_method( :value= ).should == ::Perspective::Bindings::BindingBase::InstanceBinding.instance_method( :__value__= )
    end
  end

	########
	#  ==  #
	########

  context '#==' do
    let( :permitted_value_module ) { ::Perspective::Bindings::BindingDefinitions::Text }
    let( :value ) { 'some value' }
    before :all do
      topclass_instance_binding.__extend__( permitted_value_module ).__value__ = value
      subclass_instance_binding.__extend__( permitted_value_module ).__value__ = value
    end
    it 'topclass binding will accept valid values' do
      topclass_instance_binding.__value__.should == value
    end
    it 'subclass binding will accept valid values' do
      subclass_instance_binding.__value__.should == value
    end
  end

end
