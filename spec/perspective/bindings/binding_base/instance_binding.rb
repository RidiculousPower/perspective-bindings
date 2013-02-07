
require_relative '../../../support/class_binding_setup.rb'

shared_examples_for :instance_binding do

  setup_class_binding_tests
  
  let( :base_container_instance ) { base_container.new }
  let( :first_nested_container_instance ) { first_nested_container.new }
  let( :nth_nested_container_instance ) { nth_nested_container.new }
  let( :sub_base_container_instance ) { sub_base_container.new }
  let( :sub_first_nested_container_instance ) { sub_first_nested_container.new }
  let( :sub_nth_nested_container_instance ) { sub_nth_nested_container.new }

  let( :instance_binding_to_base ) { instance_binding_class.new( class_binding_to_base, base_container_instance ) }
  let( :instance_binding_to_first_nested ) { instance_binding_class.new( class_binding_to_first_nested, instance_binding_to_base ) }
  let( :instance_binding_to_nth_nested ) { instance_binding_class.new( class_binding_to_nth_nested, instance_binding_to_first_nested ) }

  let( :subclass_instance_binding_to_base ) { instance_binding_class.new( subclass_class_binding_to_base, sub_base_container_instance ) }
  let( :subclass_instance_binding_to_first_nested ) { instance_binding_class.new( subclass_class_binding_to_first_nested, subclass_instance_binding_to_base ) }
  let( :subclass_instance_binding_to_nth_nested ) { instance_binding_class.new( subclass_class_binding_to_nth_nested, subclass_instance_binding_to_first_nested ) }

  ########################
  #  __parent_binding__  #
  ########################
  
  context '#__parent_binding__' do
    it 'bound to base container' do
      instance_binding_to_base.__parent_binding__.should == class_binding_to_base
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__parent_binding__.should == class_binding_to_first_nested
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__parent_binding__.should == class_binding_to_nth_nested
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__parent_binding__.should == subclass_class_binding_to_base
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__parent_binding__.should == subclass_class_binding_to_first_nested
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__parent_binding__.should == subclass_class_binding_to_nth_nested
    end
  end
  
  #########################
  #  __bound_container__  #
  #########################
  
  context '#__bound_container__' do
    it 'bound to base container' do
      instance_binding_to_base.__bound_container__.should be base_container_instance
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__bound_container__.should be instance_binding_to_base
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__bound_container__.should be instance_binding_to_first_nested
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__bound_container__.should be sub_base_container_instance
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__bound_container__.should be subclass_instance_binding_to_base
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__bound_container__.should be subclass_instance_binding_to_first_nested
    end
  end

  ##############
  #  __name__  #
  ##############
  
  context '#__name__' do
    it 'bound to base container' do
      instance_binding_to_base.__name__.should == instance_binding_to_base.__parent_binding__.__name__
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__name__.should == instance_binding_to_first_nested.__parent_binding__.__name__
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__name__.should == instance_binding_to_nth_nested.__parent_binding__.__name__
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__name__.should == subclass_instance_binding_to_base.__parent_binding__.__name__
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__name__.should == subclass_instance_binding_to_first_nested.__parent_binding__.__name__
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__name__.should == subclass_instance_binding_to_nth_nested.__parent_binding__.__name__
    end
  end

  ##############
  #  __root__  #
  ##############
  
  context '#__root__' do
    it 'bound to base container' do
      instance_binding_to_base.__root__.should == base_container_instance
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__root__.should == base_container_instance
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__root__.should == base_container_instance
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__root__.should == sub_base_container_instance
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__root__.should == sub_base_container_instance
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__root__.should == sub_base_container_instance
    end
  end

  ###############
  #  __route__  #
  ###############

  context '#__route__' do
    it 'bound to base container' do
      instance_binding_to_base.__route__.should == nil
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__route__.should == [ instance_binding_to_base.__name__ ]
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__route__.should == [ instance_binding_to_base.__name__, instance_binding_to_first_nested.__name__ ]
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__route__.should == nil
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__route__.should == [ subclass_instance_binding_to_base.__name__ ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__route__.should == [ subclass_instance_binding_to_base.__name__, subclass_instance_binding_to_first_nested.__name__ ]
    end
  end

  #########################
  #  __route_with_name__  #
  #########################

  context '#__route_with_name__' do
    it 'bound to base container' do
      instance_binding_to_base.__route_with_name__.should == [ instance_binding_to_base.__name__ ]
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__route_with_name__.should == [ instance_binding_to_base.__name__, instance_binding_to_first_nested.__name__ ]
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__route_with_name__.should == [ instance_binding_to_base.__name__, instance_binding_to_first_nested.__name__, instance_binding_to_nth_nested.__name__ ]
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__route_with_name__.should == [ subclass_instance_binding_to_base.__name__ ]
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__route_with_name__.should == [ subclass_instance_binding_to_base.__name__, subclass_instance_binding_to_first_nested.__name__ ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__route_with_name__.should == [ subclass_instance_binding_to_base.__name__, subclass_instance_binding_to_first_nested.__name__, subclass_instance_binding_to_nth_nested.__name__ ]
    end
  end

  ######################
  #  __route_string__  #
  ######################

  context '#__route_string__' do
    it 'bound to base container' do
      instance_binding_to_base.__route_string__.should == ::Perspective::Bindings.context_string( instance_binding_to_base.__route_with_name__ )
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__route_string__.should == ::Perspective::Bindings.context_string( instance_binding_to_first_nested.__route_with_name__ )
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__route_string__.should == ::Perspective::Bindings.context_string( instance_binding_to_nth_nested.__route_with_name__ )
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__route_string__.should == ::Perspective::Bindings.context_string( subclass_instance_binding_to_base.__route_with_name__ )
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__route_string__.should == ::Perspective::Bindings.context_string( subclass_instance_binding_to_first_nested.__route_with_name__ )
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__route_string__.should == ::Perspective::Bindings.context_string( subclass_instance_binding_to_nth_nested.__route_with_name__ )
    end
  end

  ############################
  #  __route_print_string__  #
  ############################

  context '#__route_print_string__' do
    it 'bound to base container' do
      instance_binding_to_base.__route_print_string__.should == ::Perspective::Bindings.context_print_string( base_container_instance, instance_binding_to_base.__route_string__ )
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( base_container_instance, instance_binding_to_first_nested.__route_string__ )
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( base_container_instance, instance_binding_to_nth_nested.__route_string__ )
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__route_print_string__.should == ::Perspective::Bindings.context_print_string( sub_base_container_instance, subclass_instance_binding_to_base.__route_string__ )
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( sub_base_container_instance, subclass_instance_binding_to_first_nested.__route_string__ )
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( sub_base_container_instance, subclass_instance_binding_to_nth_nested.__route_string__ )
    end
  end

  ###########################
  #  __permits_multiple__?  #
  #  __permits_multiple__=  #
  ###########################

  context '#__permits_multiple__?, #__permits_multiple__=' do
    it 'bound to base container' do
      instance_binding_to_base.__permits_multiple__?.should be false
      instance_binding_to_base.__permits_multiple__ = true
      instance_binding_to_base.__permits_multiple__?.should be true
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__permits_multiple__?.should be false
      instance_binding_to_first_nested.__permits_multiple__ = true
      instance_binding_to_first_nested.__permits_multiple__?.should be true
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__permits_multiple__?.should be false
      instance_binding_to_nth_nested.__permits_multiple__ = true
      instance_binding_to_nth_nested.__permits_multiple__?.should be true
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__permits_multiple__?.should be false
      subclass_instance_binding_to_base.__permits_multiple__ = true
      subclass_instance_binding_to_base.__permits_multiple__?.should be true
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__permits_multiple__?.should be false
      subclass_instance_binding_to_first_nested.__permits_multiple__ = true
      subclass_instance_binding_to_first_nested.__permits_multiple__?.should be true
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__permits_multiple__?.should be false
      subclass_instance_binding_to_nth_nested.__permits_multiple__ = true
      subclass_instance_binding_to_nth_nested.__permits_multiple__?.should be true
    end
  end

  ###################
  #  __required__?  #
  #  __required__=  #
  ###################

  context '#__required__?, #__required__=' do
    it 'bound to base container' do
      instance_binding_to_base.__required__?.should be false
      instance_binding_to_base.__required__ = true
      instance_binding_to_base.__required__?.should be true
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__required__?.should be false
      instance_binding_to_first_nested.__required__ = true
      instance_binding_to_first_nested.__required__?.should be true
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__required__?.should be false
      instance_binding_to_nth_nested.__required__ = true
      instance_binding_to_nth_nested.__required__?.should be true
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__required__?.should be false
      subclass_instance_binding_to_base.__required__ = true
      subclass_instance_binding_to_base.__required__?.should be true
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__required__?.should be false
      subclass_instance_binding_to_first_nested.__required__ = true
      subclass_instance_binding_to_first_nested.__required__?.should be true
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__required__?.should be false
      subclass_instance_binding_to_nth_nested.__required__ = true
      subclass_instance_binding_to_nth_nested.__required__?.should be true
    end
  end

  ###################
  #  __optional__?  #
  #  __optional__=  #
  ###################

  context '#__optional__?, #__optional__=' do
    it 'bound to base container' do
      instance_binding_to_base.__optional__?.should be true
      instance_binding_to_base.__optional__ = false
      instance_binding_to_base.__optional__?.should be false
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__optional__?.should be true
      instance_binding_to_first_nested.__optional__ = false
      instance_binding_to_first_nested.__optional__?.should be false
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__optional__?.should be true
      instance_binding_to_nth_nested.__optional__ = false
      instance_binding_to_nth_nested.__optional__?.should be false
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__optional__?.should be true
      subclass_instance_binding_to_base.__optional__ = false
      subclass_instance_binding_to_base.__optional__?.should be false
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__optional__?.should be true
      subclass_instance_binding_to_first_nested.__optional__ = false
      subclass_instance_binding_to_first_nested.__optional__?.should be false
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__optional__?.should be true
      subclass_instance_binding_to_nth_nested.__optional__ = false
      subclass_instance_binding_to_nth_nested.__optional__?.should be false
    end
  end

  ##############################
  #  __binding_value_valid__?  #
  ##############################
  
  context '#__binding_value_valid__?' do
    let( :value ) { 'some value' }
    let( :bad_value ) { 42 }
    context 'without permitted value module(s)' do
      it 'bound to base container' do
        instance_binding_to_base.__binding_value_valid__?( value ).should be false
        instance_binding_to_base.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to first nested container' do
        instance_binding_to_first_nested.__binding_value_valid__?( value ).should be false
        instance_binding_to_first_nested.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to nth nested container' do
        instance_binding_to_nth_nested.__binding_value_valid__?( value ).should be false
        instance_binding_to_nth_nested.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to subclass of base container' do
        subclass_instance_binding_to_base.__binding_value_valid__?( value ).should be false
        subclass_instance_binding_to_base.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to subclass of first nested container' do
        subclass_instance_binding_to_first_nested.__binding_value_valid__?( value ).should be false
        subclass_instance_binding_to_first_nested.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to subclass of nth nested container' do
        subclass_instance_binding_to_nth_nested.__binding_value_valid__?( value ).should be false
        subclass_instance_binding_to_nth_nested.__binding_value_valid__?( bad_value ).should be false
      end
    end
    context 'with permitted value module' do
      let( :permitted_value_module ) { ::Perspective::Bindings::BindingDefinitions::Text }
      before :each do
        instance_binding_to_base.__extend__( permitted_value_module )
        instance_binding_to_first_nested.__extend__( permitted_value_module )
        instance_binding_to_nth_nested.__extend__( permitted_value_module )
        subclass_instance_binding_to_base.__extend__( permitted_value_module )
        subclass_instance_binding_to_first_nested.__extend__( permitted_value_module )
        subclass_instance_binding_to_nth_nested.__extend__( permitted_value_module )
      end
      it 'bound to base container' do
        instance_binding_to_base.__binding_value_valid__?( value ).should be true
        instance_binding_to_base.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to first nested container' do
        instance_binding_to_first_nested.__binding_value_valid__?( value ).should be true
        instance_binding_to_first_nested.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to nth nested container' do
        instance_binding_to_nth_nested.__binding_value_valid__?( value ).should be true
        instance_binding_to_nth_nested.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to subclass of base container' do
        subclass_instance_binding_to_base.__binding_value_valid__?( value ).should be true
        subclass_instance_binding_to_base.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to subclass of first nested container' do
        subclass_instance_binding_to_first_nested.__binding_value_valid__?( value ).should be true
        subclass_instance_binding_to_first_nested.__binding_value_valid__?( bad_value ).should be false
      end
      it 'bound to subclass of nth nested container' do
        subclass_instance_binding_to_nth_nested.__binding_value_valid__?( value ).should be true
        subclass_instance_binding_to_nth_nested.__binding_value_valid__?( bad_value ).should be false
      end
      context 'when does not permit multiple and value is array' do
        let( :value ) { [ :any_array ] }
        it 'bound to base container' do
          instance_binding_to_base.__binding_value_valid__?( value ).should be false
        end
        it 'bound to first nested container' do
          instance_binding_to_first_nested.__binding_value_valid__?( value ).should be false
        end
        it 'bound to nth nested container' do
          instance_binding_to_nth_nested.__binding_value_valid__?( value ).should be false
        end
        it 'bound to subclass of base container' do
          subclass_instance_binding_to_base.__binding_value_valid__?( value ).should be false
        end
        it 'bound to subclass of first nested container' do
          subclass_instance_binding_to_first_nested.__binding_value_valid__?( value ).should be false
        end
        it 'bound to subclass of nth nested container' do
          subclass_instance_binding_to_nth_nested.__binding_value_valid__?( value ).should be false
        end
      end
      context 'when permits multiple and value is array' do
        before :each do
          instance_binding_to_base.__permits_multiple__ = true
          instance_binding_to_first_nested.__permits_multiple__ = true
          instance_binding_to_nth_nested.__permits_multiple__ = true
        end
        it 'bound to base container' do
          instance_binding_to_base.__binding_value_valid__?( value ).should be true
        end
        it 'bound to first nested container' do
          instance_binding_to_first_nested.__binding_value_valid__?( value ).should be true
        end
        it 'bound to nth nested container' do
          instance_binding_to_nth_nested.__binding_value_valid__?( value ).should be true
        end
        it 'bound to subclass of base container' do
          subclass_instance_binding_to_base.__binding_value_valid__?( value ).should be true
        end
        it 'bound to subclass of first nested container' do
          subclass_instance_binding_to_first_nested.__binding_value_valid__?( value ).should be true
        end
        it 'bound to subclass of nth nested container' do
          subclass_instance_binding_to_nth_nested.__binding_value_valid__?( value ).should be true
        end
      end
    end
  end

  #################
	#  __equals__?  #
	#################

  context '#__equals__?' do
    it 'bound to base container' do
      instance_binding_to_base.__equals__?( instance_binding_to_base ).should be true
      instance_binding_to_base.__equals__?( instance_binding_to_first_nested ).should be false
      instance_binding_to_base.__equals__?( instance_binding_to_nth_nested ).should be false
      instance_binding_to_base.__equals__?( subclass_instance_binding_to_base ).should be false
      instance_binding_to_base.__equals__?( subclass_instance_binding_to_first_nested ).should be false
      instance_binding_to_base.__equals__?( subclass_instance_binding_to_nth_nested ).should be false
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.__equals__?( instance_binding_to_first_nested ).should be true
      instance_binding_to_first_nested.__equals__?( instance_binding_to_base ).should be false
      instance_binding_to_first_nested.__equals__?( instance_binding_to_nth_nested ).should be false
      instance_binding_to_first_nested.__equals__?( subclass_instance_binding_to_base ).should be false
      instance_binding_to_first_nested.__equals__?( subclass_instance_binding_to_first_nested ).should be false
      instance_binding_to_first_nested.__equals__?( subclass_instance_binding_to_nth_nested ).should be false
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.__equals__?( instance_binding_to_nth_nested ).should be true
      instance_binding_to_nth_nested.__equals__?( instance_binding_to_base ).should be false
      instance_binding_to_nth_nested.__equals__?( instance_binding_to_first_nested ).should be false
      instance_binding_to_nth_nested.__equals__?( subclass_instance_binding_to_base ).should be false
      instance_binding_to_nth_nested.__equals__?( subclass_instance_binding_to_first_nested ).should be false
      instance_binding_to_nth_nested.__equals__?( subclass_instance_binding_to_nth_nested ).should be false
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.__equals__?( subclass_instance_binding_to_base ).should be true
      subclass_instance_binding_to_base.__equals__?( instance_binding_to_base ).should be false
      subclass_instance_binding_to_base.__equals__?( instance_binding_to_first_nested ).should be false
      subclass_instance_binding_to_base.__equals__?( instance_binding_to_nth_nested ).should be false
      subclass_instance_binding_to_base.__equals__?( subclass_instance_binding_to_first_nested ).should be false
      subclass_instance_binding_to_base.__equals__?( subclass_instance_binding_to_nth_nested ).should be false
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.__equals__?( subclass_instance_binding_to_first_nested ).should be true
      subclass_instance_binding_to_first_nested.__equals__?( instance_binding_to_base ).should be false
      subclass_instance_binding_to_first_nested.__equals__?( instance_binding_to_first_nested ).should be false
      subclass_instance_binding_to_first_nested.__equals__?( instance_binding_to_nth_nested ).should be false
      subclass_instance_binding_to_first_nested.__equals__?( subclass_instance_binding_to_base ).should be false
      subclass_instance_binding_to_first_nested.__equals__?( subclass_instance_binding_to_nth_nested ).should be false
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.__equals__?( subclass_instance_binding_to_nth_nested ).should be true
      subclass_instance_binding_to_nth_nested.__equals__?( instance_binding_to_base ).should be false
      subclass_instance_binding_to_nth_nested.__equals__?( instance_binding_to_first_nested ).should be false
      subclass_instance_binding_to_nth_nested.__equals__?( instance_binding_to_nth_nested ).should be false
      subclass_instance_binding_to_nth_nested.__equals__?( subclass_instance_binding_to_base ).should be false
      subclass_instance_binding_to_nth_nested.__equals__?( subclass_instance_binding_to_first_nested ).should be false
    end
  end

  ################
  #  __value__   #
  #  __value__=  #
  ################

  context '#__value__, #__value__=' do
    let( :value ) { 'some value' }
    context 'if __binding_value_valid__? is false' do
      it 'bound to base container' do
        ::Proc.new { instance_binding_to_base.__value__ = value }.should raise_error( ::ArgumentError )
      end
      it 'bound to first nested container' do
        ::Proc.new { instance_binding_to_first_nested.__value__ = value }.should raise_error( ::ArgumentError )
      end
      it 'bound to nth nested container' do
        ::Proc.new { instance_binding_to_nth_nested.__value__ = value }.should raise_error( ::ArgumentError )
      end
      it 'bound to subclass of base container' do
        ::Proc.new { subclass_instance_binding_to_base.__value__ = value }.should raise_error( ::ArgumentError )
      end
      it 'bound to subclass of first nested container' do
        ::Proc.new { subclass_instance_binding_to_first_nested.__value__ = value }.should raise_error( ::ArgumentError )
      end
      it 'bound to subclass of nth nested container' do
        ::Proc.new { subclass_instance_binding_to_nth_nested.__value__ = value }.should raise_error( ::ArgumentError )
      end
    end
    context 'if __binding_value_valid__? is true' do
      let( :permitted_value_module ) { ::Perspective::Bindings::BindingDefinitions::Text }
      before :all do
        instance_binding_to_base.__extend__( permitted_value_module )
        instance_binding_to_first_nested.__extend__( permitted_value_module )
        instance_binding_to_nth_nested.__extend__( permitted_value_module )
        subclass_instance_binding_to_base.__extend__( permitted_value_module )
        subclass_instance_binding_to_first_nested.__extend__( permitted_value_module )
        subclass_instance_binding_to_nth_nested.__extend__( permitted_value_module )
      end
      it 'bound to base container' do
        instance_binding_to_base.__value__.should be nil
        instance_binding_to_base.__value__ = value
        instance_binding_to_base.__value__.should be value
      end
      it 'bound to first nested container' do
        instance_binding_to_first_nested.__value__.should be nil
        instance_binding_to_first_nested.__value__ = value
        instance_binding_to_first_nested.__value__.should be value
      end
      it 'bound to nth nested container' do
        instance_binding_to_nth_nested.__value__.should be nil
        instance_binding_to_nth_nested.__value__ = value
        instance_binding_to_nth_nested.__value__.should be value
      end
      it 'bound to subclass of base container' do
        subclass_instance_binding_to_base.__value__.should be nil
        subclass_instance_binding_to_base.__value__ = value
        subclass_instance_binding_to_base.__value__.should be value
      end
      it 'bound to subclass of first nested container' do
        subclass_instance_binding_to_first_nested.__value__.should be nil
        subclass_instance_binding_to_first_nested.__value__ = value
        subclass_instance_binding_to_first_nested.__value__.should be value
      end
      it 'bound to subclass of nth nested container' do
        subclass_instance_binding_to_nth_nested.__value__.should be nil
        subclass_instance_binding_to_nth_nested.__value__ = value
        subclass_instance_binding_to_nth_nested.__value__.should be value
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
      instance_binding_to_base.__extend__( permitted_value_module ).__value__ = value
      instance_binding_to_first_nested.__extend__( permitted_value_module ).__value__ = value
      instance_binding_to_nth_nested.__extend__( permitted_value_module ).__value__ = value
      subclass_instance_binding_to_base.__extend__( permitted_value_module ).__value__ = value
      subclass_instance_binding_to_first_nested.__extend__( permitted_value_module ).__value__ = value
      subclass_instance_binding_to_nth_nested.__extend__( permitted_value_module ).__value__ = value
      
    end
    it 'bound to base container' do
      instance_binding_to_base.should == value
    end
    it 'bound to first nested container' do
      instance_binding_to_first_nested.should == value
    end
    it 'bound to nth nested container' do
      instance_binding_to_nth_nested.should == value
    end
    it 'bound to subclass of base container' do
      subclass_instance_binding_to_base.should == value
    end
    it 'bound to subclass of first nested container' do
      subclass_instance_binding_to_first_nested.should == value
    end
    it 'bound to subclass of nth nested container' do
      subclass_instance_binding_to_nth_nested.should == value
    end
  end

end
