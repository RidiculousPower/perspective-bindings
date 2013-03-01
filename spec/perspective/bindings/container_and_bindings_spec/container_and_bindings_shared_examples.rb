# -*- encoding : utf-8 -*-

shared_examples_for :"self.«name»( base_module )" do
  it 'root container returns its singleton name' do
    root.«name».should == root.name
  end
  it 'nested binding A will return its name (:a)' do
    root.a.«name».should == :a
  end
  it 'nested binding A_B will return its name (:b)' do
    root.a.b.«name».should == :b
  end
  it 'nested binding A_B_C will return its name (:c)' do
    root.a.b.c.«name».should == :c
  end
  it 'nested binding A_B_C_content will return its name (:content)' do
    root.a.b.c.content.«name».should == :content
  end
end

shared_examples_for :"self.«name»( sub_module_and_below )" do
  it_behaves_like( :"self.«name»( base_module )" )
  it 'nested binding content will return its name (:content)' do
    root.content.«name».should == :content
  end
  it 'nested binding binding_one will return its name (:binding_one)' do
    root.binding_one.«name».should == :binding_one
  end
  it 'nested binding binding_two will return its name (:binding_two)' do
    root.binding_two.«name».should == :binding_two
  end
end

shared_examples_for :«name» do
  it 'root container will return root string' do
    root_instance.«name».should be root_instance.«root_string»
  end
  it 'nested binding binding_one will return its name (:binding_one)' do
    root_instance.binding_one.«name».should == :binding_one
  end
  it 'nested binding binding_two will return its name (:binding_two)' do
    root_instance.binding_two.«name».should == :binding_two
  end
  it 'nested binding A_B_C_content will return its name (:content)' do
    root_instance.content.«name».should == :content
  end
  it 'nested binding A will return its name (:a)' do
    root_instance.a.«name».should == :a
  end
  it 'nested container A will return its name (:a)' do
    root_instance.a.«container».«name».should == :a
  end
  it 'nested binding A_B will return its name (:b)' do
    root_instance.a.b.«name».should == :b
  end
  it 'nested container A_B will return its name (:b)' do
    root_instance.a.b.«container».«name».should == :b
  end
  it 'nested binding A_B_C will return its name (:c)' do
    root_instance.a.b.c.«name».should == :c
  end
  it 'nested container A_B_C will return its name (:c)' do
    root_instance.a.b.c.«container».«name».should == :c
  end
  it 'nested binding A_B_C_content will return its name (:c)' do
    root_instance.a.b.c.content.«name».should == :content
  end
end

shared_examples_for :«configure» do
  before :each do
    @configuration_proc = ::Proc.new { configuration_method }
    instance.«configure»( & @configuration_proc )
  end
  it 'will add proc to configuration procs to be run at initialization of container instance' do
    instance.«configuration_procs».last.should be @configuration_proc
  end
end

shared_examples_for :"self.«configure»( base_module )" do
  it_behaves_like( :«configure») { let( :instance ) { root } }
  it_behaves_like( :«configure») { let( :instance ) { root.a } }
  it_behaves_like( :«configure») { let( :instance ) { root.a.b.c } }
  it_behaves_like( :«configure») { let( :instance ) { root.a.b.c.content } }
end

shared_examples_for :"self.«configure»( sub_module_and_below )" do
  it_behaves_like( :"self.«configure»( base_module )" )
  it_behaves_like( :«configure») { let( :instance ) { root.binding_one } }
  it_behaves_like( :«configure») { let( :instance ) { root.binding_two } }
  it_behaves_like( :«configure») { let( :instance ) { root.content } }
end

shared_examples_for :"self.«root»( base_module )" do
  it 'root container returns root' do
    root.«root».should be root
  end
  it 'nested binding A will return root' do
    root.a.«root».should be root
  end
  it 'nested binding A_B will return root' do
    root.a.b.«root».should be root
  end
  it 'nested binding A_B_C will return root' do
    root.a.b.c.«root».should be root
  end
  it 'nested binding A_B_C_content will return root' do
    root.a.b.c.content.«root».should be root
  end
end

