
require_relative '../../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::BindingBase::ClassBinding do

  let( :class_binding_mock ) { ::Class.new { include( ::Perspective::Bindings::BindingBase::ClassBinding ) } }

  let( :mock_container_module ) do
    ::Module.new do
      def __root__ ; return self ; end
      def __root_string__ ; return to_s ; end
    end
  end
  
  let( :base_container ) do
    _mock_container_module = mock_container_module
    ::Class.new { extend( _mock_container_module ) }
  end
  let( :first_nested_container ) do
    _mock_container_module = mock_container_module
    ::Class.new { extend( _mock_container_module ) }
  end
  let( :nth_nested_container ) do
    _mock_container_module = mock_container_module
    ::Class.new { extend( _mock_container_module ) }
  end
  let( :sub_base_container ) { ::Class.new( base_container ) }
  let( :sub_first_nested_container ) { ::Class.new( first_nested_container ) }
  let( :sub_nth_nested_container ) { ::Class.new( nth_nested_container ) }
    
  let( :binding_to_base_name ) { :binding_to_base }
  let( :binding_to_first_nested_name ) { :binding_to_first_nested }
  let( :binding_to_nth_nested_name ) { :binding_to_nth_nested }

  let( :class_binding_to_base ) { class_binding_mock.new( base_container, binding_to_base_name, & base_proc ) }
  let( :class_binding_to_first_nested ) { class_binding_mock.new( class_binding_to_base, binding_to_first_nested_name, & first_nested_proc ) }
  let( :class_binding_to_nth_nested ) { class_binding_mock.new( class_binding_to_first_nested, binding_to_nth_nested_name, & nth_nested_proc ) }
  
  let( :base_proc ) { ::Proc.new { puts 'base_proc!' } }
  let( :first_nested_proc ) { ::Proc.new { puts 'first_nested_proc!' } }
  let( :nth_nested_proc ) { ::Proc.new { puts 'nth_nested_proc!' } }

  let( :subclass_binding_to_base ) { class_binding_mock.new( sub_base_container, nil, class_binding_to_base ) }
  let( :subclass_binding_to_first_nested ) { class_binding_mock.new( subclass_binding_to_base, nil, class_binding_to_first_nested ) }
  let( :subclass_binding_to_nth_nested ) { class_binding_mock.new( subclass_binding_to_first_nested, nil, class_binding_to_nth_nested ) }
  
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
        it_behaves_like( :__validate_binding_name__ ) { let( :binding_instance ) { subclass_binding_to_base } }
      end
      context 'bound to subclass of first nested container' do
        it_behaves_like( :__validate_binding_name__ ) { let( :binding_instance ) { subclass_binding_to_first_nested } }
      end
      context 'bound to subclass of nth nested container' do
        it_behaves_like( :__validate_binding_name__ ) { let( :binding_instance ) { subclass_binding_to_nth_nested } }
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
      subclass_binding_to_base.__bound_container__.should == sub_base_container
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__bound_container__.should == subclass_binding_to_base
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__bound_container__.should == subclass_binding_to_first_nested
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
      subclass_binding_to_base.__name__.should == binding_to_base_name
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__name__.should == binding_to_first_nested_name
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__name__.should == binding_to_nth_nested_name
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
      subclass_binding_to_base.__root__.should == sub_base_container
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__root__.should == sub_base_container
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__root__.should == sub_base_container
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
      subclass_binding_to_base.__route__.should == nil
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__route__.should == [ binding_to_base_name ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__route__.should == [ binding_to_base_name, binding_to_first_nested_name ]
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
      subclass_binding_to_base.__route_with_name__.should == [ binding_to_base_name ]
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__route_with_name__.should == [ binding_to_base_name, binding_to_first_nested_name ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__route_with_name__.should == [ binding_to_base_name, binding_to_first_nested_name, binding_to_nth_nested_name ]
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
      subclass_binding_to_base.__route_string__.should == ::Perspective::Bindings.context_string( subclass_binding_to_base.__route_with_name__ )
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__route_string__.should == ::Perspective::Bindings.context_string( subclass_binding_to_first_nested.__route_with_name__ )
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__route_string__.should == ::Perspective::Bindings.context_string( subclass_binding_to_nth_nested.__route_with_name__ )
    end
  end

  ############################
  #  __route_print_string__  #
  ############################

  context '#__route_print_string__' do
    it 'bound to base container' do
      class_binding_to_base.__route_print_string__.should == ::Perspective::Bindings.context_print_string( class_binding_to_base.__root__, class_binding_to_base.__route_string__ )
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( class_binding_to_base.__root__, class_binding_to_first_nested.__route_string__ )
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( class_binding_to_base.__root__, class_binding_to_nth_nested.__route_string__ )
    end
    it 'bound to subclass of base container' do
      subclass_binding_to_base.__route_print_string__.should == ::Perspective::Bindings.context_print_string( subclass_binding_to_base.__root__, subclass_binding_to_base.__route_string__ )
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( subclass_binding_to_base.__root__, subclass_binding_to_first_nested.__route_string__ )
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__route_print_string__.should == ::Perspective::Bindings.context_print_string( subclass_binding_to_base.__root__, subclass_binding_to_nth_nested.__route_string__ )
    end
  end

  ######################
  #  __nested_route__  #
  ######################

  context '#__nested_route__' do
    it 'bound to base container' do
      class_binding_to_base.__nested_route__( class_binding_to_base ).should == nil
    end
    it 'bound to first nested container' do
      class_binding_to_first_nested.__nested_route__( class_binding_to_base ).should == nil
      class_binding_to_first_nested.__nested_route__( class_binding_to_first_nested ).should == nil
    end
    it 'bound to nth nested container' do
      class_binding_to_nth_nested.__nested_route__( class_binding_to_base ).should == [ binding_to_first_nested_name ]
      class_binding_to_nth_nested.__nested_route__( class_binding_to_first_nested ).should == nil
    end
    it 'bound to subclass of base container' do
      subclass_binding_to_base.__nested_route__( subclass_binding_to_base ).should == nil
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__nested_route__( subclass_binding_to_base ).should == nil
      subclass_binding_to_first_nested.__nested_route__( subclass_binding_to_first_nested ).should == nil
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__nested_route__( class_binding_to_base ).should == [ binding_to_first_nested_name ]
      subclass_binding_to_nth_nested.__nested_route__( class_binding_to_first_nested ).should == nil
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
      subclass_binding_to_base.__permits_multiple__?.should be false
      subclass_binding_to_base.__permits_multiple__ = true
      subclass_binding_to_base.__permits_multiple__?.should be true
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__permits_multiple__?.should be false
      subclass_binding_to_first_nested.__permits_multiple__ = true
      subclass_binding_to_first_nested.__permits_multiple__?.should be true
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__permits_multiple__?.should be false
      subclass_binding_to_nth_nested.__permits_multiple__ = true
      subclass_binding_to_nth_nested.__permits_multiple__?.should be true
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
      subclass_binding_to_base.__required__?.should be false
      subclass_binding_to_base.__required__ = true
      subclass_binding_to_base.__required__?.should be true
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__required__?.should be false
      subclass_binding_to_first_nested.__required__ = true
      subclass_binding_to_first_nested.__required__?.should be true
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__required__?.should be false
      subclass_binding_to_nth_nested.__required__ = true
      subclass_binding_to_nth_nested.__required__?.should be true
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
      subclass_binding_to_base.__optional__?.should be true
      subclass_binding_to_base.__optional__ = false
      subclass_binding_to_base.__optional__?.should be false
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__optional__?.should be true
      subclass_binding_to_first_nested.__optional__ = false
      subclass_binding_to_first_nested.__optional__?.should be false
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__optional__?.should be true
      subclass_binding_to_nth_nested.__optional__ = false
      subclass_binding_to_nth_nested.__optional__?.should be false
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
      subclass_binding_to_base.__configuration_procs__.should == [ base_proc ]
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__configuration_procs__.should == [ first_nested_proc ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__configuration_procs__.should == [ nth_nested_proc ]
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
      subclass_binding_to_base.__configuration_procs__.should == [ base_proc ]
      subclass_binding_to_base.__configure__( & another_block )
      subclass_binding_to_base.__configuration_procs__.should == [ base_proc, another_block ]
    end
    it 'bound to subclass of first nested container' do
      subclass_binding_to_first_nested.__configuration_procs__.should == [ first_nested_proc ]
      subclass_binding_to_first_nested.__configure__( & another_block )
      subclass_binding_to_first_nested.__configuration_procs__.should == [ first_nested_proc, another_block ]
    end
    it 'bound to subclass of nth nested container' do
      subclass_binding_to_nth_nested.__configuration_procs__.should == [ nth_nested_proc ]
      subclass_binding_to_nth_nested.__configure__( & another_block )
      subclass_binding_to_nth_nested.__configuration_procs__.should == [ nth_nested_proc, another_block ]
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
