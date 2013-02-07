
require_relative '../../../lib/perspective/bindings.rb'

require_relative '../../support/named_class_and_module.rb'

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
    _nested_class_A = nested_class_A
    module_instance = ::Module.new do
      include ::Perspective::Bindings::Container
      attr_text :a, _nested_class_A
    end
    module_instance.name( :ModuleInstance )
    module_instance
  end
  
  let( :sub_module_instance ) do
    _module_instance = module_instance
    sub_module_instance = ::Module.new do
      include _module_instance
      attr_binding :binding_one, :binding_two
    end
    sub_module_instance.name( :SubModuleInstance )
    sub_module_instance
  end

  let( :class_instance ) do
    _sub_module_instance = sub_module_instance
    class_instance = ::Class.new do
      include _sub_module_instance
    end
    class_instance.name( :ClassInstance )
    class_instance
  end
  let( :nested_class_A ) do
    _nested_class_A_B = nested_class_A_B
    nested_class_A = ::Class.new do
      include ::Perspective::Bindings::Container
      attr_text :b, _nested_class_A_B
    end
    nested_class_A.name( :NestedClass_A )
    nested_class_A
  end
  let( :nested_class_A_B ) do
    _nested_class_A_B_C = nested_class_A_B_C
    nested_class_A_B = ::Class.new do
      include ::Perspective::Bindings::Container
      attr_text :c, _nested_class_A_B_C
    end
    nested_class_A_B.name( :NestedClass_A_B )
    nested_class_A_B
  end
  let( :nested_class_A_B_C ) do
    nested_class_A_B_C = ::Class.new { include ::Perspective::Bindings::Container }
    nested_class_A_B_C.name( :NestedClass_A_B_C )
    nested_class_A_B_C
  end
  let( :instance_of_class ) do
    object = class_instance.new
    object.name( :InstanceOfClass )
    object
  end

  let( :subclass ) do
    subclass = ::Class.new( class_instance )
    subclass.name( :SubclassInstance )
    subclass
  end
  let( :instance_of_subclass ) do
    instance_of_subclass = subclass.new
    instance_of_subclass.name( :InstanceOfSubclass )
    instance_of_subclass
  end

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
        subclass.method( :new ).owner.should be ::Perspective::Bindings::Container::ClassInstance
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
        subclass.method( :new_nested_instance ).owner.should be ::Perspective::Bindings::Container::ClassInstance
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
    shared_examples_for :__name__ do
      it 'root container will return root string' do
        instance.__name__.should be instance.__root_string__
      end
      it 'nested binding A will return its name (:a)' do
        instance.a.__name__.should == :a
      end
      it 'nested container A will return its name (:a)' do
        instance.a.__container__.__name__.should == :a
      end
      it 'nested binding A_B will return its name (:b)' do
        instance.a.b.__name__.should == :b
      end
      it 'nested container A_B will return its name (:b)' do
        instance.a.b.__container__.__name__.should == :b
      end
      it 'nested binding A_B will return its name (:b)' do
        instance.a.b.c.__name__.should == :c
      end
      it 'nested container A_B will return its name (:b)' do
        instance.a.b.c.__container__.__name__.should == :c
      end
    end
    context 'instance of class' do
      it_behaves_like( :__name__ ) { let( :instance ) { instance_of_class } }
    end
    context 'instance of subclass' do
      it_behaves_like( :__name__ ) { let( :instance ) { instance_of_subclass } }
    end
  end

  ##############
  #  __root__  #
  ##############

  context '::__root__' do
    context 'module' do
      it 'will return self' do
        module_instance.__root__.should be module_instance
      end
    end
    context 'sub module' do
      it 'will return self' do
        sub_module_instance.__root__.should be sub_module_instance
      end
    end
    context 'class' do
      it 'will return self' do
        class_instance.__root__.should be class_instance
      end
    end
    context 'subclass' do
      it 'will return self' do
        subclass.__root__.should be subclass
      end
    end
  end

  context '#__root__' do
    shared_examples_for :__root__ do
      it 'root container will return self' do
        instance.__root__.should be instance
      end
      it 'nested binding A will return root container' do
        instance.a.__root__.should be instance
      end
      it 'nested container A will return root container' do
        instance.a.__container__.__root__.should be instance
      end
      it 'nested binding A_B will return root container' do
        instance.a.b.__root__.should be instance
      end
      it 'nested container A_B will return root container' do
        instance.a.b.__container__.__root__.should be instance
      end
      it 'nested binding A_B will return root container' do
        instance.a.b.c.__root__.should be instance
      end
      it 'nested container A_B will return root container' do
        instance.a.b.c.__container__.__root__.should be instance
      end
    end
    context 'instance of class' do
      it_behaves_like( :__root__ ) { let( :instance ) { instance_of_class } }
    end
    context 'instance of subclass' do
      it_behaves_like( :__root__ ) { let( :instance ) { instance_of_subclass } }
    end
  end

  ##########
  #  root  #
  ##########

  context '::root' do
    it 'is an alias for ::__root__' do
      module_instance.method( :root ).should == module_instance.method( :__root__ )
    end
  end

  context '#root' do
    it 'is an alias for #__root__' do
      module_instance.instance_method( :root ).should == module_instance.instance_method( :__root__ )
    end
  end

  ###############
  #  __route__  #
  ###############

  context '::__route__' do
    context 'module' do
      it 'will return self' do
        module_instance.__route__.should be nil
      end
    end
    context 'sub module' do
      it 'will return self' do
        sub_module_instance.__route__.should be nil
      end
    end
    context 'class' do
      it 'will return self' do
        class_instance.__route__.should be nil
      end
    end
    context 'subclass' do
      it 'will return self' do
        subclass.__route__.should be nil
      end
    end
  end

  context '#__route__' do
    shared_examples_for :__route__ do
      it 'root container will return nil' do
        instance.__route__.should == nil
      end
      it 'nested binding A will return nil' do
        instance.a.__route__.should == nil
      end
      it 'nested container A will return nil' do
        instance.a.__container__.__route__.should == nil
      end
      it 'nested binding A_B will return :a' do
        instance.a.b.__route__.should == [ :a ]
      end
      it 'nested container A_B will return :a' do
        instance.a.b.__container__.__route__.should == [ :a ]
      end
      it 'nested binding A_B will return :a, :b' do
        instance.a.b.c.__route__.should == [ :a, :b ]
      end
      it 'nested container A_B will return :a, :b' do
        instance.a.b.c.__container__.__route__.should == [ :a, :b ]
      end
    end
    context 'instance of class' do
      it_behaves_like( :__route__ ) { let( :instance ) { instance_of_class } }
    end
    context 'instance of subclass' do
      it_behaves_like( :__route__ ) { let( :instance ) { instance_of_subclass } }
    end
  end

  ###########
  #  route  #
  ###########

  context '::route' do
    it 'is an alias for ::__route__' do
      module_instance.method( :route ).should == module_instance.method( :__route__ )
    end
  end

  context '#route' do
    it 'is an alias for #__route__' do
      module_instance.instance_method( :route ).should == module_instance.instance_method( :__route__ )
    end
  end

  #########################
  #  __route_with_name__  #
  #########################

  context '::__route_with_name__' do
    context 'module' do
      it 'will return self' do
        module_instance.__route_with_name__.should be nil
      end
    end
    context 'sub module' do
      it 'will return self' do
        sub_module_instance.__route_with_name__.should be nil
      end
    end
    context 'class' do
      it 'will return self' do
        class_instance.__route_with_name__.should be nil
      end
    end
    context 'subclass' do
      it 'will return self' do
        subclass.__route_with_name__.should be nil
      end
    end
  end

  context '#__route_with_name__' do
    shared_examples_for :__route_with_name__ do
      it 'root container will return nil' do
        instance.__route_with_name__.should == nil
      end
      it 'nested binding A will return nil' do
        instance.a.__route_with_name__.should == [ :a ]
      end
      it 'nested container A will return nil' do
        instance.a.__container__.__route_with_name__.should == [ :a ]
      end
      it 'nested binding A_B will return :a' do
        instance.a.b.__route_with_name__.should == [ :a, :b ]
      end
      it 'nested container A_B will return :a' do
        instance.a.b.__container__.__route_with_name__.should == [ :a, :b ]
      end
      it 'nested binding A_B will return :a, :b' do
        instance.a.b.c.__route_with_name__.should == [ :a, :b, :c ]
      end
      it 'nested container A_B will return :a, :b' do
        instance.a.b.c.__container__.__route_with_name__.should == [ :a, :b, :c ]
      end
    end
    context 'instance of class' do
      it_behaves_like( :__route_with_name__ ) { let( :instance ) { instance_of_class } }
    end
    context 'instance of subclass' do
      it_behaves_like( :__route_with_name__ ) { let( :instance ) { instance_of_subclass } }
    end
  end

  #####################
  #  route_with_name  #
  #####################

  context '::route_with_name' do
    it 'is an alias for ::__route_with_name__' do
      module_instance.method( :route_with_name ).should == module_instance.method( :__route_with_name__ )
    end
  end

  context '#route_with_name' do
    it 'is an alias for #__route_with_name__' do
      module_instance.instance_method( :route_with_name ).should == module_instance.instance_method( :__route_with_name__ )
    end
  end

  ######################
  #  __nested_route__  #
  ######################

  context '::__nested_route__' do
    shared_examples_for :"self.__nested_route__" do
      it 'root container does not respond to ::__nested_route__' do
        instance.respond_to?( :__nested_route__ ).should be false
      end
      it 'nested binding A will return nil' do
        instance.a.__route_with_name__.should == [ :a ]
      end
      it 'nested container A will return nil' do
        instance.a.__container__.__route_with_name__.should == [ :a ]
      end
      it 'nested binding A_B will return :a' do
        instance.a.b.__route_with_name__.should == [ :a, :b ]
      end
      it 'nested container A_B will return :a' do
        instance.a.b.__container__.__route_with_name__.should == [ :a, :b ]
      end
      it 'nested binding A_B will return :a, :b' do
        instance.a.b.c.__route_with_name__.should == [ :a, :b, :c ]
      end
      it 'nested container A_B will return :a, :b' do
        instance.a.b.c.__container__.__route_with_name__.should == [ :a, :b, :c ]
      end
    end
    context 'module' do
      it 'does not respond to ::__nested_route__' do
        module_instance.respond_to?( :__nested_route__ ).should be false
      end
    end
    context 'sub module' do
      it 'will return self' do
        sub_module_instance.respond_to?( :__nested_route__ ).should be false
      end
    end
    context 'class' do
    end
    context 'subclass' do
      it 'will return self' do
        subclass.respond_to?( :__nested_route__ ).should be false
      end
    end
  end

  context '#__nested_route__' do
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
    it 'does not respond to ::nested_route' do
      module_instance.respond_to?( :nested_route ).should be false
    end
  end

  context '#nested_route' do
    it 'is an alias for #__nested_route__' do
      module_instance.instance_method( :nested_route ).should == module_instance.instance_method( :__nested_route__ )
    end
  end

  #####################
  #  __root_string__  #
  #####################
  
  context '__root_string__' do
    
    let( :string ) { '<root:' << instance.to_s << '>' }

    context '::__root_string__' do
      context 'module' do
        let( :instance ) { module_instance }
        it 'is a formatted version of to_s' do
          module_instance.__root_string__.should == string
        end
      end
      context 'sub module' do
        let( :instance ) { sub_module_instance }
        it 'is a formatted version of to_s' do
          sub_module_instance.__root_string__.should == string
        end
      end
      context 'class' do
        let( :instance ) { class_instance }
        it 'is a formatted version of to_s' do
          class_instance.__root_string__.should == string
        end
      end
      context 'subclass' do
        let( :instance ) { subclass }
        it 'is a formatted version of to_s' do
          subclass.__root_string__.should == string
        end
      end
    end

    context '#__root_string__' do
      shared_examples_for :__root_string__ do
        it 'root container will return self as string' do
          instance.__root_string__.should == string
        end
        it 'nested binding A will instance as string' do
          instance.a.__root_string__.should == string
        end
        it 'nested container A will return instance as string' do
          instance.a.__container__.__root_string__.should == string
        end
        it 'nested binding A_B will return instance as string' do
          instance.a.b.__root_string__.should == string
        end
        it 'nested container A_B will return instance as string' do
          instance.a.b.__container__.__root_string__.should == string
        end
        it 'nested binding A_B will return instance as string' do
          instance.a.b.c.__root_string__.should == string
        end
        it 'nested container A_B will return instance as string' do
          instance.a.b.c.__container__.__root_string__.should == string
        end
      end
      context 'instance of class' do
        it_behaves_like( :__root_string__ ) { let( :instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__root_string__ ) { let( :instance ) { instance_of_subclass } }
      end
    end
  
  end
  
  ######################
  #  __route_string__  #
  ######################

  context '::__route_string__' do
    context 'module' do
      it 'root container will return nil' do
        module_instance.__route_string__.should == nil
      end
    end
    context 'sub module' do
      it 'root container will return nil' do
        sub_module_instance.__route_string__.should == nil
      end
    end
    context 'class' do
      it 'root container will return nil' do
        class_instance.__route_string__.should == nil
      end
    end
    context 'subclass' do
      it 'root container will return nil' do
        subclass.__route_string__.should == nil
      end
    end
  end

  context '#__route_string__' do
    shared_examples_for :__route_string__ do
      it 'root container will return nil' do
        instance.__route_string__.should == nil
      end
      it 'nested binding A will return nil' do
        instance.a.__route_string__.should == 'a'
      end
      it 'nested container A will return nil' do
        instance.a.__container__.__route_string__.should == 'a'
      end
      it 'nested binding A_B will return :a' do
        instance.a.b.__route_string__.should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
      end
      it 'nested container A_B will return :a' do
        instance.a.b.__container__.__route_string__.should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
      end
      it 'nested binding A_B will return :a, :b' do
        instance.a.b.c.__route_string__.should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
      end
      it 'nested container A_B will return :a, :b' do
        instance.a.b.c.__container__.__route_string__.should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
      end
    end
    context 'instance of class' do
      it_behaves_like( :__route_string__ ) { let( :instance ) { instance_of_class } }
    end
    context 'instance of subclass' do
      it_behaves_like( :__route_string__ ) { let( :instance ) { instance_of_subclass } }
    end
  end

  ##################
  #  route_string  #
  ##################

  context '::route_string' do
    it 'is an alias for ::__route_string__' do
      module_instance.method( :route_string ).should == module_instance.method( :__route_string__ )
    end
  end

  context '#route_string' do
    it 'is an alias for #__route_string__' do
      module_instance.instance_method( :route_string ).should == module_instance.instance_method( :__route_string__ )
    end
  end

  ############################
  #  __route_print_string__  #
  ############################

  context '::__route_print_string__' do
    context 'module' do
      it 'will be the root string' do
        module_instance.__route_print_string__.should ==  ::Perspective::Bindings::ContextPrintPrefix + module_instance.__root_string__
      end
    end
    context 'sub module' do
      it 'will be the root string' do
        sub_module_instance.__route_print_string__.should ==  ::Perspective::Bindings::ContextPrintPrefix + sub_module_instance.__root_string__
      end
    end
    context 'class' do
      it 'will be the root string' do
        class_instance.__route_print_string__.should ==  ::Perspective::Bindings::ContextPrintPrefix + class_instance.__root_string__
      end
    end
    context 'subclass' do
      it 'will be the root string' do
        subclass.__route_print_string__.should ==  ::Perspective::Bindings::ContextPrintPrefix + subclass.__root_string__
      end
    end
  end

  context '#__route_print_string__' do
    shared_examples_for :__route_print_string__ do
      it 'root container will return nil' do
        instance.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + instance.__root_string__
      end
      it 'nested binding A will return nil' do
        instance.a.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a'
      end
      it 'nested container A will return nil' do
        instance.a.__container__.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a'
      end
      it 'nested binding A_B will return :a' do
        instance.a.b.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
      end
      it 'nested container A_B will return :a' do
        instance.a.b.__container__.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
      end
      it 'nested binding A_B will return :a, :b' do
        instance.a.b.c.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
      end
      it 'nested container A_B will return :a, :b' do
        instance.a.b.c.__container__.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
      end
    end
    context 'instance of class' do
      it_behaves_like( :__route_print_string__ ) { let( :instance ) { instance_of_class } }
    end
    context 'instance of subclass' do
      it_behaves_like( :__route_print_string__ ) { let( :instance ) { instance_of_subclass } }
    end
  end

  ########################
  #  route_print_string  #
  ########################

  context '::route_print_string' do
    it 'is an alias for ::__route_print_string__' do
      module_instance.method( :route_print_string ).should == module_instance.method( :__route_print_string__ )
    end
  end

  context '#route_print_string' do
    it 'is an alias for #__route_print_string__' do
      module_instance.instance_method( :route_print_string ).should == module_instance.instance_method( :__route_print_string__ )
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
      module_instance.respond_to?( :__autobind__ ).should be false
    end
  end

  context '#__autobind__' do
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
      module_instance.respond_to?( :autobind ).should be false
    end
  end

  context '#autobind' do
    it 'is an alias for #__autobind__' do
      module_instance.instance_method( :autobind ).should == module_instance.instance_method( :__autobind__ )
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


  context '#__configure__' do
    it 'instance does not respond to #__configure__' do
      instance_of_class.respond_to?( :__configure__ ).should be false
    end
  end

  ###############
  #  configure  #
  ###############

  context '::configure' do
    it 'is an alias for ::__configure__' do
      module_instance.method( :configure ).should == module_instance.method( :__configure__ )
    end
  end

  context '#configure' do
    it 'instance does not respond to #configure' do
      instance_of_class.respond_to?( :configure ).should be false
    end
  end

end
