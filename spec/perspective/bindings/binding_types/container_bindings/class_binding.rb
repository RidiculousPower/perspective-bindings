# -*- encoding : utf-8 -*-

require_relative '../../binding_base/class_binding.rb'

shared_examples_for :container_class_binding do

  ################################
  #  «validate_container_class»  #
  ################################

  context '#«validate_container_class»' do
    context 'container does not respond to :«bindings»' do
      let( :mock_container_class ) do
        ::Class.new do
          extend ::CascadingConfiguration::Setting
          alias_singleton_method( :new«nested_instance», :new )
          class_binding_methods = ::Module.new.name( :ClassBindingMethods )
          const_set( :ClassBindingMethods, class_binding_methods )
          instance_binding_methods = ::Module.new.name( :ClassBindingMethods )
          const_set( :InstanceBindingMethods, instance_binding_methods )
        end
       end
      it 'will raise Perspective::Bindings::Exception::ContainerClassLacksBindings' do
        ::Proc.new { topclass_class_binding_A.«validate_container_class»( mock_container_class ) }.should raise_error( ::Perspective::Bindings::Exception::ContainerClassLacksBindings )
      end
    end
    context 'container validates' do
      it 'will do nothing' do
        topclass_class_binding_A.«validate_container_class»( nested_container_class_A )
      end
    end
  end

  #########################################
  #  initialize«container_class_support»  #
  #########################################

  context '#initialize«container_class_support»' do
    context 'container does not respond to :«bindings»' do
      let( :mock_container_class ) do
        ::Class.new do
          extend ::CascadingConfiguration::Setting
          alias_singleton_method( :new«nested_instance», :new )
          class_binding_methods = ::Module.new.name( :ClassBindingMethods )
          const_set( :ClassBindingMethods, class_binding_methods )
          instance_binding_methods = ::Module.new.name( :ClassBindingMethods )
          const_set( :InstanceBindingMethods, instance_binding_methods )
        end
       end
      it 'will raise Perspective::Bindings::Exception::ContainerClassLacksBindings' do
        ::Proc.new { topclass_class_binding_A.«container_class» = mock_container_class }.should raise_error( ::Perspective::Bindings::Exception::ContainerClassLacksBindings )
      end
    end
    context 'container validates' do
      it 'will be extended by container class binding methods' do
        topclass_class_binding_A.is_a?( nested_container_class_A::ClassBindingMethods ).should be true
      end
      it 'top binding will have container class as parent' do
        topclass_class_binding_A.•«bindings».is_parent?( nested_container_class_A ).should be true
      end
      it 'sub binding will have parent binding as parent' do
        subclass_class_binding_A.•«bindings».is_parent?( topclass_class_binding_A ).should be true
      end
    end
  end

  #######################
  #  «container_class»  #
  #######################

  context '#«container_class»' do
    it 'topclass bound to root - binding A' do
      topclass_class_binding_A.«container_class».should be nested_container_class_A
    end
    it 'topclass nested binding in A - binding B' do
      topclass_class_binding_A_B.«container_class».should be nested_container_class_B
    end
    it 'topclass nested binding in B - binding C' do
      topclass_class_binding_A_B_C.«container_class».should be nested_container_class_C
    end
    it 'subclass bound to root - binding A' do
      subclass_class_binding_A.«container_class».should be nested_container_class_A
    end
    it 'subclass nested binding in A - binding B' do
      subclass_class_binding_A_B.«container_class».should be nested_container_class_B
    end
    it 'subclass nested binding in B - binding C' do
      subclass_class_binding_A_B_C.«container_class».should be nested_container_class_C
    end
  end

  #####################
  #  container_class  #
  #####################

  context '#container_class' do
    it 'is an alias for #«container_class»' do
      topclass_class_binding_A.class.instance_method( :container_class ).should == topclass_class_binding_A.class.instance_method( :«container_class» )
    end
  end

  ############
  #  «root»  #
  ############
  
  context '#«root»' do
    it 'topclass bound to root - binding A' do
      topclass_class_binding_A.«root».should be topclass_bound_container_class
    end
    it 'topclass nested binding in A - binding B' do
      topclass_class_binding_A_B.«root».should be topclass_bound_container_class
    end
    it 'topclass nested binding in B - binding C' do
      topclass_class_binding_A_B_C.«root».should be topclass_bound_container_class
    end
    it 'subclass bound to root - binding A' do
      subclass_class_binding_A.«root».should be subclass_bound_container_class
    end
    it 'subclass nested binding in A - binding B' do
      subclass_class_binding_A_B.«root».should be subclass_bound_container_class
    end
    it 'subclass nested binding in B - binding C' do
      subclass_class_binding_A_B_C.«root».should be subclass_bound_container_class
    end
  end
  
  #############
  #  «route»  #
  #############

  context '#«route»' do
    it 'topclass bound to root - binding A' do
      topclass_class_binding_A.«route».should == nil
    end
    it 'topclass nested binding in A - binding B' do
      topclass_class_binding_A_B.«route».should == [ topclass_class_binding_A_name ]
    end
    it 'topclass nested binding in B - binding C' do
      topclass_class_binding_A_B_C.«route».should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name ]
    end
    it 'subclass bound to root - binding A' do
      subclass_class_binding_A.«route».should == nil
    end
    it 'subclass nested binding in A - binding B' do
      subclass_class_binding_A_B.«route».should == [ topclass_class_binding_A_name ]
    end
    it 'subclass nested binding in B - binding C' do
      subclass_class_binding_A_B_C.«route».should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name ]
    end
  end

  #######################
  #  «route_with_name»  #
  #######################

  context '#«route_with_name»' do
    it 'topclass bound to root - binding A' do
      topclass_class_binding_A.«route_with_name».should == [ topclass_class_binding_A_name ]
    end
    it 'topclass nested binding in A - binding B' do
      topclass_class_binding_A_B.«route_with_name».should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name ]
    end
    it 'topclass nested binding in B - binding C' do
      topclass_class_binding_A_B_C.«route_with_name».should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name, topclass_class_binding_A_B_C_name ]
    end
    it 'subclass bound to root - binding A' do
      subclass_class_binding_A.«route_with_name».should == [ topclass_class_binding_A_name ]
    end
    it 'subclass nested binding in A - binding B' do
      subclass_class_binding_A_B.«route_with_name».should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name ]
    end
    it 'subclass nested binding in B - binding C' do
      subclass_class_binding_A_B_C.«route_with_name».should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name, topclass_class_binding_A_B_C_name ]
    end
  end

  ####################
  #  «nested_route»  #
  ####################

  context '#«nested_route»' do
    context 'binding is nested in queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_class_binding_A_B.«nested_route»( topclass_class_binding_A ).should == nil
      end
    end
    context 'binding is nested in binding under queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_class_binding_A_B_C.«nested_route»( topclass_class_binding_A ).should == [ topclass_class_binding_A_B_name ]
      end
    end
  end
  
end