shared_examples_for :"self.«root»( sub_module_and_below )" do
  it_behaves_like( :"self.«root»( base_module )" )
  it 'nested binding content will return root' do
    root.content.«root».should be root
  end
  it 'nested binding binding_one will return root' do
    root.binding_one.«root».should be root
  end
  it 'nested binding binding_two will return root' do
    root.binding_two.«root».should be root
  end
  it 'nested binding A_B_C_content will return root' do
    root.a.b.c.content.«root».should be root
  end
end

shared_examples_for :«root» do
  it 'root container will return self' do
    root_instance.«root».should be root_instance
  end
  it 'root container will return root string' do
    root_instance.«root».should be root_instance
  end
  it 'nested binding binding_one will return its name (:binding_one)' do
    root_instance.binding_one.«root».should be root_instance
  end
  it 'nested binding binding_two will return its name (:binding_two)' do
    root_instance.binding_two.«root».should be root_instance
  end
  it 'nested binding A will return root container' do
    root_instance.a.«root».should be root_instance
  end
  it 'nested container A will return root container' do
    root_instance.a.«container».«root».should be root_instance
  end
  it 'nested binding A_B will return root container' do
    root_instance.a.b.«root».should be root_instance
  end
  it 'nested container A_B will return root container' do
    root_instance.a.b.«container».«root».should be root_instance
  end
  it 'nested binding A_B_C will return root container' do
    root_instance.a.b.c.«root».should be root_instance
  end
  it 'nested container A_B_C will return root container' do
    root_instance.a.b.c.«container».«root».should be root_instance
  end
  it 'nested binding A_B_C_content will return root container' do
    root_instance.a.b.c.content.«root».should be root_instance
  end
end

shared_examples_for :"self.«route»( base_module )" do
  it 'root container will return nil' do
    root.«route».should == nil
  end
  it 'nested binding A will return nil' do
    root.a.«route».should == nil
  end
  it 'nested binding A_B will return :a' do
    root.a.b.«route».should == [ :a ]
  end
  it 'nested binding A_B_C will return :a, :b' do
    root.a.b.c.«route».should == [ :a, :b ]
  end
  it 'nested binding A_B_C_content will return :a, :b, :c' do
    root.a.b.c.content.«route».should == [ :a, :b, :c ]
  end
end

shared_examples_for :"self.«route»( sub_module_and_below )" do
  it_behaves_like( :"self.«route»( base_module )" )
  it 'nested binding content will return nil' do
    root.content.«route».should == nil
  end
  it 'nested binding binding_one will return nil' do
    root.binding_one.«route».should == nil
  end
  it 'nested binding binding_two will return nil' do
    root.binding_two.«route».should == nil
  end
end

shared_examples_for :«route» do
  it 'root container will return nil' do
    root_instance.«route».should == nil
  end
  it 'nested binding content will return nil' do
    root_instance.content.«route».should == nil
  end
  it 'nested binding binding_one will return nil' do
    root_instance.binding_one.«route».should == nil
  end
  it 'nested binding binding_two will return nil' do
    root_instance.binding_two.«route».should == nil
  end
  it 'nested binding A will return nil' do
    root_instance.a.«route».should == nil
  end
  it 'nested container A will return nil' do
    root_instance.a.«container».«route».should == nil
  end
  it 'nested binding A_B will return :a' do
    root_instance.a.b.«route».should == [ :a ]
  end
  it 'nested container A_B will return :a' do
    root_instance.a.b.«container».«route».should == [ :a ]
  end
  it 'nested binding A_B_C will return :a, :b' do
    root_instance.a.b.c.«route».should == [ :a, :b ]
  end
  it 'nested container A_B_C will return :a, :b' do
    root_instance.a.b.c.«container».«route».should == [ :a, :b ]
  end
  it 'nested binding A_B_C_content will return :a, :b, :c' do
    root_instance.a.b.c.content.«route».should == [ :a, :b, :c ]
  end
end

shared_examples_for :"self.«route_with_name»( base_module )" do
  it 'root container will return nil' do
    root.«route_with_name».should == nil
  end
  it 'nested binding A will return :a ' do
    root.a.«route_with_name».should == [ :a ]
  end
  it 'nested binding A_B will return :a, :b' do
    root.a.b.«route_with_name».should == [ :a, :b ]
  end
  it 'nested binding A_B_C will return :a, :b, :c' do
    root.a.b.c.«route_with_name».should == [ :a, :b, :c ]
  end
  it 'nested binding A_B_C_content will return :a, :b, :c, :content' do
    root.a.b.c.content.«route_with_name».should == [ :a, :b, :c, :content ]
  end
