
require_relative '../../../lib/perspective/bindings.rb'

require_relative '../../support/named_class_and_module.rb'

require_relative 'binding_types/container_bindings/class_binding.rb'
require_relative 'binding_types/container_bindings/instance_binding.rb'

require_relative 'container_and_bindings_spec/container_and_bindings_test_setup'

describe :container_and_class_binding_and_instance_binding do
  
  ###
  # Nested Container Classes:
  #
  #   Nested Class C
  #   - :content
  #   Nested Class B
  #   - :c ( Nested Class C)
  #     - :content
  #   Nested Class A
  #   - :b ( Nested Class B)
  #     - :c ( Nested Class C)
  #       - :content
  #
  # Test Container Classes:
  #
  #   Module Instance
  #   - :a ( Nested Class A)
  #     - :b ( Nested Class B)
  #       - :c ( Nested Class C)
  #         - :content
  #   - :a_alias => :a
  #
  #   SubModule Instance
  #   - :binding_one
  #   - :binding_two
  #   - :content
  #   - :a ( Nested Class A)
  #     - :b ( Nested Class B)
  #       - :c ( Nested Class C)
  #         - :content
  #   - :a_alias => :a
  #
  #   Class Instance
  #   - :binding_one
  #   - :binding_two
  #   - :content
  #   - :a ( Nested Class A)
  #     - :b ( Nested Class B)
  #       - :c ( Nested Class C)
  #         - :content
  #   - :a_alias => :a
  #
  #   Subclass Instance
  #   - :binding_one
  #   - :binding_two
  #   - :content
  #   - :a ( Nested Class A)
  #     - :b ( Nested Class B)
  #       - :c ( Nested Class C)
  #         - :content
  #   - :a_alias => :a
  
  setup_container_and_bindings_tests  

  describe ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding do
    it_behaves_like :base_class_binding do
      let( :top_singleton_instance ) { module_instance }
      let( :sub_singleton_instance ) { sub_module_instance }
    end
    it_behaves_like :base_class_binding do
      let( :top_singleton_instance ) { class_instance }
      let( :sub_singleton_instance ) { subclass }
      let( :topclass_class_binding_parent_binding ) { sub_module_instance.a }
      let( :topclass_class_binding_configuration_procs ) { [ topclass_binding_A_action, subclass_binding_A_action ] }
      let( :subclass_class_binding_configuration_procs ) { [ topclass_binding_A_action, subclass_binding_A_action ] }
    end
    it_behaves_like :container_class_binding do
      let( :top_singleton_instance ) { module_instance }
      let( :sub_singleton_instance ) { sub_module_instance }
    end
    it_behaves_like :container_class_binding do
      let( :top_singleton_instance ) { class_instance }
      let( :sub_singleton_instance ) { subclass }
      let( :topclass_class_binding_parent_binding ) { sub_module_instance.a }
      let( :topclass_class_binding_configuration_procs ) { [ topclass_binding_A_action, subclass_binding_A_action ] }
      let( :subclass_class_binding_configuration_procs ) { [ topclass_binding_A_action, subclass_binding_A_action ] }
    end
  end

  describe ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding do

    let( :top_singleton_instance ) { class_instance }
    let( :sub_singleton_instance ) { subclass }

    let( :binding_name ) { topclass_instance_binding_A.__name__ }

    let( :topclass_bound_container_class ) { class_instance }
    let( :subclass_bound_container_class ) { subclass }

    let( :topclass_bound_container_instance ) { instance_of_class }
    let( :topclass_nested_container_instance_A ) { instance_of_class.a.__container__ }
    let( :topclass_nested_container_instance_B ) { instance_of_class.a.b.__container__ }

    let( :subclass_bound_container_instance ) { instance_of_subclass }
    let( :subclass_nested_container_instance_A ) { instance_of_subclass.a.__container__ }
    let( :subclass_nested_container_instance_B ) { instance_of_subclass.a.b.__container__ }

    let( :topclass_class_binding ) { topclass_class_binding_A }

    let( :topclass_instance_binding ) { topclass_instance_binding_A }
    let( :subclass_instance_binding ) { subclass_instance_binding_A }

    let( :topclass_instance_binding_A ) { instance_of_class.a }
    let( :topclass_instance_binding_A_B ) { instance_of_class.a.b }
    let( :topclass_instance_binding_A_B_C ) { instance_of_class.a.b.c }

    let( :subclass_instance_binding_A ) { instance_of_subclass.a }
    let( :subclass_instance_binding_A_B ) { instance_of_subclass.a.b }
    let( :subclass_instance_binding_A_B_C ) { instance_of_subclass.a.b.c }

    it_behaves_like :base_instance_binding
    it_behaves_like :container_instance_binding
    
  end

  describe ::Perspective::Bindings::Container do
  
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
      
      shared_examples_for :"self.__name__( base_module )" do
        it 'root container returns its singleton name' do
          root.__name__.should == root.name
        end
        it 'nested binding A will return its name (:a)' do
          root.a.__name__.should == :a
        end
        it 'nested binding A_B will return its name (:b)' do
          root.a.b.__name__.should == :b
        end
        it 'nested binding A_B_C will return its name (:c)' do
          root.a.b.c.__name__.should == :c
        end
        it 'nested binding A_B_C_content will return its name (:content)' do
          root.a.b.c.content.__name__.should == :content
        end
      end

      shared_examples_for :"self.__name__( sub_module_and_below )" do
        it_behaves_like( :"self.__name__( base_module )" )
        it 'nested binding content will return its name (:content)' do
          root.content.__name__.should == :content
        end
        it 'nested binding binding_one will return its name (:binding_one)' do
          root.binding_one.__name__.should == :binding_one
        end
        it 'nested binding binding_two will return its name (:binding_two)' do
          root.binding_two.__name__.should == :binding_two
        end
      end
      
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.__name__( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end

    end

    context '#__name__' do

      shared_examples_for :__name__ do
        it 'root container will return root string' do
          root_instance.__name__.should be root_instance.__root_string__
        end
        it 'nested binding binding_one will return its name (:binding_one)' do
          root_instance.binding_one.__name__.should == :binding_one
        end
        it 'nested binding binding_two will return its name (:binding_two)' do
          root_instance.binding_two.__name__.should == :binding_two
        end
        it 'nested binding A_B_C_content will return its name (:content)' do
          root_instance.content.__name__.should == :content
        end
        it 'nested binding A will return its name (:a)' do
          root_instance.a.__name__.should == :a
        end
        it 'nested container A will return its name (:a)' do
          root_instance.a.__container__.__name__.should == :a
        end
        it 'nested binding A_B will return its name (:b)' do
          root_instance.a.b.__name__.should == :b
        end
        it 'nested container A_B will return its name (:b)' do
          root_instance.a.b.__container__.__name__.should == :b
        end
        it 'nested binding A_B_C will return its name (:c)' do
          root_instance.a.b.c.__name__.should == :c
        end
        it 'nested container A_B_C will return its name (:c)' do
          root_instance.a.b.c.__container__.__name__.should == :c
        end
        it 'nested binding A_B_C_content will return its name (:c)' do
          root_instance.a.b.c.content.__name__.should == :content
        end
      end
      
      context 'instance of class' do
        it_behaves_like( :__name__ ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__name__ ) { let( :root_instance ) { instance_of_subclass } }
      end

    end

    ###################
    #  __configure__  #
    ###################

    context '::__configure__' do
      shared_examples_for :__configure__ do
        before :each do
          @configuration_proc = ::Proc.new { configuration_method }
          instance.__configure__( & @configuration_proc )
        end
        it 'will add proc to configuration procs to be run at initialization of container instance' do
          instance.__configuration_procs__.last.should be @configuration_proc
        end
      end

      shared_examples_for :"self.__configure__( base_module )" do
        it_behaves_like( :__configure__) { let( :instance ) { root } }
        it_behaves_like( :__configure__) { let( :instance ) { root.a } }
        it_behaves_like( :__configure__) { let( :instance ) { root.a.b.c } }
        it_behaves_like( :__configure__) { let( :instance ) { root.a.b.c.content } }
      end

      shared_examples_for :"self.__configure__( sub_module_and_below )" do
        it_behaves_like( :"self.__configure__( base_module )" )
        it_behaves_like( :__configure__) { let( :instance ) { root.binding_one } }
        it_behaves_like( :__configure__) { let( :instance ) { root.binding_two } }
        it_behaves_like( :__configure__) { let( :instance ) { root.content } }
      end
      
      context 'module' do
        it_behaves_like( :"self.__configure__( base_module )") { let( :root ) { module_instance } }
      end
      context 'sub module' do
        it_behaves_like( :"self.__configure__( sub_module_and_below )") { let( :root ) { sub_module_instance } }
      end
      context 'class' do
        it_behaves_like( :"self.__configure__( sub_module_and_below )") { let( :root ) { class_instance } }
      end
      context 'subclass' do
        it_behaves_like( :"self.__configure__( sub_module_and_below )") { let( :root ) { subclass } }
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

    ##############
    #  __root__  #
    ##############

    context '::__root__' do
      
      shared_examples_for :"self.__root__( base_module )" do
        it 'root container returns root' do
          root.__root__.should be root
        end
        it 'nested binding A will return root' do
          root.a.__root__.should be root
        end
        it 'nested binding A_B will return root' do
          root.a.b.__root__.should be root
        end
        it 'nested binding A_B_C will return root' do
          root.a.b.c.__root__.should be root
        end
        it 'nested binding A_B_C_content will return root' do
          root.a.b.c.content.__root__.should be root
        end
      end
      
      shared_examples_for :"self.__root__( sub_module_and_below )" do
        it_behaves_like( :"self.__root__( base_module )" )
        it 'nested binding content will return root' do
          root.content.__root__.should be root
        end
        it 'nested binding binding_one will return root' do
          root.binding_one.__root__.should be root
        end
        it 'nested binding binding_two will return root' do
          root.binding_two.__root__.should be root
        end
        it 'nested binding A_B_C_content will return root' do
          root.a.b.c.content.__root__.should be root
        end
      end
      
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.__name__( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end

    end

    context '#__root__' do
      
      shared_examples_for :__root__ do
        it 'root container will return self' do
          root_instance.__root__.should be root_instance
        end
        it 'root container will return root string' do
          root_instance.__root__.should be root_instance
        end
        it 'nested binding binding_one will return its name (:binding_one)' do
          root_instance.binding_one.__root__.should be root_instance
        end
        it 'nested binding binding_two will return its name (:binding_two)' do
          root_instance.binding_two.__root__.should be root_instance
        end
        it 'nested binding A will return root container' do
          root_instance.a.__root__.should be root_instance
        end
        it 'nested container A will return root container' do
          root_instance.a.__container__.__root__.should be root_instance
        end
        it 'nested binding A_B will return root container' do
          root_instance.a.b.__root__.should be root_instance
        end
        it 'nested container A_B will return root container' do
          root_instance.a.b.__container__.__root__.should be root_instance
        end
        it 'nested binding A_B_C will return root container' do
          root_instance.a.b.c.__root__.should be root_instance
        end
        it 'nested container A_B_C will return root container' do
          root_instance.a.b.c.__container__.__root__.should be root_instance
        end
        it 'nested binding A_B_C_content will return root container' do
          root_instance.a.b.c.content.__root__.should be root_instance
        end
      end
      
      context 'instance of class' do
        it_behaves_like( :__root__ ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__root__ ) { let( :root_instance ) { instance_of_subclass } }
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
      shared_examples_for :"self.__route__( base_module )" do
        it 'root container will return nil' do
          root.__route__.should == nil
        end
        it 'nested binding A will return nil' do
          root.a.__route__.should == nil
        end
        it 'nested binding A_B will return :a' do
          root.a.b.__route__.should == [ :a ]
        end
        it 'nested binding A_B_C will return :a, :b' do
          root.a.b.c.__route__.should == [ :a, :b ]
        end
        it 'nested binding A_B_C_content will return :a, :b, :c' do
          root.a.b.c.content.__route__.should == [ :a, :b, :c ]
        end
      end

      shared_examples_for :"self.__route__( sub_module_and_below )" do
        it_behaves_like( :"self.__route__( base_module )" )
        it 'nested binding content will return nil' do
          root.content.__route__.should == nil
        end
        it 'nested binding binding_one will return nil' do
          root.binding_one.__route__.should == nil
        end
        it 'nested binding binding_two will return nil' do
          root.binding_two.__route__.should == nil
        end
      end

      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.__name__( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
      
    end

    context '#__route__' do
      shared_examples_for :__route__ do
        it 'root container will return nil' do
          root_instance.__route__.should == nil
        end
        it 'nested binding content will return nil' do
          root_instance.content.__route__.should == nil
        end
        it 'nested binding binding_one will return nil' do
          root_instance.binding_one.__route__.should == nil
        end
        it 'nested binding binding_two will return nil' do
          root_instance.binding_two.__route__.should == nil
        end
        it 'nested binding A will return nil' do
          root_instance.a.__route__.should == nil
        end
        it 'nested container A will return nil' do
          root_instance.a.__container__.__route__.should == nil
        end
        it 'nested binding A_B will return :a' do
          root_instance.a.b.__route__.should == [ :a ]
        end
        it 'nested container A_B will return :a' do
          root_instance.a.b.__container__.__route__.should == [ :a ]
        end
        it 'nested binding A_B_C will return :a, :b' do
          root_instance.a.b.c.__route__.should == [ :a, :b ]
        end
        it 'nested container A_B_C will return :a, :b' do
          root_instance.a.b.c.__container__.__route__.should == [ :a, :b ]
        end
        it 'nested binding A_B_C_content will return :a, :b, :c' do
          root_instance.a.b.c.content.__route__.should == [ :a, :b, :c ]
        end
      end
      context 'instance of class' do
        it_behaves_like( :__route__ ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__route__ ) { let( :root_instance ) { instance_of_subclass } }
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
      shared_examples_for :"self.__route_with_name__( base_module )" do
        it 'root container will return nil' do
          root.__route_with_name__.should == nil
        end
        it 'nested binding A will return :a ' do
          root.a.__route_with_name__.should == [ :a ]
        end
        it 'nested binding A_B will return :a, :b' do
          root.a.b.__route_with_name__.should == [ :a, :b ]
        end
        it 'nested binding A_B_C will return :a, :b, :c' do
          root.a.b.c.__route_with_name__.should == [ :a, :b, :c ]
        end
        it 'nested binding A_B_C_content will return :a, :b, :c, :content' do
          root.a.b.c.content.__route_with_name__.should == [ :a, :b, :c, :content ]
        end
      end

      shared_examples_for :"self.__route_with_name__( sub_module_and_below )" do
        it_behaves_like( :"self.__route_with_name__( base_module )" )
        it 'nested binding content will return :content' do
          root.content.__route_with_name__.should == [ :content ]
        end
        it 'nested binding binding_one will return :binding_one' do
          root.binding_one.__route_with_name__.should == [ :binding_one ]
        end
        it 'nested binding binding_two will return :binding_two' do
          root.binding_two.__route_with_name__.should == [ :binding_two ]
        end
      end

      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.__name__( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.__name__( sub_module_and_below )" )
      end
    end

    context '#__route_with_name__' do
      shared_examples_for :__route_with_name__ do
        it 'root container will return nil' do
          root_instance.__route_with_name__.should == nil
        end
        it 'nested binding content will return :content' do
          root_instance.content.__route_with_name__.should == [ :content ]
        end
        it 'nested binding binding_one will return :binding_one' do
          root_instance.binding_one.__route_with_name__.should == [ :binding_one ]
        end
        it 'nested binding binding_two will return :binding_two' do
          root_instance.binding_two.__route_with_name__.should == [ :binding_two ]
        end
        it 'nested binding A will return :a ' do
          root_instance.a.__route_with_name__.should == [ :a ]
        end
        it 'nested binding A_B will return :a, :b' do
          root_instance.a.b.__route_with_name__.should == [ :a, :b ]
        end
        it 'nested binding A_B_C will return :a, :b, :c' do
          root_instance.a.b.c.__route_with_name__.should == [ :a, :b, :c ]
        end
        it 'nested binding A_B_C_content will return :a, :b, :c, :content' do
          root_instance.a.b.c.content.__route_with_name__.should == [ :a, :b, :c, :content ]
        end
      end
      context 'instance of class' do
        it_behaves_like( :__route_with_name__ ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__route_with_name__ ) { let( :root_instance ) { instance_of_subclass } }
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

    shared_examples_for :__nested_route__ do
      context 'binding is nested in queried binding' do
        it 'will return the route from queried container to parameter binding' do
          instance.a.b.c.__nested_route__( instance ).should == [ :a, :b ]
        end
      end
      context 'binding is nested in binding under queried binding' do
        it 'will return the route from queried container to parameter binding' do
          instance.a.b.c.__nested_route__( instance.a ).should == [ :b ]
        end
      end
    end

    context '::__nested_route__' do
      context 'module' do
        it_behaves_like( :__nested_route__ ) { let( :instance ) { module_instance } }
      end
      context 'sub module' do
        it_behaves_like( :__nested_route__ ) { let( :instance ) { sub_module_instance } }
      end
      context 'class' do
        it_behaves_like( :__nested_route__ ) { let( :instance ) { class_instance } }
      end
      context 'subclass' do
        it_behaves_like( :__nested_route__ ) { let( :instance ) { subclass } }
      end
    end

    context '#__nested_route__' do
      context 'instance of class' do
        it_behaves_like( :__nested_route__ ) { let( :instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__nested_route__ ) { let( :instance ) { instance_of_subclass } }
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
      shared_examples_for :"self.__route_string__( base_module )" do
        it 'root container will return nil' do
          root.__route_string__.should == nil
        end
        it 'nested binding A will return name as route' do
          root.a.__route_string__.should == 'a'
        end
        it 'nested binding A_B will return route connected by delimeter' do
          root.a.b.__route_string__.should == 'a'<< ::Perspective::Bindings::RouteDelimiter + 'b'
        end
        it 'nested binding A_B_C will return route connected by delimeter' do
          root.a.b.c.__route_string__.should == 'a'<< ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
        end
        it 'nested binding A_B_C_content will return route connected by delimeter' do
          root.a.b.c.content.__route_string__.should == 'a'<< ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c' << ::Perspective::Bindings::RouteDelimiter + 'content'
        end
      end

      shared_examples_for :"self.__route_string__( sub_module_and_below )" do
        it_behaves_like( :"self.__route_string__( base_module )" )
        it 'nested binding content will return its name' do
          root.content.__route_string__.should == 'content'
        end
        it 'nested binding binding_one will return its name' do
          root.binding_one.__route_string__.should == 'binding_one'
        end
        it 'nested binding binding_two will return its name' do
          root.binding_two.__route_string__.should == 'binding_two'
        end
      end

      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.__route_string__( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.__route_string__( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.__route_string__( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.__route_string__( sub_module_and_below )" )
      end
    end

    context '#__route_string__' do
      shared_examples_for :__route_string__ do
        it 'root container will return nil' do
          root_instance.__route_string__.should == nil
        end
        it 'nested binding content will return nil' do
          root_instance.content.__route__.should == nil
        end
        it 'nested binding binding_one will return nil' do
          root_instance.binding_one.__route__.should == nil
        end
        it 'nested binding binding_two will return nil' do
          root_instance.binding_two.__route__.should == nil
        end
        it 'nested binding A will return its name' do
          root_instance.a.__route_string__.should == 'a'
        end
        it 'nested container A will return its name' do
          root_instance.a.__container__.__route_string__.should == 'a'
        end
        it 'nested binding A_B will return route connected by delimeter' do
          root_instance.a.b.__route_string__.should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
        end
        it 'nested container A_B will return route connected by delimeter' do
          root_instance.a.b.__container__.__route_string__.should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
        end
        it 'nested binding A_B_C will return route connected by delimeter' do
          root_instance.a.b.c.__route_string__.should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
        end
        it 'nested container A_B_C will return route connected by delimeter' do
          root_instance.a.b.c.__container__.__route_string__.should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
        end
        it 'nested binding A_B_C_content will return route connected by delimeter' do
          root_instance.a.b.c.content.__route_string__.should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c' << ::Perspective::Bindings::RouteDelimiter + 'content'
        end
      end
      context 'instance of class' do
        it_behaves_like( :__route_string__ ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__route_string__ ) { let( :root_instance ) { instance_of_subclass } }
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
      shared_examples_for :"self.__route_print_string__( base_module )" do
        it 'root container will return root string' do
          root.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root.__root_string__
        end
        it 'nested binding A will return root string plus route string' do
          root.a.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root.__root_string__ + ::Perspective::Bindings::RouteDelimiter + root.a.__route_string__
        end
        it 'nested binding A_B will return root string plus route string' do
          root.a.b.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root.__root_string__ + ::Perspective::Bindings::RouteDelimiter + root.a.b.__route_string__
        end
        it 'nested binding A_B_C will return root string plus route string' do
          root.a.b.c.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root.__root_string__ + ::Perspective::Bindings::RouteDelimiter + root.a.b.c.__route_string__
        end
        it 'nested binding A_B_C_content will return root string plus route string' do
          root.a.b.c.content.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root.__root_string__ + ::Perspective::Bindings::RouteDelimiter + root.a.b.c.content.__route_string__
        end
      end

      shared_examples_for :"self.__route_print_string__( sub_module_and_below )" do
        it_behaves_like( :"self.__route_print_string__( base_module )" )
        it 'nested binding content will return root string plus route string' do
          root.content.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root.__root_string__ + ::Perspective::Bindings::RouteDelimiter + root.content.__route_string__
        end
        it 'nested binding binding_one will return root string plus route string' do
          root.binding_one.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root.__root_string__ + ::Perspective::Bindings::RouteDelimiter + root.binding_one.__route_string__
        end
        it 'nested binding binding_two will return root string plus route string' do
          root.binding_two.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root.__root_string__ + ::Perspective::Bindings::RouteDelimiter + root.binding_two.__route_string__
        end
      end

      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.__route_print_string__( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.__route_print_string__( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.__route_print_string__( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.__route_print_string__( sub_module_and_below )" )
      end

    end

    context '#__route_print_string__' do
      shared_examples_for :__route_print_string__ do
        it 'root container will return root string' do
          root_instance.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__
        end
        it 'nested binding binding_one will return root string' do
          root_instance.binding_one.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'binding_one'
        end
        it 'nested binding binding_two will return root string' do
          root_instance.binding_two.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'binding_two'
        end
        it 'nested binding content will return root string' do
          root_instance.content.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'content'
        end
        it 'nested container A will return root string plus route string' do
          root_instance.a.__container__.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a'
        end
        it 'nested binding A_B will return root string plus route string' do
          root_instance.a.b.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
        end
        it 'nested container A_B will return root string plus route string' do
          root_instance.a.b.__container__.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
        end
        it 'nested binding A_B_C will return root string plus route string' do
          root_instance.a.b.c.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
        end
        it 'nested container A_B_C will return root string plus route string' do
          root_instance.a.b.c.__container__.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
        end
        it 'nested binding A_B_C_content will return root string plus route string' do
          root_instance.a.b.c.content.__route_print_string__.should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.__root_string__ << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c' << ::Perspective::Bindings::RouteDelimiter + 'content'
        end
      end
      context 'instance of class' do
        it_behaves_like( :__route_print_string__ ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__route_print_string__ ) { let( :root_instance ) { instance_of_subclass } }
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

    ################
    #  attr_alias  #
    ################
  
    context '::attr_alias' do
      context 'module' do
        it 'will create a method that returns the aliased binding' do
          module_instance.a_alias.should be module_instance.a
        end
        it 'sub-module will inherit' do
          sub_module_instance.a_alias.should be sub_module_instance.a
        end
        it 'class will inherit' do
          class_instance.a_alias.should be class_instance.a
        end
        it 'subclass will inherit' do
          subclass.a_alias.should be subclass.a
        end
      end
      context 'sub module' do
        it 'will create a method that returns the aliased binding' do
          sub_module_instance.a_alias.should be sub_module_instance.a
        end
        it 'class will inherit' do
          class_instance.a_alias.should be class_instance.a
        end
        it 'subclass will inherit' do
          subclass.a_alias.should be subclass.a
        end
      end
      context 'class' do
        it 'will create a method that returns the aliased binding' do
          class_instance.a_alias.should be class_instance.a
        end
        it 'subclass will inherit' do
          subclass.a_alias.should be subclass.a
        end
      end
      context 'subclass' do
        it 'will create a method that returns the aliased binding' do
          subclass.a_alias.should be subclass.a
        end
      end
    end

    context '#attr_alias' do
      it 'instance does not respond to #attr_alias' do
        ::Perspective::Bindings::Container.method_defined?( :attr_alias ).should be false
      end
    end
  
    ##################
    #  __bindings__  #
    ##################
  
    context '::__bindings__' do
      shared_examples_for :"self.__bindings__( base_module )" do
        it 'nested binding A bindings' do
          root.a.__bindings__.should == { :b => root.a.b }
          root.a.__bindings__[ :b ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding A_B bindings' do
          root.a.b.__bindings__.should == { :c => root.a.b.c }
          root.a.b.__bindings__[ :c ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding A_B_C bindings' do
          root.a.b.c.__bindings__.should == { :content => root.a.b.c.content }
          root.a.b.c.__bindings__[ :content ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding A_B_C_content bindings' do
          root.a.b.c.content.__bindings__.should == { }
        end
      end

      shared_examples_for :"self.__bindings__( sub_module_and_below )" do
        it_behaves_like( :"self.__bindings__( base_module )" )
        it 'root container bindings' do
          root.__bindings__.should == { :a => root.a,
                                        :content => root.content,
                                        :binding_one => root.binding_one,
                                        :binding_two => root.binding_two }
          root.__bindings__[ :a ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
          root.__bindings__[ :content ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
          root.__bindings__[ :binding_one ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
          root.__bindings__[ :binding_two ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding content bindings' do
          root.content.__bindings__.should == { }
        end
        it 'nested binding binding_one bindings' do
          root.binding_one.__bindings__.should == { }
        end
        it 'nested binding binding_two bindings' do
          root.binding_two.__bindings__.should == { }
        end
      end

      context 'module' do
        let( :root ) { module_instance }
        it 'root container bindings' do
          root.__bindings__.should == { :a => root.a }
          root.__bindings__[ :a ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it_behaves_like( :"self.__bindings__( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.__bindings__( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.__bindings__( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.__bindings__( sub_module_and_below )" )
      end

    end

    context '#__bindings__' do
      shared_examples_for :__bindings__ do
        it 'root container bindings' do
          root_instance.__bindings__.should == { :a => root_instance.a,
                                                 :content => root_instance.content,
                                                 :binding_one => root_instance.binding_one,
                                                 :binding_two => root_instance.binding_two }
          root_instance.__bindings__[ :a ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
          root_instance.__bindings__[ :content ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
          root_instance.__bindings__[ :binding_one ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
          root_instance.__bindings__[ :binding_two ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
        it 'nested binding content bindings' do
          root_instance.content.__bindings__.should == { }
        end
        it 'nested binding binding_one bindings' do
          root_instance.binding_one.__bindings__.should == { }
        end
        it 'nested binding binding_two bindings' do
          root_instance.binding_two.__bindings__.should == { }
        end
        it 'nested binding A bindings' do
          root_instance.a.__bindings__.should == { :b => root_instance.a.b }
          root_instance.a.__bindings__[ :b ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
        it 'nested binding A_B bindings' do
          root_instance.a.b.__bindings__.should == { :c => root_instance.a.b.c }
          root_instance.a.b.__bindings__[ :c ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
        it 'nested binding A_B_C bindings' do
          root_instance.a.b.c.__bindings__.should == { :content => root_instance.a.b.c.content }
          root_instance.a.b.c.__bindings__[ :content ].should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
        it 'nested binding A_B_C_content bindings' do
          root_instance.a.b.c.content.__bindings__.should == { }
        end
      end

      context 'instance of class' do
        it_behaves_like( :__bindings__ ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__bindings__ ) { let( :root_instance ) { instance_of_subclass } }
      end
    end

    #################
    #  __binding__  #
    #################

    context '::__binding__' do

      shared_examples_for :"self.__binding__( base_module )" do
        it 'nested binding A' do
          root.__binding__( :a ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding A alias' do
          root.__binding__( :a_alias ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding A_B' do
          root.a.__binding__( :b ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding A_B_C' do
          root.a.b.__binding__( :c ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding A_B_C_content' do
          root.a.b.c.__binding__( :content ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
      end
 
      shared_examples_for :"self.__binding__( sub_module_and_below )" do
        it_behaves_like( :"self.__binding__( base_module )" )
        it 'nested binding content will return nil' do
          root.__binding__( :content ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding binding_one will return nil' do
          root.__binding__( :binding_one ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
        it 'nested binding binding_two will return nil' do
          root.__binding__( :binding_two ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::ClassBinding
        end
      end

      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.__binding__( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.__binding__( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.__binding__( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.__binding__( sub_module_and_below )" )
      end

    end

    context '#__binding__' do
      
      shared_examples_for :__binding__ do
        it 'nested binding A' do
          root_instance.__binding__( :a ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
        it 'nested binding A_B' do
          root_instance.a.__binding__( :b ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
        it 'nested binding A_B_C' do
          root_instance.a.b.__binding__( :c ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
        it 'nested binding A_B_C_content' do
          root_instance.a.b.c.__binding__( :content ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end

        it 'nested binding content will return nil' do
          root_instance.__binding__( :content ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
        it 'nested binding binding_one will return nil' do
          root_instance.__binding__( :binding_one ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
        it 'nested binding binding_two will return nil' do
          root_instance.__binding__( :binding_two ).should be_a ::Perspective::Bindings::BindingTypes::ContainerBindings::InstanceBinding
        end
      end

      context 'instance of class' do
        it_behaves_like( :__binding__ ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__binding__ ) { let( :root_instance ) { instance_of_subclass } }
      end
    end

    ######################
    #  __has_binding__?  #
    ######################

    context '::__has_binding__?' do

      shared_examples_for :"self.__has_binding__?( base_module )" do
        it 'nested binding A' do
          root.__has_binding__?( :a ).should be true
        end
        it 'nested binding A alias' do
          root.__has_binding__?( :a_alias ).should be true
        end
        it 'nested binding A_B' do
          root.a.__has_binding__?( :b ).should be true
        end
        it 'nested binding A_B_C' do
          root.a.b.__has_binding__?( :c ).should be true
        end
        it 'nested binding A_B_C_content' do
          root.a.b.c.__has_binding__?( :content ).should be true
        end
        it 'binding that does not exist' do
          root.__has_binding__?( :non_existent_binding ).should be false
        end
      end
 
      shared_examples_for :"self.__has_binding__?( sub_module_and_below )" do
        it_behaves_like( :"self.__has_binding__?( base_module )" )
        it 'nested binding content' do
          root.__has_binding__?( :content ).should be true
        end
        it 'nested binding binding_one' do
          root.__has_binding__?( :binding_one ).should be true
        end
        it 'nested binding binding_two' do
          root.__has_binding__?( :binding_two ).should be true
        end
      end

      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.__binding__( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.__binding__( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.__binding__( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.__binding__( sub_module_and_below )" )
      end

    end

    context '#__has_binding__?' do

      shared_examples_for :__has_binding__? do
        it 'nested binding A' do
          root_instance.__has_binding__?( :a ).should be true
        end
        it 'nested binding content' do
          root_instance.__has_binding__?( :content ).should be true
        end
        it 'nested binding binding_one' do
          root_instance.__has_binding__?( :binding_one ).should be true
        end
        it 'nested binding binding_two' do
          root_instance.__has_binding__?( :binding_two ).should be true
        end
        it 'nested binding A alias' do
          root_instance.__has_binding__?( :a_alias ).should be true
        end
        it 'nested binding A_B' do
          root_instance.a.__has_binding__?( :b ).should be true
        end
        it 'nested binding A_B_C' do
          root_instance.a.b.__has_binding__?( :c ).should be true
        end
        it 'nested binding A_B_C_content' do
          root_instance.a.b.c.__has_binding__?( :content ).should be true
        end
        it 'binding that does not exist' do
          root_instance.__has_binding__?( :non_existent_binding ).should be false
        end
      end

      context 'instance of class' do
        it_behaves_like( :__has_binding__? ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__has_binding__? ) { let( :root_instance ) { instance_of_subclass } }
      end

    end

    #########################
    #  __autobind_object__  #
    #########################

    context '::__autobind_object__' do
      it 'singleton does not respond to ::__autobind_object__' do
        module_instance.respond_to?( :__autobind_object__ ).should be false
      end
    end

    context '#__autobind_object__' do
      shared_examples_for :__autobind_object__ do
        let( :data_object ) do
          object = ::Object.new
          object.define_singleton_method( :content ) { :content_value }
          object
        end
        it 'will query object for binding value for each binding whose name object responds to' do
          instance_of_class.a.b.c.__container__.__autobind_object__( data_object )
          instance_of_class.a.b.c.__container__.content.should == :content_value
        end
      end
      context 'container#__autobind_object__' do
        it_behaves_like :__autobind_object__
      end
      context 'instance_binding#__autobind_object__' do
        it_behaves_like :__autobind_object__
      end
    end
  
    ########################
    #  __autobind_array__  #
    ########################

    context '::__autobind_array__' do
      it 'singleton does not respond to ::__autobind_array__' do
        module_instance.respond_to?( :__autobind_array__ ).should be false
      end
    end

    context '#__autobind_array__' do
      shared_examples_for :__autobind_array__ do
        it 'will treat an array as a list of values to be mapped to multiple containers' do
        end
      end
    end

    #######################
    #  __autobind_hash__  #
    #######################

    context '::__autobind_hash__' do
      it 'singleton does not respond to ::__autobind_hash__' do
        module_instance.respond_to?( :__autobind_hash__ ).should be false
      end
    end
  
    context '#__autobind_hash__' do
      shared_examples_for :__autobind_hash__ do
        it 'will treat a hash as a mapped set of binding names to corresponding values' do
        end
      end
    end

    ############################
    #  __autobind_container__  #
    ############################

    context '::__autobind_container__' do
      it 'singleton does not respond to ::__autobind_container__' do
        module_instance.respond_to?( :__autobind_container__ ).should be false
      end
    end

    context '#__autobind_container__' do
      it 'will bind values from foreign container bindings to corresponding bindings' do
      end
    end

    ##########################
    #  __autobind_binding__  #
    ##########################

    context '::__autobind_binding__' do
      it 'singleton does not respond to ::__autobind_binding__' do
        module_instance.respond_to?( :__autobind_binding__ ).should be false
      end
    end

    context '#__autobind_binding__' do
      it 'will bind value to corresponding to binding' do
      end
    end

    #########################
    #  __autobind_object__  #
    #########################

    context '::__autobind_object__' do
      it 'singleton does not respond to ::__autobind_object__' do
        module_instance.respond_to?( :__autobind_object__ ).should be false
      end
    end

    context '#__autobind_object__' do
      let( :data_object ) do
        object = ::Object.new
        object.define_singleton_method( :binding_one ) { :binding_one_value }
        object.define_singleton_method( :binding_two ) { :binding_two_value }
        object.define_singleton_method( :content ) { :content_value }
        object.define_singleton_method( :a ) { b }
        object.define_singleton_method( :b ) { c }
        object.define_singleton_method( :c ) { content }
        object.define_singleton_method( :content ) { :a_content_value }
        object
      end
      it 'will bind values from methods with names corresponding to binding names' do
      end
    end

    #######################
    #  __autobind_hash__  #
    #######################

    context '::__autobind_hash__' do
      it 'singleton does not respond to ::__autobind_hash__' do
        module_instance.respond_to?( :__autobind_hash__ ).should be false
      end
    end

    context '#__autobind_hash__' do
      let( :data_object ) { { :binding_one => :binding_one_value,
                              :binding_two => :binding_two_value,
                              :content => :content_value,
                              :a => { :b => { :c => :c_content_value } } } }
      before :each do
        instance_of_class.__autobind__( data_object )
      end
      it 'will bind values from keys with names corresponding to binding names' do
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

  end

end
