
shared_examples_for :container_class_binding do

  ##################################
  #  __validate_container_class__  #
  ##################################

  context '#__validate_container_class__' do
    context 'container does not respond to :__bindings__' do
      let( :mock_container_class ) { ::Class.new.name( :BrokenContainer ) }
      it 'will raise Perspective::Bindings::Exception::ContainerClassLacksBindings' do
        ::Proc.new { topclass_class_binding_A.__validate_container_class__( nested_container_class_A ) }.should raise_error( ::Perspective::Bindings::Exception::ContainerClassLacksBindings )
      end
    end
    context 'container validates' do
      it 'will do nothing' do
        topclass_class_binding_A.__validate_container_class__( nested_container_class_A )
      end
    end
  end

  ########################################
  #  __initialize_for_container_class__  #
  ########################################

  context '#__initialize_for_container_class__' do
    context 'container does not respond to :__bindings__' do
      let( :mock_container_class ) { ::Class.new.name( :BrokenContainer ) }
      it 'will raise Perspective::Bindings::Exception::ContainerClassLacksBindings' do
        ::Proc.new { topclass_class_binding_A }.should raise_error( ::Perspective::Bindings::Exception::ContainerClassLacksBindings )
      end
    end
    context 'container validates' do
      it 'will be extended by container class binding methods' do
        topclass_class_binding_A.is_a?( mock_container_class::Controller::ClassBindingMethods ).should be true
      end
      it 'top binding will have container class as parent' do
        ::CascadingConfiguration.configuration( topclass_class_binding_A, :__bindings__ ).is_parent?( nested_container_class_A ).should be true
      end
      it 'sub binding will have parent binding as parent' do
        ::CascadingConfiguration.configuration( subclass_class_binding_A, :__bindings__ ).is_parent?( topclass_class_binding_A ).should be true
      end
    end
  end

  #########################
  #  __container_class__  #
  #########################

  context '#__container_class__' do
    it 'topclass bound to root - binding A' do
      topclass_class_binding_A.__container_class__.should be nested_container_class_A
    end
    it 'topclass nested binding in A - binding B' do
      topclass_class_binding_A_B.__container_class__.should be nested_container_class_B
    end
    it 'topclass nested binding in B - binding C' do
      topclass_class_binding_A_B_C.__container_class__.should be nested_container_class_C
    end
    it 'subclass bound to root - binding A' do
      subclass_class_binding_A.__container_class__.should be nested_container_class_A
    end
    it 'subclass nested binding in A - binding B' do
      subclass_class_binding_A_B.__container_class__.should be nested_container_class_B
    end
    it 'subclass nested binding in B - binding C' do
      subclass_class_binding_A_B_C.__container_class__.should be nested_container_class_C
    end
  end

  #####################
  #  container_class  #
  #####################

  context '#container_class' do
    it 'is an alias for #__container_class__' do
      class_binding_class.instance_method( :container_class ).should == class_binding_class.instance_method( :__container_class__ )
    end
  end

  ##############
  #  __root__  #
  ##############
  
  context '#__root__' do
    it 'topclass bound to root - binding A' do
      topclass_class_binding_A.__root__.should be topclass_bound_container_class
    end
    it 'topclass nested binding in A - binding B' do
      topclass_class_binding_A_B.__root__.should be topclass_bound_container_class
    end
    it 'topclass nested binding in B - binding C' do
      topclass_class_binding_A_B_C.__root__.should be topclass_bound_container_class
    end
    it 'subclass bound to root - binding A' do
      subclass_class_binding_A.__root__.should be subclass_bound_container_class
    end
    it 'subclass nested binding in A - binding B' do
      subclass_class_binding_A_B.__root__.should be subclass_bound_container_class
    end
    it 'subclass nested binding in B - binding C' do
      subclass_class_binding_A_B_C.__root__.should be subclass_bound_container_class
    end
  end
  
  ###############
  #  __route__  #
  ###############

  context '#__route__' do
    it 'topclass bound to root - binding A' do
      topclass_class_binding_A.__route__.should == nil
    end
    it 'topclass nested binding in A - binding B' do
      topclass_class_binding_A_B.__route__.should == [ topclass_class_binding_A_name ]
    end
    it 'topclass nested binding in B - binding C' do
      topclass_class_binding_A_B_C.__route__.should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name ]
    end
    it 'subclass bound to root - binding A' do
      subclass_class_binding_A.__route__.should == nil
    end
    it 'subclass nested binding in A - binding B' do
      subclass_class_binding_A_B.__route__.should == [ topclass_class_binding_A_name ]
    end
    it 'subclass nested binding in B - binding C' do
      subclass_class_binding_A_B_C.__route__.should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name ]
    end
  end

  #########################
  #  __route_with_name__  #
  #########################

  context '#__route_with_name__' do
    it 'topclass bound to root - binding A' do
      topclass_class_binding_A.__route_with_name__.should == [ topclass_class_binding_A_name ]
    end
    it 'topclass nested binding in A - binding B' do
      topclass_class_binding_A_B.__route_with_name__.should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name ]
    end
    it 'topclass nested binding in B - binding C' do
      topclass_class_binding_A_B_C.__route_with_name__.should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name, topclass_class_binding_A_B_C_name ]
    end
    it 'subclass bound to root - binding A' do
      subclass_class_binding_A.__route_with_name__.should == [ topclass_class_binding_A_name ]
    end
    it 'subclass nested binding in A - binding B' do
      subclass_class_binding_A_B.__route_with_name__.should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name ]
    end
    it 'subclass nested binding in B - binding C' do
      subclass_class_binding_A_B_C.__route_with_name__.should == [ topclass_class_binding_A_name, topclass_class_binding_A_B_name, topclass_class_binding_A_B_C_name ]
    end
  end

  ######################
  #  __nested_route__  #
  ######################

  context '#__nested_route__' do
    context 'binding is nested in queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_class_binding_A_B.__nested_route__( topclass_class_binding_A ).should == nil
      end
    end
    context 'binding is nested in binding under queried binding' do
      it 'will return the route from queried container to parameter binding' do
        topclass_class_binding_A_B_C.__nested_route__( topclass_class_binding_A ).should == [ topclass_class_binding_A_B_name ]
      end
    end
  end
  
end
