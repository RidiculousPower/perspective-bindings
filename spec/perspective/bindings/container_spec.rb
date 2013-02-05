
require_relative '../../../lib/perspective/bindings.rb'

describe ::Perspective::Bindings::Container do
  
  # Class A
  # * Nested Class B
  #   * Nested Class C
  # Class B
  # * Nested Class C
  # Class C
  # Module => Module => Class
  #                     * Nested Class A
  #                       * Nested Class B
  #                         * Nested Class C
  #                  => Subclass
  #                     * Nested Class A
  #                       * Nested Class B
  #                         * Nested Class C

  let( :module_instance ) do
    ::Module.new do
      include ::Perspective::Bindings::Container
      attr_text :content
    end
  end
  let( :instance_enabled_with_module ) { ::Object.extend( module_instance ) }

  let( :sub_module_instance ) do
    _module_instance = module_instance
    ::Module.new do
      include _module_instance
      attr_binding :binding_one, :binding_two
    end
  end
  let( :instance_enabled_with_sub_module ) { ::Object.extend( sub_module_instance ) }

  let( :class_instance ) do
    _sub_module_instance = sub_module_instance
    _nested_class_A = nested_class_A
    ::Class.new do
      include _sub_module_instance
      attr_text :a, _nested_class_A
    end
  end
  let( :nested_class_A ) do
    _nested_class_A_B = nested_class_A_B
    ::Class.new do
      include ::Perspective::Bindings::Container
      attr_text :b, _nested_class_A_B
    end
  end
  let( :nested_class_A_B ) do
    _nested_class_A_B_C = nested_class_A_B_C
    ::Class.new do
      include ::Perspective::Bindings::Container
      attr_text :c, _nested_class_A_B_C
    end
  end
  let( :nested_class_A_B_C ) { ::Class.new { include ::Perspective::Bindings::Container } }
  let( :instance_of_class ) { class_instance.new }

  let( :subclass_instance ) { ::Class.new( class_instance ) }
  let( :instance_of_subclass ) { subclass_instance.new }

  ###########
  #  ::new  #
  ###########
  
  context '::new' do
    context 'module instance' do
      it 'does not respond to ::new' do
        module_instance.respond_to?( :new ).should be false
      end
    end
    context 'sub module instance' do
      it 'does not respond to ::new' do
        sub_module_instance.respond_to?( :new ).should be false
      end
    end
    context 'class instance' do
      it 'is owned by Perspective::Bindings::Container::ClassInstance' do
        class_instance.method( :new ).owner.should be ::Perspective::Bindings::Container::ClassInstance
      end
    end
    context 'subclass instance' do
      it 'is owned by Perspective::Bindings::Container::ClassInstance' do
        subclass_instance.method( :new ).owner.should be ::Perspective::Bindings::Container::ClassInstance
      end
    end
  end
  
  #########################
  #  new_nested_instance  #
  #########################

  context '::new_nested_instance' do
    context 'module' do
      it 'does not respond to ::new_nested_instance' do
        module_instance.respond_to?( :new_nested_instance ).should be false
      end
    end
    context 'sub module' do
      it 'does not respond to ::new_nested_instance' do
        sub_module_instance.respond_to?( :new_nested_instance ).should be false
      end
    end
    context 'class' do
      it 'is owned by Perspective::Bindings::Container::ClassInstance' do
        class_instance.method( :new_nested_instance ).owner.should be ::Perspective::Bindings::Container::ClassInstance
      end
    end
    context 'subclass' do
      it 'is owned by Perspective::Bindings::Container::ClassInstance' do
        subclass_instance.method( :new_nested_instance ).owner.should be ::Perspective::Bindings::Container::ClassInstance
      end
    end
  end

  ##############
  #  __name__  #
  ##############

  context '::__name__' do
    context 'module' do
      it 'does not respond to ::__name__' do
        module_instance.respond_to?( :__name__ ).should be false
      end
    end
    context 'sub module' do
      it 'does not respond to ::__name__' do
        sub_module_instance.respond_to?( :__name__ ).should be false
      end
    end
    context 'class' do
      it 'does not respond to ::__name__' do
        class_instance.respond_to?( :__name__ ).should be false
      end
    end
    context 'subclass' do
      it 'does not respond to ::__name__' do
        subclass.respond_to?( :__name__ ).should be false
      end
    end
  end

  context '#__name__' do
    context 'instance enabled with module' do
      it 'root container will return root string' do
        instance_enabled_with_module.__name__.should be module_instance.__root_string__
      end
    end
    context 'instance enabled with sub module' do
      it 'root container will return root string' do
        instance_enabled_with_sub_module.__name__.should be module_instance.__root_string__
      end
    end
    context 'instance of class' do
      it 'root container will return root string' do
        instance_of_class.__name__.should be module_instance.__root_string__
      end
      it 'nested instance A will return its name (:a)' do
        instance_of_class.__binding__( :a ).__container__.__name__#.should == :a
      end
    end
    context 'instance of subclass' do
      it 'root container will return root string' do
        instance_of_subclass.__name__.should be module_instance.__root_string__
      end
    end
  end

  ##############
  #  __root__  #
  ##############

  context '::__root__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__root__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ##########
  #  root  #
  ##########

  context '::root' do
    it 'is an alias for ::__root__' do
    end
  end

  context '#root' do
    it 'is an alias for #__root__' do
    end
  end

  ###############
  #  __route__  #
  ###############

  context '::__route__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__route__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ###########
  #  route  #
  ###########

  context '::route' do
    it 'is an alias for ::__route__' do
    end
  end

  context '#route' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  #########################
  #  __route_with_name__  #
  #########################

  context '::__route_with_name__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__route_with_name__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  #####################
  #  route_with_name  #
  #####################

  context '::route_with_name' do
    it 'is an alias for ::__route_with_name__' do
    end
  end

  context '#route_with_name' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ######################
  #  __nested_route__  #
  ######################

  context '::__nested_route__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__nested_route__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ##################
  #  nested_route  #
  ##################

  context '::nested_route' do
    it 'is an alias for ::__nested_route__' do
    end
  end

  context '#nested_route' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  #####################
  #  __root_string__  #
  #####################

  context '::__root_string__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__root_string__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ######################
  #  __route_string__  #
  ######################

  context '::__route_string__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__route_string__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ##################
  #  route_string  #
  ##################

  context '::route_string' do
    it 'is an alias for ::__route_string__' do
    end
  end

  context '#route_string' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ############################
  #  __route_print_string__  #
  ############################

  context '::__route_print_string__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__route_print_string__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ########################
  #  route_print_string  #
  ########################

  context '::route_print_string' do
    it 'is an alias for ::__route_print_string__' do
    end
  end

  context '#route_print_string' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ##################
  #  __bindings__  #
  ##################
  
  context '::__bindings__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__bindings__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  #################
  #  __binding__  #
  #################

  context '::__binding__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__binding__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  ######################
  #  __has_binding__?  #
  ######################

  context '::__has_binding__?' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__has_binding__?' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  it 'can return sub-bindings that define containers nested inside this binding container class' do

    Perspective::Bindings::Container::Mock.__bindings__.is_a?( ::Hash ).should == true
    Perspective::Bindings::Container::Mock.__bindings__[ :text_binding ].is_a?( ::Perspective::Bindings::BindingBase::ClassBinding ).should == true
    Perspective::Bindings::Container::Mock.text_binding.should == Perspective::Bindings::Container::Mock.__bindings__[ :text_binding ]
    Perspective::Bindings::Container::Mock.__has_binding__?( :text_binding ).should == true

    instance = ::Perspective::Bindings::Container::Mock.new    
    
    instance.__bindings__.is_a?( ::Hash ).should == true
    instance.__bindings__[ :text_binding ].__is_a__?( ::Perspective::Bindings::BindingBase::InstanceBinding ).should == true
    instance.text_binding.__id__.should == instance.__bindings__[ :text_binding ].__id__
    instance.__has_binding__?( :text_binding ).should == true

  end

  ################
  #  attr_alias  #
  ################
  
  context '::attr_alias' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#attr_alias' do
    it 'instance does not respond to #attr_alias' do
    end
  end
  
  it 'can define binding aliases' do
    
    class ::Perspective::Bindings::Container::Mock
      
      attr_binding :yet_another_binding

    end

    Proc.new { ::Perspective::Bindings::Container::Mock.attr_alias :yet_another_binding, :aliased_binding_name }.should raise_error( ::Perspective::Bindings::Exception::NoBindingError )

    class ::Perspective::Bindings::Container::OtherMock
      
      attr_binding :some_other_binding

      __has_binding__?( :some_other_binding ).should == true
      respond_to?( :some_other_binding ).should == true

      some_other_binding.is_a?( ::Perspective::Bindings::BindingBase::ClassBinding ).should == true

    end
    
    class ::Perspective::Bindings::Container::Mock

      attr_alias :aliased_binding_name, :yet_another_binding
      attr_binding :another_binding, ::Perspective::Bindings::Container::OtherMock
      attr_alias :some_other_binding, another_binding.some_other_binding

      __has_binding__?( :aliased_binding_name ).should == true
      aliased_binding_name.__required__?.should == false

      __has_binding__?( :another_binding ).should == true
      another_binding.__required__?.should == false
      respond_to?( :another_binding ).should == true
      method_defined?( :another_binding ).should == true
      
      another_binding.__has_binding__?( :some_other_binding ).should == true
      another_binding.respond_to?( :some_other_binding ).should == true
      another_binding.__bindings__[ :some_other_binding ].is_a?( ::Perspective::Bindings::BindingBase::ClassBinding ).should == true
      another_binding.some_other_binding.is_a?( ::Perspective::Bindings::BindingBase::ClassBinding ).should == true

      __has_binding__?( :some_other_binding ).should == true
      some_other_binding.__required__?.should == false
      respond_to?( :some_other_binding ).should == true
      method_defined?( :some_other_binding ).should == true

      some_other_binding.is_a?( ::Perspective::Bindings::BindingBase::ClassBinding ).should == true
      some_other_binding.should == another_binding.some_other_binding
      
    end
    
  end

  ##################
  #  __autobind__  #
  ##################

  context '::__autobind__' do
    it 'singleton does not respond to ::__autobind__' do
    end
  end

  context '#__autobind__' do
    context 'instance enabled with module' do
      it '' do
      end
    end
    context 'instance enabled with sub module' do
      it '' do
      end
    end
    context 'instance of class' do
      it '' do
      end
    end
    context 'instance of subclass' do
      it '' do
      end
    end
  end

  it 'can autobind a data object' do

    instance = ::Perspective::Bindings::Container::Mock::ContentBindingView.new    
    instance.__autobind__( :one )
    instance.content.should == :one

    instance = ::Perspective::Bindings::Container::Mock::AutobindMultibindingsView.new
    data_object = Object.new
    data_object.define_singleton_method( :binding_one ) do
      :one
    end
    data_object.define_singleton_method( :binding_two ) do
      :two
    end
    instance.__autobind__( data_object )
    instance.binding_one.should == :one
    instance.binding_two.should == :two
    
  end

  ##############
  #  autobind  #
  ##############

  context '::autobind' do
    it 'singleton does not respond to ::autobind' do
    end
  end

  context '#autobind' do
    it 'is an alias for #__autobind__' do
    end
  end

  ###################
  #  __configure__  #
  ###################

  context '::__configure__' do
    context 'module' do
      it '' do
      end
    end
    context 'sub module' do
      it '' do
      end
    end
    context 'class' do
      it '' do
      end
    end
    context 'subclass' do
      it '' do
      end
    end
  end

  context '#__configure__' do
    it 'instance does not respond to #__configure__' do
    end
  end

  ###############
  #  configure  #
  ###############

  context '::configure' do
    it 'is an alias for ::__root__' do
    end
  end

  context '#configure' do
    it 'instance does not respond to #configure' do
    end
  end

  it 'can define configuration procs to be run before rendering' do
    rspec = self
    class ::Perspective::Bindings::Container::Mock
      include ::Perspective::Bindings::Container
      configuration_proc = Proc.new do
        configuration_method
      end
      configure( & configuration_proc )
      __configuration_procs__[ 0 ].should == configuration_proc
    end
  end

end
