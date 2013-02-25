
require_relative '../../../../lib/perspective/bindings.rb'

require_relative '../binding_types/container_bindings/class_binding.rb'
require_relative '../binding_types/container_bindings/instance_binding.rb'

require_relative 'container_and_bindings_shared_examples.rb'

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

shared_examples_for :container_and_bindings do

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
    
      context 'instance of class' do
        it_behaves_like( :__binding__ ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__binding__ ) { let( :root_instance ) { instance_of_subclass } }
      end
    end

    ########
    #  []  #
    ########

    context '#[]' do
      context 'when symbol' do
        it 'will return binding for binding name' do
          instance_of_class[ :binding_one ].should be instance_of_class.binding_one
        end
      end
      context 'when string' do
        it 'will return binding for binding name' do
          instance_of_class[ 'binding_one' ].should be instance_of_class.binding_one
        end
      end
    end
  
    ######################
    #  __has_binding__?  #
    ######################

    context '::__has_binding__?' do

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

      context 'instance of class' do
        it_behaves_like( :__has_binding__? ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :__has_binding__? ) { let( :root_instance ) { instance_of_subclass } }
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
      context 'container' do
        before :each do
          instance_of_class.__autobind_binding__( data_binding )
        end
        it 'will look for a binding by the same name and set its value to the value of provided binding' do
          instance_of_class.content.value.should be data_binding.content.value
        end
      end
      context 'binding' do
        before :each do
          instance_of_class.content.__autobind_binding__( data_binding.content )
        end
        it 'will set its value to the value of provided binding' do
          instance_of_class.content.value.should be data_binding.content.value
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
      context 'container' do
        before :each do
          instance_of_class.__autobind_container__( data_container )
        end
        it 'will bind values from foreign container bindings to corresponding bindings' do
          instance_of_class.content.value.should == data_container.content.value
          instance_of_class.binding_one.value.should == data_container.binding_one.value
          instance_of_class.binding_two.value.should == data_container.binding_two.value
          instance_of_class.a.b.c.content.value.should == data_container.a.b.c.content.value
        end
      end
      context 'binding' do
        before :each do
          instance_of_class.a.__autobind_container__( data_container.a.__container__ )
        end
        it 'will bind values from foreign container bindings to corresponding bindings' do
          instance_of_class.a.b.c.content.value.should == data_container.a.b.c.content.value
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
      context 'container' do
        before :each do
          instance_of_class.__autobind_hash__( data_hash )
        end
        it 'will bind values from hash to corresponding bindings' do
          instance_of_class.content.value.should == data_hash[ :content ]
          instance_of_class.binding_one.value.should == data_hash[ :binding_one ]
          instance_of_class.binding_two.value.should == data_hash[ :binding_two ]
          instance_of_class.a.b.c.content.value.should == data_hash[ :a ][ :b ][ :c ]
        end
      end
      context 'binding' do
        before :each do
          instance_of_class.a.__autobind_hash__( data_hash[ :a ] )
        end
        it 'will bind values from hash to corresponding bindings' do
          instance_of_class.a.b.c.content.value.should == data_hash[ :a ][ :b ][ :c ]
        end
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
      context 'container' do
        before :each do
          instance_of_class.__autobind_object__( data_object )
        end
        it 'will bind values from object to corresponding bindings' do
          instance_of_class.content.value.should == data_object.content
          instance_of_class.binding_one.value.should == data_object.binding_one
          instance_of_class.binding_two.value.should == data_object.binding_two
          instance_of_class.a.b.c.content.value.should == data_object.a.b.c
        end
      end
      context 'binding' do
        before :each do
          instance_of_class.a.__autobind_object__( data_object.a )
        end
        it 'will bind values from object to corresponding bindings' do
          instance_of_class.a.b.c.content.value.should == data_object.a.b.c
        end
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
      context 'container#__autobind_array__' do
        it 'raises exception since Array has no clear resolution' do
          ::Proc.new { instance_of_class.__autobind_array__( multiple_data_objects ) }.should raise_error( ::ArgumentError )
        end
      end
      context 'instance_binding#__autobind_array__' do
        before :each do
          instance_of_multiple_container_class.multiple_binding.__autobind_array__( multiple_data_objects )
        end
        it 'will treat an array as a list of values to be mapped to multiple containers' do
          instance_of_multiple_container_class.multiple_binding[ 0 ].content.value.should be :c_content_value
          instance_of_multiple_container_class.multiple_binding[ 1 ].content.value.should be :c_content_value2
          instance_of_multiple_container_class.multiple_binding[ 2 ].content.value.should be :c_content_value3
        end
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
      context 'container' do
        context 'acceptable objects' do
          before( :each ) { instance.__autobind__( object ) }
          let( :instance ) { instance_of_class }
          context 'binding' do
            let( :object ) { data_binding }
            it 'will look for a binding by the same name and set its value to the value of provided binding' do
              instance.content.value.should be object.content.value
            end
          end
          context 'container' do
            let( :object ) { data_container }
            it 'will bind values from foreign container bindings to corresponding bindings' do
              instance.content.value.should == object.content.value
              instance.binding_one.value.should == object.binding_one.value
              instance.binding_two.value.should == object.binding_two.value
              instance.a.b.c.content.value.should == object.a.b.c.content.value
            end
          end
          context 'hash' do
            let( :object ) { data_hash }
            it 'will bind values from hash to corresponding bindings' do
              instance.content.value.should == object[ :content ]
              instance.binding_one.value.should == object[ :binding_one ]
              instance.binding_two.value.should == object[ :binding_two ]
              instance.a.b.c.content.value.should == object[ :a ][ :b ][ :c ]
            end
          end
          context 'object' do
            let( :object ) { data_object }
            it 'will bind values from object to corresponding bindings' do
              instance.content.value.should == object.content
              instance.binding_one.value.should == object.binding_one
              instance.binding_two.value.should == object.binding_two
              instance.a.b.c.content.value.should == object.a.b.c
            end
          end
        end
        context 'array' do
          let( :instance ) { instance_of_multiple_container_class }
          let( :object ) { multiple_data_objects }
          it 'raises exception since Array has no clear resolution' do
            ::Proc.new { instance.__autobind__( object ) }.should raise_error( ::ArgumentError )
          end
        end
      end
      context 'binding' do
        before( :each ) { instance.__autobind__( object ) }
        let( :instance ) { instance_of_class.a }
        context 'binding' do
          let( :object ) { data_binding }
          let( :instance ) { instance_of_class.content }
          it 'will set its value to the value of provided binding' do
            instance.value.should be object.content.value
          end
        end
        context 'container' do
          let( :object ) { data_container.a }
          it 'will bind values from foreign container bindings to corresponding bindings' do
            instance.b.c.content.value.should == object.b.c.content.value
          end
        end
        context 'hash' do
          let( :object ) { data_hash[ :a ] }
          it 'will bind values from hash to corresponding bindings' do
            instance.b.c.content.value.should == object[ :b ][ :c ]
          end
        end
        context 'object' do
          let( :object ) { data_object.a }
          it 'will bind values from object to corresponding bindings' do
            instance.b.c.content.value.should == object.b.c
          end
        end
        context 'array' do
          let( :instance ) { instance_of_multiple_container_class.multiple_binding }
          let( :object ) { multiple_data_objects }
          it 'will treat an array as a list of values to be mapped to multiple containers' do
            instance[ 0 ].content.value.should be object[ 0 ]
            instance[ 1 ].content.value.should be object[ 1 ]
            instance[ 2 ].content.value.should be object[ 2 ]
          end
        end
      end
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