end

shared_examples_for :"self.«route_with_name»( sub_module_and_below )" do
  it_behaves_like( :"self.«route_with_name»( base_module )" )
  it 'nested binding content will return :content' do
    root.content.«route_with_name».should == [ :content ]
  end
  it 'nested binding binding_one will return :binding_one' do
    root.binding_one.«route_with_name».should == [ :binding_one ]
  end
  it 'nested binding binding_two will return :binding_two' do
    root.binding_two.«route_with_name».should == [ :binding_two ]
  end
end

shared_examples_for :«route_with_name» do
  it 'root container will return nil' do
    root_instance.«route_with_name».should == nil
  end
  it 'nested binding content will return :content' do
    root_instance.content.«route_with_name».should == [ :content ]
  end
  it 'nested binding binding_one will return :binding_one' do
    root_instance.binding_one.«route_with_name».should == [ :binding_one ]
  end
  it 'nested binding binding_two will return :binding_two' do
    root_instance.binding_two.«route_with_name».should == [ :binding_two ]
  end
  it 'nested binding A will return :a ' do
    root_instance.a.«route_with_name».should == [ :a ]
  end
  it 'nested binding A_B will return :a, :b' do
    root_instance.a.b.«route_with_name».should == [ :a, :b ]
  end
  it 'nested binding A_B_C will return :a, :b, :c' do
    root_instance.a.b.c.«route_with_name».should == [ :a, :b, :c ]
  end
  it 'nested binding A_B_C_content will return :a, :b, :c, :content' do
    root_instance.a.b.c.content.«route_with_name».should == [ :a, :b, :c, :content ]
  end
end

shared_examples_for :«nested_route» do
  context 'binding is nested in queried binding' do
    it 'will return the route from queried container to parameter binding' do
      instance.a.b.c.«nested_route»( instance ).should == [ :a, :b ]
    end
  end
  context 'binding is nested in binding under queried binding' do
    it 'will return the route from queried container to parameter binding' do
      instance.a.b.c.«nested_route»( instance.a ).should == [ :b ]
    end
  end
end

shared_examples_for :«root_string» do
  it 'root container will return self as string' do
    instance.«root_string».should == string
  end
  it 'nested binding A will instance as string' do
    instance.a.«root_string».should == string
  end
  it 'nested container A will return instance as string' do
    instance.a.«container».«root_string».should == string
  end
  it 'nested binding A_B will return instance as string' do
    instance.a.b.«root_string».should == string
  end
  it 'nested container A_B will return instance as string' do
    instance.a.b.«container».«root_string».should == string
  end
  it 'nested binding A_B will return instance as string' do
    instance.a.b.c.«root_string».should == string
  end
  it 'nested container A_B will return instance as string' do
    instance.a.b.c.«container».«root_string».should == string
  end
end

shared_examples_for :"self.«route_string»( base_module )" do
  it 'root container will return nil' do
    root.«route_string».should == nil
  end
  it 'nested binding A will return name as route' do
    root.a.«route_string».should == 'a'
  end
  it 'nested binding A_B will return route connected by delimeter' do
    root.a.b.«route_string».should == 'a'<< ::Perspective::Bindings::RouteDelimiter + 'b'
  end
  it 'nested binding A_B_C will return route connected by delimeter' do
    root.a.b.c.«route_string».should == 'a'<< ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
  end
  it 'nested binding A_B_C_content will return route connected by delimeter' do
    root.a.b.c.content.«route_string».should == 'a'<< ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c' << ::Perspective::Bindings::RouteDelimiter + 'content'
  end
end

shared_examples_for :"self.«route_string»( sub_module_and_below )" do
  it_behaves_like( :"self.«route_string»( base_module )" )
  it 'nested binding content will return its name' do
    root.content.«route_string».should == 'content'
  end
  it 'nested binding binding_one will return its name' do
    root.binding_one.«route_string».should == 'binding_one'
  end
  it 'nested binding binding_two will return its name' do
    root.binding_two.«route_string».should == 'binding_two'
  end
end

