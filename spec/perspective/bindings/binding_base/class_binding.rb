
require_relative '../../../support/class_binding_setup.rb'

shared_examples_for :class_binding do

  setup_class_binding_tests
  
  ########################
  #  __parent_binding__  #
  ########################
  
  context '#__parent_binding__' do
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
  end
  
  ###############################
  #  __validate_binding_name__  #
  ###############################
  
  context '#__validate_binding_name__' do
    shared_examples_for :__validate_binding_name__ do
      let( :binding_to_base_name ) { binding_name }
      let( :binding_to_first_nested_name ) { binding_name }
      let( :binding_to_nth_nested_name ) { binding_name }
      let( :__validate_binding_name__ ) { ::Proc.new { binding_instance } }
      it 'prohibits :new' do
        __validate_binding_name__.should raise_error( ::ArgumentError )
      end
    end
    context 'binding name is :new' do
      let( :binding_name ) { :new }
      context 'bound to base container' do
        it_behaves_like( :__validate_binding_name__ ) { let( :binding_instance ) { class_binding_to_base } }
      end
      context 'bound to first nested container' do
        it_behaves_like( :__validate_binding_name__ ) { let( :binding_instance ) { class_binding_to_first_nested } }
      end
      context 'bound to nth nested container' do
        it_behaves_like( :__validate_binding_name__ ) { let( :binding_instance ) { class_binding_to_nth_nested } }
      end
      context 'bound to subclass of base container' do
        it_behaves_like( :__validate_binding_name__ ) { let( :binding_instance ) { subclass_class_binding_to_base } }
      end
      context 'bound to subclass of first nested container' do
        it_behaves_like( :__validate_binding_name__ ) { let( :binding_instance ) { subclass_class_binding_to_first_nested } }
      end
      context 'bound to subclass of nth nested container' do
        it_behaves_like( :__validate_binding_name__ ) { let( :binding_instance ) { subclass_class_binding_to_nth_nested } }
      end
    end
  end

  #########################
  #  __bound_container__  #
  #########################
  
  context '#__bound_container__' do
    it 'bound to base container' do
      class_binding_to_base.__bound_container__.should == base_container
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__bound_container__.should == class_binding_to_base
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__bound_container__.should == class_binding_to_first_nested
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__bound_container__.should == sub_base_container
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__bound_container__.should == subclass_class_binding_to_base
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__bound_container__.should == subclass_class_binding_to_first_nested
    end
  end
  
  ##############
  #  __name__  #
  ##############
  
  context '#__name__' do
    it 'bound to base container' do
      class_binding_to_base.__name__.should == binding_to_base_name
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__name__.should == binding_to_first_nested_name
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__name__.should == binding_to_nth_nested_name
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__name__.should == binding_to_base_name
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__name__.should == binding_to_first_nested_name
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__name__.should == binding_to_nth_nested_name
    end
  end
  
  ##############
  #  __root__  #
  ##############
  
  context '#__root__' do
    it 'bound to base container' do
      class_binding_to_base.__root__.should == base_container
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__root__.should == base_container
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__root__.should == base_container
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__root__.should == sub_base_container
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__root__.should == sub_base_container
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__root__.should == sub_base_container
    end
  end
  
  ###############
  #  __route__  #
  ###############

  context '#__route__' do
    it 'bound to base container' do
      class_binding_to_base.__route__.should == nil
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__route__.should == [ binding_to_base_name ]
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__route__.should == [ binding_to_base_name, binding_to_first_nested_name ]
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__route__.should == nil
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__route__.should == [ binding_to_base_name ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__route__.should == [ binding_to_base_name, binding_to_first_nested_name ]
    end
  end

  #########################
  #  __route_with_name__  #
  #########################

  context '#__route_with_name__' do
    it 'bound to base container' do
      class_binding_to_base.__route_with_name__.should == [ binding_to_base_name ]
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__route_with_name__.should == [ binding_to_base_name, binding_to_first_nested_name ]
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__route_with_name__.should == [ binding_to_base_name, binding_to_first_nested_name, binding_to_nth_nested_name ]
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__route_with_name__.should == [ binding_to_base_name ]
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__route_with_name__.should == [ binding_to_base_name, binding_to_first_nested_name ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__route_with_name__.should == [ binding_to_base_name, binding_to_first_nested_name, binding_to_nth_nested_name ]
    end
  end

  ######################
  #  __route_string__  #
  ######################

  context '#__route_string__' do
    it 'bound to base container' do
      class_binding_to_base.__route_string__.should == ::Perspective::Bindings.context_string( class_binding_to_base.__route_with_name__ )
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__route_string__.should == ::Perspective::Bindings.context_string( class_binding_to_first_nested.__route_with_name__ )
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__route_string__.should == ::Perspective::Bindings.context_string( class_binding_to_nth_nested.__route_with_name__ )
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__route_string__.should == ::Perspective::Bindings.context_string( subclass_class_binding_to_base.__route_with_name__ )
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__route_string__.should == ::Perspective::Bindings.context_string( subclass_class_binding_to_first_nested.__route_with_name__ )
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__route_string__.should == ::Perspective::Bindings.context_string( subclass_class_binding_to_nth_nested.__route_with_name__ )
    end
  end

  ############################
  #  __route_print_string__  #
  ############################

  context '#__route_print_string__' do
    it 'bound to base container' do
      class_binding_to_base.__route_print_string__.should == ::Perspective::Bindings.context_print_string( base_container, class_binding_to_base.__route_string__ )
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( base_container, class_binding_to_first_nested.__route_string__ )
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( base_container, class_binding_to_nth_nested.__route_string__ )
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__route_print_string__.should == ::Perspective::Bindings.context_print_string( sub_base_container, subclass_class_binding_to_base.__route_string__ )
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( sub_base_container, subclass_class_binding_to_first_nested.__route_string__ )
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( sub_base_container, subclass_class_binding_to_nth_nested.__route_string__ )
    end
  end

  ###########################
  #  __permits_multiple__?  #
  #  __permits_multiple__=  #
  ###########################

  context '#__permits_multiple__?, #__permits_multiple__=' do
    it 'bound to base container' do
      class_binding_to_base.__permits_multiple__?.should be false
      class_binding_to_base.__permits_multiple__ = true
      class_binding_to_base.__permits_multiple__?.should be true
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__permits_multiple__?.should be false
      class_binding_to_first_nested.__permits_multiple__ = true
      class_binding_to_first_nested.__permits_multiple__?.should be true
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__permits_multiple__?.should be false
      class_binding_to_nth_nested.__permits_multiple__ = true
      class_binding_to_nth_nested.__permits_multiple__?.should be true
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__permits_multiple__?.should be false
      subclass_class_binding_to_base.__permits_multiple__ = true
      subclass_class_binding_to_base.__permits_multiple__?.should be true
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__permits_multiple__?.should be false
      subclass_class_binding_to_first_nested.__permits_multiple__ = true
      subclass_class_binding_to_first_nested.__permits_multiple__?.should be true
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__permits_multiple__?.should be false
      subclass_class_binding_to_nth_nested.__permits_multiple__ = true
      subclass_class_binding_to_nth_nested.__permits_multiple__?.should be true
    end
  end
  
  ###################
  #  __required__?  #
  #  __required__=  #
  ###################

  context '#__required__?, #__required__=' do
    it 'bound to base container' do
      class_binding_to_base.__required__?.should be false
      class_binding_to_base.__required__ = true
      class_binding_to_base.__required__?.should be true
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__required__?.should be false
      class_binding_to_first_nested.__required__ = true
      class_binding_to_first_nested.__required__?.should be true
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__required__?.should be false
      class_binding_to_nth_nested.__required__ = true
      class_binding_to_nth_nested.__required__?.should be true
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__required__?.should be false
      subclass_class_binding_to_base.__required__ = true
      subclass_class_binding_to_base.__required__?.should be true
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__required__?.should be false
      subclass_class_binding_to_first_nested.__required__ = true
      subclass_class_binding_to_first_nested.__required__?.should be true
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__required__?.should be false
      subclass_class_binding_to_nth_nested.__required__ = true
      subclass_class_binding_to_nth_nested.__required__?.should be true
    end
  end

  ###################
  #  __optional__?  #
  #  __optional__=  #
  ###################

  context '#__optional__?, #__optional__=' do
    it 'bound to base container' do
      class_binding_to_base.__optional__?.should be true
      class_binding_to_base.__optional__ = false
      class_binding_to_base.__optional__?.should be false
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__optional__?.should be true
      class_binding_to_first_nested.__optional__ = false
      class_binding_to_first_nested.__optional__?.should be false
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__optional__?.should be true
      class_binding_to_nth_nested.__optional__ = false
      class_binding_to_nth_nested.__optional__?.should be false
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__optional__?.should be true
      subclass_class_binding_to_base.__optional__ = false
      subclass_class_binding_to_base.__optional__?.should be false
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__optional__?.should be true
      subclass_class_binding_to_first_nested.__optional__ = false
      subclass_class_binding_to_first_nested.__optional__?.should be false
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__optional__?.should be true
      subclass_class_binding_to_nth_nested.__optional__ = false
      subclass_class_binding_to_nth_nested.__optional__?.should be false
    end
  end

  #############################
  #  __configuration_procs__  #
  #############################

  context '#__configuration_procs__' do
    it 'bound to base container' do
      class_binding_to_base.__configuration_procs__.should == [ base_proc ]
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__configuration_procs__.should == [ first_nested_proc ]
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__configuration_procs__.should == [ nth_nested_proc ]
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__configuration_procs__.should == [ base_proc ]
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__configuration_procs__.should == [ first_nested_proc ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__configuration_procs__.should == [ nth_nested_proc ]
    end
  end

  ###################
  #  __configure__  #
  ###################

  context '#__configure__' do
    let( :another_block ) { ::Proc.new { puts 'another block' } }
    it 'bound to base container' do
      class_binding_to_base.__configuration_procs__.should == [ base_proc ]
      class_binding_to_base.__configure__( & another_block )
      class_binding_to_base.__configuration_procs__.should == [ base_proc, another_block ]
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__configuration_procs__.should == [ first_nested_proc ]
      class_binding_to_first_nested.__configure__( & another_block )
      class_binding_to_first_nested.__configuration_procs__.should == [ first_nested_proc, another_block ]
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__configuration_procs__.should == [ nth_nested_proc ]
      class_binding_to_nth_nested.__configure__( & another_block )
      class_binding_to_nth_nested.__configuration_procs__.should == [ nth_nested_proc, another_block ]
    end
    it 'bound to subclass of base container' do
      subclass_class_binding_to_base.__configuration_procs__.should == [ base_proc ]
      subclass_class_binding_to_base.__configure__( & another_block )
      subclass_class_binding_to_base.__configuration_procs__.should == [ base_proc, another_block ]
    end
    it 'bound to subclass of first nested container' do
      subclass_class_binding_to_first_nested.__configuration_procs__.should == [ first_nested_proc ]
      subclass_class_binding_to_first_nested.__configure__( & another_block )
      subclass_class_binding_to_first_nested.__configuration_procs__.should == [ first_nested_proc, another_block ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_class_binding_to_nth_nested.__configuration_procs__.should == [ nth_nested_proc ]
      subclass_class_binding_to_nth_nested.__configure__( & another_block )
      subclass_class_binding_to_nth_nested.__configuration_procs__.should == [ nth_nested_proc, another_block ]
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
  
end
