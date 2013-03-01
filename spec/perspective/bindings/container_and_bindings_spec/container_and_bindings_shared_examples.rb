
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

shared_examples_for :"self.__bindings__( base_module )" do
  it 'nested binding A bindings' do
    root.a.__bindings__.should == { :b => root.a.b }
    root.a.__bindings__[ :b ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B bindings' do
    root.a.b.__bindings__.should == { :c => root.a.b.c }
    root.a.b.__bindings__[ :c ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B_C bindings' do
    root.a.b.c.__bindings__.should == { :content => root.a.b.c.content }
    root.a.b.c.__bindings__[ :content ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
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
    root.__bindings__[ :a ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
    root.__bindings__[ :content ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
    root.__bindings__[ :binding_one ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
    root.__bindings__[ :binding_two ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
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

shared_examples_for :__bindings__ do
  it 'root container bindings' do
    root_instance.__bindings__.should == { :a => root_instance.a,
                                           :content => root_instance.content,
                                           :binding_one => root_instance.binding_one,
                                           :binding_two => root_instance.binding_two }
    root_instance.__bindings__[ :a ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
    root_instance.__bindings__[ :content ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
    root_instance.__bindings__[ :binding_one ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
    root_instance.__bindings__[ :binding_two ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
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
    root_instance.a.__bindings__[ :b ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B bindings' do
    root_instance.a.b.__bindings__.should == { :c => root_instance.a.b.c }
    root_instance.a.b.__bindings__[ :c ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B_C bindings' do
    root_instance.a.b.c.__bindings__.should == { :content => root_instance.a.b.c.content }
    root_instance.a.b.c.__bindings__[ :content ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B_C_content bindings' do
    root_instance.a.b.c.content.__bindings__.should == { }
  end
end

shared_examples_for :"self.__binding__( base_module )" do
  it 'nested binding A' do
    root.__binding__( :a ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A alias' do
    root.__binding__( :a_alias ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B' do
    root.a.__binding__( :b ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B_C' do
    root.a.b.__binding__( :c ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B_C_content' do
    root.a.b.c.__binding__( :content ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
end

shared_examples_for :"self.__binding__( sub_module_and_below )" do
  it_behaves_like( :"self.__binding__( base_module )" )
  it 'nested binding content will return nil' do
    root.__binding__( :content ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding binding_one will return nil' do
    root.__binding__( :binding_one ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding binding_two will return nil' do
    root.__binding__( :binding_two ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
end

shared_examples_for :__binding__ do
  it 'nested binding A' do
    root_instance.__binding__( :a ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B' do
    root_instance.a.__binding__( :b ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B_C' do
    root_instance.a.b.__binding__( :c ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B_C_content' do
    root_instance.a.b.c.__binding__( :content ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end

  it 'nested binding content will return nil' do
    root_instance.__binding__( :content ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding binding_one will return nil' do
    root_instance.__binding__( :binding_one ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding binding_two will return nil' do
    root_instance.__binding__( :binding_two ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
end

shared_examples_for :"self.has_binding?( base_module )" do
  it 'nested binding A' do
    root.has_binding?( :a ).should be true
  end
  it 'nested binding A alias' do
    root.has_binding?( :a_alias ).should be true
  end
  it 'nested binding A_B' do
    root.a.has_binding?( :b ).should be true
  end
  it 'nested binding A_B_C' do
    root.a.b.has_binding?( :c ).should be true
  end
  it 'nested binding A_B_C_content' do
    root.a.b.c.has_binding?( :content ).should be true
  end
  it 'binding that does not exist' do
    root.has_binding?( :non_existent_binding ).should be false
  end
end

shared_examples_for :"self.has_binding?( sub_module_and_below )" do
  it_behaves_like( :"self.has_binding?( base_module )" )
  it 'nested binding content' do
    root.has_binding?( :content ).should be true
  end
  it 'nested binding binding_one' do
    root.has_binding?( :binding_one ).should be true
  end
  it 'nested binding binding_two' do
    root.has_binding?( :binding_two ).should be true
  end
end

shared_examples_for :has_binding? do
  it 'nested binding A' do
    root_instance.has_binding?( :a ).should be true
  end
  it 'nested binding content' do
    root_instance.has_binding?( :content ).should be true
  end
  it 'nested binding binding_one' do
    root_instance.has_binding?( :binding_one ).should be true
  end
  it 'nested binding binding_two' do
    root_instance.has_binding?( :binding_two ).should be true
  end
  it 'nested binding A alias' do
    root_instance.has_binding?( :a_alias ).should be true
  end
  it 'nested binding A_B' do
    root_instance.a.has_binding?( :b ).should be true
  end
  it 'nested binding A_B_C' do
    root_instance.a.b.has_binding?( :c ).should be true
  end
  it 'nested binding A_B_C_content' do
    root_instance.a.b.c.has_binding?( :content ).should be true
  end
  it 'binding that does not exist' do
    root_instance.has_binding?( :non_existent_binding ).should be false
  end
end