shared_examples_for :«route_string» do
  it 'root container will return nil' do
    root_instance.«route_string».should == nil
  end
  it 'nested binding content will return nil' do
    root_instance.content.«route».should == nil
  end
  it 'nested binding binding_one will return nil' do
    root_instance.binding_one.«route».should == nil
  end
  it 'nested binding binding_two will return nil' do
    root_instance.binding_two.«route».should == nil
  end
  it 'nested binding A will return its name' do
    root_instance.a.«route_string».should == 'a'
  end
  it 'nested container A will return its name' do
    root_instance.a.«container».«route_string».should == 'a'
  end
  it 'nested binding A_B will return route connected by delimeter' do
    root_instance.a.b.«route_string».should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
  end
  it 'nested container A_B will return route connected by delimeter' do
    root_instance.a.b.«container».«route_string».should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
  end
  it 'nested binding A_B_C will return route connected by delimeter' do
    root_instance.a.b.c.«route_string».should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
  end
  it 'nested container A_B_C will return route connected by delimeter' do
    root_instance.a.b.c.«container».«route_string».should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
  end
  it 'nested binding A_B_C_content will return route connected by delimeter' do
    root_instance.a.b.c.content.«route_string».should == 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c' << ::Perspective::Bindings::RouteDelimiter + 'content'
  end
end

shared_examples_for :"self.«route_print_string»( base_module )" do
  it 'root container will return root string' do
    root.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root.«root_string»
  end
  it 'nested binding A will return root string plus route string' do
    root.a.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root.«root_string» + ::Perspective::Bindings::RouteDelimiter + root.a.«route_string»
  end
  it 'nested binding A_B will return root string plus route string' do
    root.a.b.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root.«root_string» + ::Perspective::Bindings::RouteDelimiter + root.a.b.«route_string»
  end
  it 'nested binding A_B_C will return root string plus route string' do
    root.a.b.c.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root.«root_string» + ::Perspective::Bindings::RouteDelimiter + root.a.b.c.«route_string»
  end
  it 'nested binding A_B_C_content will return root string plus route string' do
    root.a.b.c.content.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root.«root_string» + ::Perspective::Bindings::RouteDelimiter + root.a.b.c.content.«route_string»
  end
end

shared_examples_for :"self.«route_print_string»( sub_module_and_below )" do
  it_behaves_like( :"self.«route_print_string»( base_module )" )
  it 'nested binding content will return root string plus route string' do
    root.content.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root.«root_string» + ::Perspective::Bindings::RouteDelimiter + root.content.«route_string»
  end
  it 'nested binding binding_one will return root string plus route string' do
    root.binding_one.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root.«root_string» + ::Perspective::Bindings::RouteDelimiter + root.binding_one.«route_string»
  end
  it 'nested binding binding_two will return root string plus route string' do
    root.binding_two.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root.«root_string» + ::Perspective::Bindings::RouteDelimiter + root.binding_two.«route_string»
  end
end

shared_examples_for :«route_print_string» do
  it 'root container will return root string' do
    root_instance.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string»
  end
  it 'nested binding binding_one will return root string' do
    root_instance.binding_one.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string» << ::Perspective::Bindings::RouteDelimiter + 'binding_one'
  end
  it 'nested binding binding_two will return root string' do
    root_instance.binding_two.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string» << ::Perspective::Bindings::RouteDelimiter + 'binding_two'
  end
  it 'nested binding content will return root string' do
    root_instance.content.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string» << ::Perspective::Bindings::RouteDelimiter + 'content'
  end
  it 'nested container A will return root string plus route string' do
    root_instance.a.«container».«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string» << ::Perspective::Bindings::RouteDelimiter + 'a'
  end
  it 'nested binding A_B will return root string plus route string' do
    root_instance.a.b.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string» << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
  end
  it 'nested container A_B will return root string plus route string' do
    root_instance.a.b.«container».«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string» << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b'
  end
  it 'nested binding A_B_C will return root string plus route string' do
    root_instance.a.b.c.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string» << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
  end
  it 'nested container A_B_C will return root string plus route string' do
    root_instance.a.b.c.«container».«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string» << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c'
  end
  it 'nested binding A_B_C_content will return root string plus route string' do
    root_instance.a.b.c.content.«route_print_string».should == ::Perspective::Bindings::ContextPrintPrefix + root_instance.«root_string» << ::Perspective::Bindings::RouteDelimiter + 'a' << ::Perspective::Bindings::RouteDelimiter + 'b' << ::Perspective::Bindings::RouteDelimiter + 'c' << ::Perspective::Bindings::RouteDelimiter + 'content'
  end
