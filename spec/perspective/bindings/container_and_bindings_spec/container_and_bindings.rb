# -*- encoding : utf-8 -*-

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

  describe ::Perspective::BindingTypes::ContainerBindings::ClassBinding do
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
  
  describe ::Perspective::BindingTypes::ContainerBindings::InstanceBinding do
  
    let( :top_singleton_instance ) { class_instance }
    let( :sub_singleton_instance ) { subclass }
  
    let( :binding_name ) { topclass_instance_binding_A.«name» }
  
    let( :topclass_bound_container_class ) { class_instance }
    let( :subclass_bound_container_class ) { subclass }
  
    let( :topclass_bound_container_instance ) { instance_of_class }
    let( :topclass_nested_container_instance_A ) { instance_of_class.•a.«container» }
    let( :topclass_nested_container_instance_B ) { instance_of_class.a.•b.«container» }
  
    let( :subclass_bound_container_instance ) { instance_of_subclass }
    let( :subclass_nested_container_instance_A ) { instance_of_subclass.•a.«container» }
    let( :subclass_nested_container_instance_B ) { instance_of_subclass.a.•b.«container» }
  
    let( :topclass_class_binding ) { topclass_class_binding_A }
  
    let( :topclass_instance_binding ) { topclass_instance_binding_A }
    let( :subclass_instance_binding ) { subclass_instance_binding_A }
  
    let( :topclass_instance_binding_A ) { instance_of_class.a }
    let( :topclass_instance_binding_A_B ) { instance_of_class.a.b }
    let( :topclass_instance_binding_A_B_C ) { instance_of_class.a.b.•c }
  
    let( :subclass_instance_binding_A ) { instance_of_subclass.a }
    let( :subclass_instance_binding_A_B ) { instance_of_subclass.a.b }
    let( :subclass_instance_binding_A_B_C ) { instance_of_subclass.a.b.•c }
  
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
        it 'is owned by Perspective::Bindings::Container::SingletonInstance' do
          class_instance.method( :new ).owner.should be ::Perspective::Bindings::Container::ClassInstance
        end
      end
      context 'subclass instance' do
        it 'is owned by Perspective::Bindings::Container::SingletonInstance' do
          subclass.method( :new ).owner.should be ::Perspective::Bindings::Container::ClassInstance
        end
      end
    end
    
    #########################
    #  new«nested_instance»  #
    #########################
    
    context '::new«nested_instance»' do
      context 'module' do
        it 'does not respond to ::new«nested_instance»' do
          module_instance.respond_to?( :new«nested_instance» ).should be false
        end
      end
      context 'sub module' do
        it 'does not respond to ::new«nested_instance»' do
          sub_module_instance.respond_to?( :new«nested_instance» ).should be false
        end
      end
      context 'class' do
        it 'is owned by Perspective::Bindings::Container::SingletonInstance' do
          class_instance.method( :new«nested_instance» ).owner.should be ::Perspective::Bindings::Container::ClassInstance
        end
      end
      context 'subclass' do
        it 'is owned by Perspective::Bindings::Container::SingletonInstance' do
          subclass.method( :new«nested_instance» ).owner.should be ::Perspective::Bindings::Container::ClassInstance
        end
      end
    end
    
    ############
    #  «name»  #
    ############
    
    context '::«name»' do
    
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.«name»( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
    
    end
    
    context '#«name»' do
    
      context 'instance of class' do
        it_behaves_like( :«name» ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :«name» ) { let( :root_instance ) { instance_of_subclass } }
      end
    
    end
    
    #################
    #  «configure»  #
    #################
    
    context '::«configure»' do
    
      context 'module' do
        it_behaves_like( :"self.«configure»( base_module )") { let( :root ) { module_instance } }
      end
      context 'sub module' do
        it_behaves_like( :"self.«configure»( sub_module_and_below )") { let( :root ) { sub_module_instance } }
      end
      context 'class' do
        it_behaves_like( :"self.«configure»( sub_module_and_below )") { let( :root ) { class_instance } }
      end
      context 'subclass' do
        it_behaves_like( :"self.«configure»( sub_module_and_below )") { let( :root ) { subclass } }
      end
    end
    
    context '#«configure»' do
      it 'instance does not respond to #«configure»' do
        instance_of_class.respond_to?( :«configure» ).should be false
      end
    end
    
    ###############
    #  configure  #
    ###############
    
    context '::configure' do
      it 'is an alias for ::«configure»' do
        module_instance.method( :configure ).should == module_instance.method( :«configure» )
      end
    end
    
    context '#configure' do
      it 'instance does not respond to #configure' do
        instance_of_class.respond_to?( :configure ).should be false
      end
    end
    
    ############
    #  «root»  #
    ############
    
    context '::«root»' do
          
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.«name»( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
    
    end
    
    context '#«root»' do
    
      context 'instance of class' do
        it_behaves_like( :«root» ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :«root» ) { let( :root_instance ) { instance_of_subclass } }
      end
    
    end
    
    ##########
    #  root  #
    ##########
    
    context '::root' do
      it 'is an alias for ::«root»' do
        module_instance.method( :root ).should == module_instance.method( :«root» )
      end
    end
    
    context '#root' do
      it 'is an alias for #«root»' do
        module_instance.instance_method( :root ).should == module_instance.instance_method( :«root» )
      end
    end
    
    #############
    #  «route»  #
    #############
    
    context '::«route»' do
    
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.«name»( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
    
    end
    
    context '#«route»' do
      context 'instance of class' do
        it_behaves_like( :«route» ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :«route» ) { let( :root_instance ) { instance_of_subclass } }
      end
    end
    
    ###########
    #  route  #
    ###########
    
    context '::route' do
      it 'is an alias for ::«route»' do
        module_instance.method( :route ).should == module_instance.method( :«route» )
      end
    end
    
    context '#route' do
      it 'is an alias for #«route»' do
        module_instance.instance_method( :route ).should == module_instance.instance_method( :«route» )
      end
    end
    
    #######################
    #  «route_with_name»  #
    #######################
    
    context '::«route_with_name»' do
    
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.«name»( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.«name»( sub_module_and_below )" )
      end
    end
    
    context '#«route_with_name»' do
      context 'instance of class' do
        it_behaves_like( :«route_with_name» ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :«route_with_name» ) { let( :root_instance ) { instance_of_subclass } }
      end
    end
    
    #####################
    #  route_with_name  #
    #####################
    
    context '::route_with_name' do
      it 'is an alias for ::«route_with_name»' do
        module_instance.method( :route_with_name ).should == module_instance.method( :«route_with_name» )
      end
    end
    
    context '#route_with_name' do
      it 'is an alias for #«route_with_name»' do
        module_instance.instance_method( :route_with_name ).should == module_instance.instance_method( :«route_with_name» )
      end
    end
    
    ####################
    #  «nested_route»  #
    ####################
    
    context '::«nested_route»' do
      context 'module' do
        it_behaves_like( :«nested_route» ) { let( :instance ) { module_instance } }
      end
      context 'sub module' do
        it_behaves_like( :«nested_route» ) { let( :instance ) { sub_module_instance } }
      end
      context 'class' do
        it_behaves_like( :«nested_route» ) { let( :instance ) { class_instance } }
      end
      context 'subclass' do
        it_behaves_like( :«nested_route» ) { let( :instance ) { subclass } }
      end
    end
    
    context '#«nested_route»' do
      context 'instance of class' do
        it_behaves_like( :«nested_route» ) { let( :instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :«nested_route» ) { let( :instance ) { instance_of_subclass } }
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
      it 'is an alias for #«nested_route»' do
        module_instance.instance_method( :nested_route ).should == module_instance.instance_method( :«nested_route» )
      end
    end
    
    ###################
    #  «root_string»  #
    ###################
    
    context '«root_string»' do
    
      let( :string ) { '<root:' << instance.to_s << '>' }
    
      context '::«root_string»' do
        context 'module' do
          let( :instance ) { module_instance }
          it 'is a formatted version of to_s' do
            module_instance.«root_string».should == string
          end
        end
        context 'sub module' do
          let( :instance ) { sub_module_instance }
          it 'is a formatted version of to_s' do
            sub_module_instance.«root_string».should == string
          end
        end
        context 'class' do
          let( :instance ) { class_instance }
          it 'is a formatted version of to_s' do
            class_instance.«root_string».should == string
          end
        end
        context 'subclass' do
          let( :instance ) { subclass }
          it 'is a formatted version of to_s' do
            subclass.«root_string».should == string
          end
        end
      end
    
      context '#«root_string»' do
        context 'instance of class' do
          it_behaves_like( :«root_string» ) { let( :instance ) { instance_of_class } }
        end
        context 'instance of subclass' do
          it_behaves_like( :«root_string» ) { let( :instance ) { instance_of_subclass } }
        end
      end
    
    end
    
    ####################
    #  «route_string»  #
    ####################
    
    context '::«route_string»' do
    
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.«route_string»( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.«route_string»( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.«route_string»( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.«route_string»( sub_module_and_below )" )
      end
    end
    
    context '#«route_string»' do
      context 'instance of class' do
        it_behaves_like( :«route_string» ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :«route_string» ) { let( :root_instance ) { instance_of_subclass } }
      end
    end
    
    ##################
    #  route_string  #
    ##################
    
    context '::route_string' do
      it 'is an alias for ::«route_string»' do
        module_instance.method( :route_string ).should == module_instance.method( :«route_string» )
      end
    end
    
    context '#route_string' do
      it 'is an alias for #«route_string»' do
        module_instance.instance_method( :route_string ).should == module_instance.instance_method( :«route_string» )
      end
    end
    
    ##########################
    #  «route_print_string»  #
    ##########################
    
    context '::«route_print_string»' do
    
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.«route_print_string»( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.«route_print_string»( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.«route_print_string»( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.«route_print_string»( sub_module_and_below )" )
      end
    
    end
    
    context '#«route_print_string»' do
      context 'instance of class' do
        it_behaves_like( :«route_print_string» ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :«route_print_string» ) { let( :root_instance ) { instance_of_subclass } }
      end
    end
    
    ########################
    #  route_print_string  #
    ########################
    
    context '::route_print_string' do
      it 'is an alias for ::«route_print_string»' do
        module_instance.method( :route_print_string ).should == module_instance.method( :«route_print_string» )
      end
    end
    
    context '#route_print_string' do
      it 'is an alias for #«route_print_string»' do
        module_instance.instance_method( :route_print_string ).should == module_instance.instance_method( :«route_print_string» )
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
    
    ################
    #  «bindings»  #
    ################
    
    context '::«bindings»' do
      context 'module' do
        let( :root ) { module_instance }
        it 'root container bindings' do
          root.«bindings».should == { :a => root.a }
          root.«bindings»[ :a ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
        end
        it_behaves_like( :"self.«bindings»( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.«bindings»( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.«bindings»( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.«bindings»( sub_module_and_below )" )
      end
    
    end
    
    context '#«bindings»' do
      context 'instance of class' do
        it_behaves_like( :«bindings» ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :«bindings» ) { let( :root_instance ) { instance_of_subclass } }
      end
    end
    
    ###############
    #  «binding»  #
    ###############
    
    context '::«binding»' do
    
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.«binding»( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.«binding»( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.«binding»( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.«binding»( sub_module_and_below )" )
      end
    
    end
    
    context '#«binding»' do
    
      context 'instance of class' do
        it_behaves_like( :«binding» ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :«binding» ) { let( :root_instance ) { instance_of_subclass } }
      end
    end
    
    ########
    #  []  #
    ########
    
    context '#[]' do
      context 'when symbol' do
        it 'will return binding for binding name' do
          instance_of_class[ :binding_one ].should be instance_of_class.•binding_one
        end
      end
      context 'when string' do
        it 'will return binding for binding name' do
          instance_of_class[ 'binding_one' ].should be instance_of_class.•binding_one
        end
      end
    end
    
    ##################
    #  has_binding?  #
    ##################
    
    context '::has_binding?' do
    
      context 'module' do
        let( :root ) { module_instance }
        it_behaves_like( :"self.«binding»( base_module )" )
      end
      context 'sub module' do
        let( :root ) { sub_module_instance }
        it_behaves_like( :"self.«binding»( sub_module_and_below )" )
      end
      context 'class' do
        let( :root ) { class_instance }
        it_behaves_like( :"self.«binding»( sub_module_and_below )" )
      end
      context 'subclass' do
        let( :root ) { subclass }
        it_behaves_like( :"self.«binding»( sub_module_and_below )" )
      end
    
    end
    
    context '#has_binding?' do
    
      context 'instance of class' do
        it_behaves_like( :has_binding? ) { let( :root_instance ) { instance_of_class } }
      end
      context 'instance of subclass' do
        it_behaves_like( :has_binding? ) { let( :root_instance ) { instance_of_subclass } }
      end
    
    end
    
    ########################
    #  «autobind_binding»  #
    ########################
    
    context '::«autobind_binding»' do
      it 'singleton does not respond to ::«autobind_binding»' do
        module_instance.respond_to?( :«autobind_binding» ).should be false
      end
    end
  
    context '#«autobind_binding»' do
      context 'container' do
        before :each do
          instance_of_class.«autobind_binding»( data_binding )
        end
        it 'will look for a binding by the same name and set its value to the value of provided binding' do
          instance_of_class.content.should be data_binding.content
        end
      end
      context 'binding' do
        before :each do
          instance_of_class.•content.«autobind_binding»( data_binding.•content )
        end
        it 'will set its value to the value of provided binding' do
          instance_of_class.content.should be data_binding.content
        end
      end
    end
    
    ##########################
    #  «autobind_container»  #
    ##########################
    
    context '::«autobind_container»' do
      it 'singleton does not respond to ::«autobind_container»' do
        module_instance.respond_to?( :«autobind_container» ).should be false
      end
    end
    
    context '#«autobind_container»' do
      context 'container' do
        before :each do
          instance_of_class.«autobind_container»( data_container )
        end
        it 'will bind values from foreign container bindings to corresponding bindings' do
          instance_of_class.content.should == data_container.content
          instance_of_class.binding_one.should == data_container.binding_one
          instance_of_class.binding_two.should == data_container.binding_two
          instance_of_class.a.b.c.should == data_container.a.b.c
        end
      end
      context 'binding' do
        before :each do
          instance_of_class.•a.«autobind_container»( data_container.•a.«container» )
        end
        it 'will bind values from foreign container bindings to corresponding bindings' do
          instance_of_class.a.b.c.should == data_container.a.b.c
        end
      end
    end
  
    #####################
    #  «autobind_hash»  #
    #####################
  
    context '::«autobind_hash»' do
      it 'singleton does not respond to ::«autobind_hash»' do
        module_instance.respond_to?( :«autobind_hash» ).should be false
      end
    end
  
    context '#«autobind_hash»' do
      context 'container' do
        before :each do
          instance_of_class.«autobind_hash»( data_hash )
        end
        it 'will bind values from hash to corresponding bindings' do
          instance_of_class.content.should == data_hash[ :content ]
          instance_of_class.binding_one.should == data_hash[ :binding_one ]
          instance_of_class.binding_two.should == data_hash[ :binding_two ]
          instance_of_class.a.b.c.should == data_hash[ :a ][ :b ][ :c ]
        end
      end
      context 'binding' do
        before :each do
          instance_of_class.•a.«autobind_hash»( data_hash[ :a ] )
        end
        it 'will bind values from hash to corresponding bindings' do
          instance_of_class.a.b.c.should == data_hash[ :a ][ :b ][ :c ]
        end
      end
    end
  
    #######################
    #  «autobind_object»  #
    #######################
  
    context '::«autobind_object»' do
      it 'singleton does not respond to ::«autobind_object»' do
        module_instance.respond_to?( :«autobind_object» ).should be false
      end
    end
  
    context '#«autobind_object»' do
      context 'container' do
        before :each do
          instance_of_class.«autobind_object»( data_object )
        end
        it 'will bind values from object to corresponding bindings' do
          instance_of_class.content.should == data_object.content
          instance_of_class.binding_one.should == data_object.binding_one
          instance_of_class.binding_two.should == data_object.binding_two
          instance_of_class.a.b.c.should == data_object.a.b.c
        end
      end
      context 'binding' do
        before :each do
          instance_of_class.•a.«autobind_object»( data_object.a )
        end
        it 'will bind values from object to corresponding bindings' do
          instance_of_class.a.b.c.should == data_object.a.b.c
        end
      end
    end
  
    ######################
    #  «autobind_array»  #
    ######################
  
    context '::«autobind_array»' do
      it 'singleton does not respond to ::«autobind_array»' do
        module_instance.respond_to?( :«autobind_array» ).should be false
      end
    end
  
    context '#«autobind_array»' do
      context 'container#«autobind_array»' do
        it 'raises exception since Array has no clear resolution' do
          ::Proc.new { instance_of_class.«autobind_array»( multiple_data_objects ) }.should raise_error( ::ArgumentError )
        end
      end
      context 'instance_binding#«autobind_array»' do
        before :each do
          instance_of_multiple_container_class.multiple_binding.«autobind_array»( multiple_data_objects )
        end
        it 'will treat an array as a list of values to be mapped to multiple containers' do
          instance_of_multiple_container_class.multiple_binding[ 0 ].should be :c_content_value
          instance_of_multiple_container_class.multiple_binding[ 1 ].should be :c_content_value2
          instance_of_multiple_container_class.multiple_binding[ 2 ].should be :c_content_value3
        end
      end
    end
  
    ################
    #  «autobind»  #
    ################
  
    context '::«autobind»' do
      it 'singleton does not respond to ::«autobind»' do
        module_instance.respond_to?( :«autobind» ).should be false
      end
    end
  
    context '#«autobind»' do
      context 'container' do
        context 'acceptable objects' do
          before( :each ) { instance.«autobind»( object ) }
          let( :instance ) { instance_of_class }
          context 'binding' do
            let( :object ) { data_binding }
            it 'will look for a binding by the same name and set its value to the value of provided binding' do
              instance.content.should be object.content
            end
          end
          context 'container' do
            let( :object ) { data_container }
            it 'will bind values from foreign container bindings to corresponding bindings' do
              instance.content.should == object.content
              instance.binding_one.should == object.binding_one
              instance.binding_two.should == object.binding_two
              instance.a.b.c.should == object.a.b.c
            end
          end
          context 'hash' do
            let( :object ) { data_hash }
            it 'will bind values from hash to corresponding bindings' do
              instance.content.should == object[ :content ]
              instance.binding_one.should == object[ :binding_one ]
              instance.binding_two.should == object[ :binding_two ]
              instance.a.b.c.should == object[ :a ][ :b ][ :c ]
            end
          end
          context 'object' do
            let( :object ) { data_object }
            it 'will bind values from object to corresponding bindings' do
              instance.content.should == object.content
              instance.binding_one.should == object.binding_one
              instance.binding_two.should == object.binding_two
              instance.a.b.c.should == object.a.b.c
            end
          end
        end
        context 'array' do
          let( :instance ) { instance_of_multiple_container_class }
          let( :object ) { multiple_data_objects }
          it 'raises exception since Array has no clear resolution' do
            ::Proc.new { instance.«autobind»( object ) }.should raise_error( ::ArgumentError )
          end
        end
      end
      context 'binding' do
        before( :each ) { instance.«autobind»( object ) }
        let( :instance ) { instance_of_class.a }
        context 'binding' do
          let( :object ) { data_binding }
          let( :instance ) { instance_of_class.•content }
          it 'will set its value to the value of provided binding' do
            instance.«value».should be object.content
          end
        end
        context 'container' do
          let( :object ) { data_container.a }
          it 'will bind values from foreign container bindings to corresponding bindings' do
            instance.b.c.should == object.b.c
          end
        end
        context 'hash' do
          let( :object ) { data_hash[ :a ] }
          it 'will bind values from hash to corresponding bindings' do
            instance.b.c.should == object[ :b ][ :c ]
          end
        end
        context 'object' do
          let( :object ) { data_object.a }
          it 'will bind values from object to corresponding bindings' do
            instance.b.c.should == object.b.c
          end
        end
        context 'array' do
          let( :instance ) { instance_of_multiple_container_class.multiple_binding }
          let( :object ) { multiple_data_objects }
          it 'will treat an array as a list of values to be mapped to multiple containers' do
            instance[ 0 ].should be object[ 0 ]
            instance[ 1 ].should be object[ 1 ]
            instance[ 2 ].should be object[ 2 ]
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
      it 'is an alias for #«autobind»' do
        module_instance.instance_method( :autobind ).should == module_instance.instance_method( :«autobind» )
      end
    end
  
  end

end