end

shared_examples_for :"self.«bindings»( base_module )" do
  it 'nested binding A bindings' do
    root.a.«bindings».should == { :b => root.a.b }
    root.a.«bindings»[ :b ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B bindings' do
    root.a.b.«bindings».should == { :c => root.a.b.c }
    root.a.b.«bindings»[ :c ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B_C bindings' do
    root.a.b.c.«bindings».should == { :content => root.a.b.c.content }
    root.a.b.c.«bindings»[ :content ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B_C_content bindings' do
    root.a.b.c.content.«bindings».should == { }
  end
end

shared_examples_for :"self.«bindings»( sub_module_and_below )" do
  it_behaves_like( :"self.«bindings»( base_module )" )
  it 'root container bindings' do
    root.«bindings».should == { :a => root.a,
                                  :content => root.content,
                                  :binding_one => root.binding_one,
                                  :binding_two => root.binding_two }
    root.«bindings»[ :a ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
    root.«bindings»[ :content ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
    root.«bindings»[ :binding_one ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
    root.«bindings»[ :binding_two ].should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding content bindings' do
    root.content.«bindings».should == { }
  end
  it 'nested binding binding_one bindings' do
    root.binding_one.«bindings».should == { }
  end
  it 'nested binding binding_two bindings' do
    root.binding_two.«bindings».should == { }
  end
end

shared_examples_for :«bindings» do
  it 'root container bindings' do
    root_instance.«bindings».should == { :a => root_instance.a,
                                           :content => root_instance.content,
                                           :binding_one => root_instance.binding_one,
                                           :binding_two => root_instance.binding_two }
    root_instance.«bindings»[ :a ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
    root_instance.«bindings»[ :content ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
    root_instance.«bindings»[ :binding_one ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
    root_instance.«bindings»[ :binding_two ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding content bindings' do
    root_instance.content.«bindings».should == { }
  end
  it 'nested binding binding_one bindings' do
    root_instance.binding_one.«bindings».should == { }
  end
  it 'nested binding binding_two bindings' do
    root_instance.binding_two.«bindings».should == { }
  end
  it 'nested binding A bindings' do
    root_instance.a.«bindings».should == { :b => root_instance.a.b }
    root_instance.a.«bindings»[ :b ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B bindings' do
    root_instance.a.b.«bindings».should == { :c => root_instance.a.b.c }
    root_instance.a.b.«bindings»[ :c ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B_C bindings' do
    root_instance.a.b.c.«bindings».should == { :content => root_instance.a.b.c.content }
    root_instance.a.b.c.«bindings»[ :content ].should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B_C_content bindings' do
    root_instance.a.b.c.content.«bindings».should == { }
  end
end

shared_examples_for :"self.«binding»( base_module )" do
  it 'nested binding A' do
    root.«binding»( :a ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A alias' do
    root.«binding»( :a_alias ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B' do
    root.a.«binding»( :b ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B_C' do
    root.a.b.«binding»( :c ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding A_B_C_content' do
    root.a.b.c.«binding»( :content ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
end

shared_examples_for :"self.«binding»( sub_module_and_below )" do
  it_behaves_like( :"self.«binding»( base_module )" )
  it 'nested binding content will return nil' do
    root.«binding»( :content ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding binding_one will return nil' do
    root.«binding»( :binding_one ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
  it 'nested binding binding_two will return nil' do
    root.«binding»( :binding_two ).should be_a ::Perspective::BindingTypes::ContainerBindings::ClassBinding
  end
end

shared_examples_for :«binding» do
  it 'nested binding A' do
    root_instance.«binding»( :a ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B' do
    root_instance.a.«binding»( :b ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B_C' do
    root_instance.a.b.«binding»( :c ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding A_B_C_content' do
    root_instance.a.b.c.«binding»( :content ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end

  it 'nested binding content will return nil' do
    root_instance.«binding»( :content ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding binding_one will return nil' do
    root_instance.«binding»( :binding_one ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
  end
  it 'nested binding binding_two will return nil' do
    root_instance.«binding»( :binding_two ).should be_a ::Perspective::BindingTypes::ContainerBindings::InstanceBinding
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

